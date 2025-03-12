//
// Created by Alex on 15.04.2024.
//

#ifndef OOP_DISPLAY_H
#define OOP_DISPLAY_H

#include <iostream>
#include "Routes.h"
#include "RailNetwork.h"
#include "Traveller.h"
#include "TicketFactory.h"
#include <vector>


class Display {
public:
    static void initialMessage();
    static void printMenu();
    static void printNetworkInfos(RailNetwork &railMap);
    static void printArrivals(Routes &myRoutes);
    static void printDepartures(Routes &myRoutes);
    static void printRoute(Routes &myRoutes, RailNetwork &railMap);
    static void buyTicket(Routes &myRoutes, RailNetwork &railMap, Traveller &user);
    static void findStationsFromInput(Station &start, Station &stop, Routes &myRoutes);
};


#endif //OOP_DISPLAY_H
