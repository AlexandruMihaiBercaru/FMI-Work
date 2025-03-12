//
// Created by Alex on 16.04.2024.
//

#ifndef OOP_NETWORK_H
#define OOP_NETWORK_H

#include <iostream>
#include <vector>
#include "csv.hpp"

/// \class Network
///
/// An abstract class which groups together the input data types.
/// Both the rail lines and the train routes can be viewed as networks
/// (or, technically, directed graphs).
/// The adjacency matrix and the distances matrix are general fields for any of the possible types of networks.
class Network {
protected:
    std::vector<std::vector<int> > connectionsMatrix;
    std::vector<std::vector<int> > distancesMatrix;
public:
    Network() = default;

    Network(std::vector<std::vector<int>> &connectionsMatrix_, std::vector<std::vector<int>> &distancesMatrix_);

    virtual ~Network() = 0;
};


#endif //OOP_NETWORK_H
