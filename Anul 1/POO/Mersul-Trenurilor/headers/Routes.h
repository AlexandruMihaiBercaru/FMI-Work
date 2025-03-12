//
// Created by Alex on 15.04.2024.
//

#ifndef OOP_ROUTES_H
#define OOP_ROUTES_H

#include <iostream>
#include "Train.h"
#include "RailNetwork.h"

class Routes : public Network{
    std::vector<Train> allTrains;
public:

    Routes() = default;



    [[maybe_unused]] explicit Routes(std::vector<std::vector<int>> &railConnectionsMatrix_, std::vector<std::vector<int>> &raildistancesMatrix, const std::vector<Train> &allTrains_);

    void buildTrainConnectionsDistances(RailNetwork& myAlreadyBuiltRailMap);

    void parseTrainsCSV(RailNetwork& myAlreadyBuiltRailMap);

    void arrivals(std::string &stationName);

    void departures(std::string &stationName);

    [[nodiscard]] const std::vector<Train> &getAllTrains() const;

    void reconstructPath(int Start, int Stop, RailNetwork& myAlreadyBuiltRailMap, std::vector<int>&path);

    [[nodiscard]] const std::vector<std::vector<int>> &getRailDistancesMatrix() const;

    Station findStation(const std::string& city);


};

#endif //OOP_ROUTES_H
