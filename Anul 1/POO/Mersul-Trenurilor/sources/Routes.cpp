//
// Created by Alex on 15.04.2024.
//

#include "../headers/Routes.h"
#include <algorithm>

Routes::Routes(std::vector<std::vector<int>> &railConnectionsMatrix_,
               std::vector<std::vector<int>> &railDistancesMatrix, const std::vector<Train> &allTrains_) : Network(railConnectionsMatrix_, railDistancesMatrix), allTrains(allTrains_) {}


void Routes::parseTrainsCSV(RailNetwork& myAlreadyBuiltRailMap) {
    using namespace csv;
    CSVFormat format;
    // Keeping variable-length rows
    format.variable_columns(VariableColumnPolicy::KEEP);
    try{
        std::string filePath = "inputs/trains.csv";
        std::ifstream file;
        file.open(filePath);
        if(!file){
            throw UnknownFileException("Error occured", 1);
        }
        file.close();
        CSVReader trainsReader(filePath, format);
        for (CSVRow& row: trainsReader) {
            Railway currentRailway;
            std::vector<Station> stopsList;
            int trainTempID = row[0].get<int>();
            std::string trainTypeTemp = row[1].get<>();
            int railwayIDTemp = row[2].get<int>();
            auto it = std::find_if(myAlreadyBuiltRailMap.allRailways.begin(), myAlreadyBuiltRailMap.allRailways.end(), [railwayIDTemp](const Railway &railway) {return railway.getRailwayID() == railwayIDTemp;});
            if (it != myAlreadyBuiltRailMap.allRailways.end())
                currentRailway = *it;
            for (int index = 3; index < int(row.size()); index++) {
                std::string currentStop = row[index].get<>();
                auto it2 = std::find_if(myAlreadyBuiltRailMap.allStations.begin(),
                                        myAlreadyBuiltRailMap.allStations.end(), [&currentStop](const Station &obj)
                                        { return obj.getStationName() == currentStop; });
                if (it2 != myAlreadyBuiltRailMap.allStations.end())
                    stopsList.push_back(*it2);
            }
            Train trainTemp(trainTempID, trainTypeTemp, currentRailway, stopsList);
            allTrains.push_back(trainTemp);
        }
    }
    catch(const UnknownFileException &e){
        std::cerr << "ERROR: " << e.what() << std::endl;
        return;
    }
}


void Routes::buildTrainConnectionsDistances(RailNetwork& myAlreadyBuiltRailMap) {
    static const int infinityVal = 0x3F3F3F3F;
    for(auto & train : allTrains) //for each train in allTrains, repeat the sequence
    {
        for(int i = 0; i < int(size(train.getStops())) - 1; i++)
        {
            std::string departureStationName = train.getStops()[i].getStationName();
            std::string arrivalStationName = train.getStops()[i + 1].getStationName();
            int departureStationID{0}, arrivalStationID{0};
            for(auto &elem2 : myAlreadyBuiltRailMap.allStations) //for each station in allStations, repeat the following sequence
            {
                if(elem2.getStationName() == departureStationName)
                    departureStationID = elem2.getStationID(); //the ID becomes the name of a node in the graph
                if(elem2.getStationName() == arrivalStationName)
                    arrivalStationID = elem2.getStationID(); //the ID becomes the name of a node in the graph
            }

            distancesMatrix[departureStationID][arrivalStationID] = myAlreadyBuiltRailMap.distancesMatrix[departureStationID][arrivalStationID];
            distancesMatrix[arrivalStationID][departureStationID] = myAlreadyBuiltRailMap.distancesMatrix[arrivalStationID][departureStationID];
            connectionsMatrix[departureStationID][arrivalStationID] = 1;
            connectionsMatrix[arrivalStationID][departureStationID] = 1;
        }
    }
    //completing the distance matrix by adding infinite
    for(int i = 1; i <= myAlreadyBuiltRailMap.totalStationCount; i++)
    {
        for(int j = 1; j <= myAlreadyBuiltRailMap.totalStationCount; j++)
            if (distancesMatrix[i][j] == 0 && i != j)
                distancesMatrix[i][j] = infinityVal;
    }
    for(int k = 1; k <= myAlreadyBuiltRailMap.totalStationCount; k++)
        for(int i = 1; i <= myAlreadyBuiltRailMap.totalStationCount; i++)
            for(int j = 1; j <= myAlreadyBuiltRailMap.totalStationCount; j++)
            {
                if(i != j && connectionsMatrix[i][j] == 0)
                    connectionsMatrix[i][j] = connectionsMatrix[i][k] * connectionsMatrix[k][j];
                if(distancesMatrix[i][j] > distancesMatrix[i][k] + distancesMatrix[k][j])
                    distancesMatrix[i][j] = distancesMatrix[i][k] + distancesMatrix[k][j];
            }
    // now we have also stored all the train connections and the minimal distances between cities by trains
    // for instance, suppose the shortest path from node A to node C is through node B
    // however, there is no possible combination of trains which runs on the route A-B-C
    // there is only a train running from A to C via D, however the A-D-C path is longer than the A-B-C path
    // for the matrices corresponding to the Routes object, the minimal distance stored is the one of the path A-D-C
}


void Routes::arrivals(std::string &stationName) {
    std::cout << "----ARRIVALS TO: " << stationName << "----\n";
    bool exists = false;
    for (auto &currentTrain: allTrains) {
        auto it = std::find_if(currentTrain.getStops().begin(), currentTrain.getStops().end(),
                               [&stationName](const Station &obj) { return obj.getStationName() == stationName; });
        if (it != currentTrain.getStops().end() && stationName != currentTrain.getStops()[0].getStationName()) //statia apare intre opririle trenului si nu este prima
        {
            exists = true;
            std::cout << currentTrain.getTrainID() << " coming from: ";
            auto index = std::distance(currentTrain.getStops().begin(), it);
            std::cout << currentTrain.getStops()[index - 1].getStationName() << "\n";
        }
    }
    if (!exists)
        std::cout << "Currently there are no arrivals!\n";
}

void Routes::departures(std::string &stationName) {
    std::cout << "\n----DEPARTURES FROM: " << stationName << "----\n";
    bool exists = false;
    for (auto &currentTrain: allTrains) {
        auto it = std::find_if(currentTrain.getStops().begin(), currentTrain.getStops().end(), [&stationName](const Station &obj) { return obj.getStationName() == stationName; });
        int stopsCount = int(currentTrain.getStops().size());
        if (it != currentTrain.getStops().end() && stationName != currentTrain.getStops()[stopsCount -1].getStationName()) //statia apare intre opririle trenului si nu este ultima
        {
            exists = true;
            std::cout << currentTrain.getTrainID() << " going to: ";
            std::cout << currentTrain.getStops()[stopsCount - 1].getStationName() << "\n";
        }
    }
    if (!exists) {
        std::cout << "Currently there are no departures!\n";
    }
}

const std::vector<Train> &Routes::getAllTrains() const {
    return allTrains;
}

void Routes::reconstructPath(int Start, int Stop, RailNetwork &myAlreadyBuiltRailMap, std::vector<int>&path) {
    bool found = false;
    int currentID = 1;
    while(currentID <= myAlreadyBuiltRailMap.totalStationCount && !found)
    {
        if (currentID != Start && currentID != Stop &&
            (distancesMatrix[Start][Stop] == distancesMatrix[Start][currentID] + distancesMatrix[currentID][Stop]))
        {
                reconstructPath(Start, currentID, myAlreadyBuiltRailMap, path);
                reconstructPath(currentID, Stop, myAlreadyBuiltRailMap, path);
                found = true;
        }
        currentID++;
    }
    if(!found)
        path.push_back(Stop);
}

const std::vector<std::vector<int>> &Routes::getRailDistancesMatrix() const {
    return distancesMatrix;
}


Station Routes::findStation(const std::string &city) {
    try
    {
        for(auto &currentTr: allTrains){
            for(auto &currentStop: currentTr.getStops())
                if(currentStop.getStationName() == city){
                    return currentStop;
                }
        }
        throw NoStationException();
    }
    catch(NoStationException &e){
        std::cerr << "\nERROR: " << e.what() << "\n";
        return Station("");
    }
}




