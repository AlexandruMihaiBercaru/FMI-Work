//
// Created by Alex on 16.04.2024.
//

#include "../headers/Network.h"

Network::Network( std::vector<std::vector<int>> &connectionsMatrix_, std::vector<std::vector<int>> &distancesMatrix_) :
                   connectionsMatrix(connectionsMatrix_), distancesMatrix(distancesMatrix_) {}

Network::~Network() = default;