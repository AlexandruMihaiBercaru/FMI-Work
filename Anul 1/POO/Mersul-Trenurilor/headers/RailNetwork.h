//
// Created by Alex on 15.04.2024.
//

#ifndef OOP_RAILNETWORK_H
#define OOP_RAILNETWORK_H

#include <iostream>
#include <fstream>
#include <vector>
#include "Railway.h"
#include "Network.h"
#include "UnknownFileException.h"
#include "NoStationException.h"

class RailNetwork : public Network{
private:

    int totalStationCount{0};
    std::vector<Railway> allRailways;
    std::vector<Station> allStations;
public:

    RailNetwork()=default;



    RailNetwork(std::vector< std::vector<int> >&connectionsMatrix_, std::vector< std::vector<int> >&distancesMatrix_, const std::vector<Railway> &allRailways_, const std::vector<Station> &allStations_);

    void parseRailsCSV();

    void addConnectionsAndDistances();

    void updateConnectionsCalculateDistances();

    friend std::ostream &operator<<(std::ostream &out, const RailNetwork &myMap);

    void printDistancesFromStation(const std::string &myStationName);

    [[nodiscard]] const std::vector<Railway> &getAllRailways() const;

    [[nodiscard]] const std::vector<Station> &getAllStations() const;

    friend class Routes;

};


#endif //OOP_RAILNETWORK_H
