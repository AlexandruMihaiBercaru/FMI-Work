//
// Created by Alex on 15.04.2024.
//

#ifndef OOP_RAILWAY_H
#define OOP_RAILWAY_H

#include <string>
#include <vector>
#include "Station.h"


/// \Class Railway
/// A railway (or rail line) refers to the physical infrastructure of the rail network. An object of this type conatins 4 fields
class Railway {
private:
    std::vector<Station> stationsOnRailway;
    std::vector<int> distancesBetweenStations;
    /// \brief the ID of the rail line
    int railwayID{0};
    /// \brief the number of stations built on the rail line
    int countStations{0};

public:
    Railway() = default;

    Railway(const std::vector<Station> &stationOnRailway_, const std::vector<int> &distancesBetweenStations_, int railwayID_, int countStations_);

    [[nodiscard]] int railwayLength() const;

    [[nodiscard]] int getRailwayID() const;

    friend std::ostream &operator<<(std::ostream &out, const Railway &myRailway);
    friend class RailNetwork;
};

#endif //OOP_RAILWAY_H
