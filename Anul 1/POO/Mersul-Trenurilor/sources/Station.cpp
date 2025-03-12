//
// Created by Alex on 15.04.2024.
//

#include "../headers/Station.h"



Station::Station(const std::string& name_) : stationName(name_), stationID(staticID) { ++staticID;}

const std::string &Station::getStationName() const {
    return stationName;
}

int Station::getStationID() const {
    return stationID;
}

std::ostream &operator<<(std::ostream &out, const Station &myStation) {
    out << myStation.stationName;
    return out;
}

int Station::staticID = 1;

Station& Station::operator=(const Station &other) {
    this->stationName = other.stationName;
    this->stationID = other.stationID;
    return *this;
}


