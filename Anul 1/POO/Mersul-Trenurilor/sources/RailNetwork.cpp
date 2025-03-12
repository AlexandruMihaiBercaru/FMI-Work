//
// Created by Alex on 15.04.2024.
//

#include "../headers/RailNetwork.h"


 RailNetwork::RailNetwork(std::vector<std::vector<int>> &connectionsMatrix_,
                         std::vector<std::vector<int>> &distancesMatrix_,
                         const std::vector<Railway> &allRailways_, const std::vector<Station> &allStations_) :
                         Network(connectionsMatrix_, distancesMatrix_),
                         allRailways(allRailways_), allStations(allStations_){}


void RailNetwork::parseRailsCSV() {
    using namespace csv;
    CSVFormat format;
    // Keeping variable-length rows
    format.variable_columns(VariableColumnPolicy::KEEP);
    try{
        /// first, check if the file exists...!
        std::string filePath = "inputs/railway_lines.csv";
        std::ifstream file;
        file.open(filePath);
        if(!file){
            throw UnknownFileException("Error occured", 0);
        }
        file.close();
        CSVReader railwaysReader(filePath, format);
        /// for each line of the railway_lines file, a new Railway object is created;
        /// the vector containing all the stations in the network gets updated when a new station is found
        for (CSVRow& row: railwaysReader) { // Iterator for a line of the file
            std::vector<Station> stationsOnRailway;
            std::vector<int> distancesOnRailway;
            int railwayIDTemp = row[0].get<int>();
            int stationCount = row[1].get<int>();
            for(int index = 2; index < stationCount + 2; index++)
            {
                Station *foundStation;
                std::string currentStationName = row[index].get<>();
                bool exists = false;
                for (auto & station: allStations)
                {
                    if (station.getStationName() == currentStationName)
                    {
                        exists = true;
                        foundStation = &station;
                        break;
                    }
                }
                if (exists)
                {
                    //the station already exists in allStations
                    Station currentStation;
                    currentStation = *foundStation;
                    stationsOnRailway.emplace_back(currentStation);
                }
                else ///station has not been added yet
                {
                    Station stationTemp(currentStationName); /// a new object has been created, staticId increments by 1
                    allStations.emplace_back(stationTemp);
                    stationsOnRailway.emplace_back(stationTemp);
                }
            }
            for(int index = 2 + stationCount; index < 2 * stationCount + 1; index++)
                distancesOnRailway.emplace_back(row[index].get<int>());
            Railway railwayTemp(stationsOnRailway, distancesOnRailway, railwayIDTemp, stationCount);
            allRailways.emplace_back(railwayTemp);
        }
        this->totalStationCount = int(allStations.size());
    }
    catch(const UnknownFileException &e){
        std::cerr << "ERROR: " << e.what() << std::endl;
        return;
    }
}


void RailNetwork::addConnectionsAndDistances() {
    static const int infinityVal = 0x3F3F3F3F;
    for(auto & elem : allRailways) //for each railway in allRailways, repeat the sequence
    {
        for(int i = 0; i < elem.countStations - 1; i++)
        {
            std::string departureStationName = elem.stationsOnRailway[i].getStationName();
            std::string arrivalStationName = elem.stationsOnRailway[i + 1].getStationName();
            int departureStationID{0}, arrivalStationID{0};
            for(auto &elem2 : allStations) //for each station in allStations, repeat the following sequence
            {
                if(elem2.getStationName() == departureStationName)
                    departureStationID = elem2.getStationID(); //the ID becomes the name of a node in the graph
                if(elem2.getStationName() == arrivalStationName)
                    arrivalStationID = elem2.getStationID(); //the ID becomes the name of a node in the graph
            }
            distancesMatrix[departureStationID][arrivalStationID] = elem.distancesBetweenStations[i];
            distancesMatrix[arrivalStationID][departureStationID] = elem.distancesBetweenStations[i];
            connectionsMatrix[departureStationID][arrivalStationID] = 1;
            connectionsMatrix[arrivalStationID][departureStationID] = 1;
        }
    }
    //completing the distance matrix by adding infinite
    for(int i = 1; i <= totalStationCount; i++)
    {
        for(int j = 1; j <= totalStationCount; j++)
            if (distancesMatrix[i][j] == 0 && i != j)
                distancesMatrix[i][j] = infinityVal;
    }
}


void RailNetwork::updateConnectionsCalculateDistances() //connections matrix now contains 1 if there is a road from i to j + distances matrix contains the shortest path between node i and j (if there is one)
{
    for(int k = 1; k <= totalStationCount; k++)
        for(int i = 1; i <= totalStationCount; i++)
            for(int j = 1; j <= totalStationCount; j++)
            {
                if(i != j && connectionsMatrix[i][j] == 0)
                    connectionsMatrix[i][j] = connectionsMatrix[i][k] * connectionsMatrix[k][j];
                if(distancesMatrix[i][j] > distancesMatrix[i][k] + distancesMatrix[k][j])
                    distancesMatrix[i][j] = distancesMatrix[i][k] + distancesMatrix[k][j];
            }
}


std::ostream &operator<<(std::ostream &out, const RailNetwork &myMap) {
    out<<"\n\t\t--------MINIMAL RAIL DISTANCES:--------\n";
    for(int i = 1; i <= myMap.totalStationCount; i++)
    {
        out <<"\t\tFROM: " << myMap.allStations[i - 1].getStationName() << " TO: \n\t\t";
        for(int j = 1; j <= myMap.totalStationCount; j++)
            if(myMap.distancesMatrix[i][j] != 0 && myMap.distancesMatrix[i][j] != 0x3F3F3F3F)
                out << " - " << myMap.allStations[j - 1].getStationName() << ": " << myMap.distancesMatrix[i][j] << " km;\n\t\t";
        out << "\n";
    }
    return out;
}


void RailNetwork::printDistancesFromStation(const std::string &myStationName) {
    bool found = false;
    int myStationID{0};
    for(auto &elem: allStations) {
        if (elem.getStationName() == myStationName)
        {found = true; myStationID = elem.getStationID();}
    }
    if (!found)
        std::cout<<"\nThe station does not exist, try again...";
    else {
        std::cout << "\n\t----MINIMAL DISTANCES ON RAIL----\n\t    FROM " << myStationName << " TO: \n";
        for(int j = 1; j <= totalStationCount; j++)
            if(distancesMatrix[myStationID][j] != 0 && distancesMatrix[myStationID][j] != 0x3F3F3F3F)
                std::cout << "\t - " << allStations[j - 1].getStationName() << ": " << distancesMatrix[myStationID][j] << " km;\n";
    }
}


const std::vector<Railway> &RailNetwork::getAllRailways() const {
    return allRailways;
}

const std::vector<Station> &RailNetwork::getAllStations() const {
    return allStations;
}







