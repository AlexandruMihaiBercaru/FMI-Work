//
// Created by Alex on 15.04.2024.
//

#include "../headers/Train.h"

Train::Train(int trainID_, std::string &type_, Railway &railway_, std::vector<Station> &stops_) :
        TrainID(trainID_), trainType(type_), railway(railway_), stops(stops_) {}

Train::Train(const Train &otherTrain) {
    this->TrainID = otherTrain.TrainID;
    this->trainType = otherTrain.trainType;
    this->railway = otherTrain.railway;
    this->stops = otherTrain.stops;
}

std::ostream &operator<<(std::ostream &out, const Train &myTrain) {
    out << "\nThe train classified with " << myTrain.trainType << " type and the ID " << myTrain.TrainID
        << " is running on main line " << myTrain.railway.getRailwayID() << " and takes the following stops:\n";
    for (auto &elem: myTrain.stops)
        out << " - " << elem.getStationName() << "\n";
    out << "\n";
    return out;
}

const std::vector<Station> &Train::getStops() const {
    return stops;
}

int Train::getTrainID() const {
    return TrainID;
}
