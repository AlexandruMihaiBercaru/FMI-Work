//
// Created by Alex on 15.04.2024.
//

#include "../headers/Railway.h"

Railway::Railway(const std::vector<Station> &stationOnRailway_, const std::vector<int> &distancesBetweenStations_, int railwayID_, int countStations_)
        : stationsOnRailway(stationOnRailway_), distancesBetweenStations(distancesBetweenStations_), railwayID(railwayID_), countStations(countStations_) {}


int Railway::railwayLength() const {
    int totalLength = 0;
    for (int i: distancesBetweenStations)
        totalLength += i;
    return totalLength;
}

int Railway::getRailwayID() const {
    return railwayID;
}

std::ostream &operator<<(std::ostream &out, const Railway &myRailway) {
    out << "\n\tLINE " << myRailway.railwayID << ": \n\tLENGTH: " << myRailway.railwayLength() << " km; \n\tSTATIONS: ";
    for (int i = 0; i < myRailway.countStations - 1; i++)
        out << myRailway.stationsOnRailway[i].getStationName() << " - ";
    out << myRailway.stationsOnRailway[myRailway.countStations - 1].getStationName() << "\n";
    return out;
}

