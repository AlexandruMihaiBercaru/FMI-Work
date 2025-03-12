//
// Created by Alex on 15.04.2024.
//

#ifndef OOP_STATION_H
#define OOP_STATION_H

#include <iostream>
#include <vector>
/// \class Station
///
/// A class used for memorizing the stations on the main lines of the network. Contains two fields, the station name and its ID
/// The static ID is used for generating an different ID for each new station
class Station {
private:
    /// \brief A string referring to the name of a city in which the station is placed
    std::string stationName;
    /// \brief An ID for each station. When a new station name is read from the input file, a new ID is generated. This ID
    /// is used for easily memorise the stations in an adjacency matrix and cost matrix, needed to calculate the minimal distances between stations.
    int stationID{};
    static int staticID;
public:

    /// \brief default constructor
    explicit Station() = default;

    /// \brief explicit constructor
    /// \param name_ the station name
    explicit Station(const std::string& name_);

    /// \brief getter for stationName field
    [[nodiscard]] const std::string &getStationName() const;

    /// \brief getter for stationID field
    [[nodiscard]] int getStationID() const;

    /// \brief overloading the output operator
    friend std::ostream &operator<<(std::ostream &out, const Station &myStation);

    /// \brief copy constructor
    Station(const Station& other) = default;

    /// \brief assigment operator
    Station& operator=(const Station& other);

};

#endif //OOP_STATION_H
