//
// Created by Alex on 15.04.2024.
//

#ifndef OOP_TRAIN_H
#define OOP_TRAIN_H

#include "Railway.h"

class Train {
private:
    int TrainID;
    std::string trainType;
    Railway railway;
    std::vector<Station> stops;
public:
    Train(int trainID_, std::string &type_, Railway &railway_, std::vector<Station> &stops_);

    /// \brief user-defined copy constructor
    Train(const Train &otherTrain);

    Train &operator=(const Train &initialTrain) = default;

    friend std::ostream &operator<<(std::ostream &out, const Train &myTrain);

    [[nodiscard]] const std::vector<Station> &getStops() const;

    [[nodiscard]] int getTrainID() const;



    ~Train() = default;
};

#endif //OOP_TRAIN_H
