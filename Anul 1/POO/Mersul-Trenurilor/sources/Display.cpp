//
// Created by Alex on 15.04.2024.
//

#include "../headers/Display.h"

void Display::printMenu() {
    std::cout << "\t\t\t\n\n\tChoose an option (type 1/2/3/4):\n\n";
    std::cout << "\t1. Print info about the rail network (the lines and the minimal distances on rail between stations)\n";
    std::cout << "\t2. Arrivals to a given station\n";
    std::cout << "\t3. Departures from a given station\n";
    std::cout << "\t4. Find a train route between two given stations\n";
    std::cout << "\t5. Buy ticket\n";
    std::cout << "\n\n\t[Type 'Exit' to leave.]\n";
    std::cout << "\n\tYour input: \n";
}

void Display::printNetworkInfos(RailNetwork &railMap) {
    for (const auto &elem: railMap.getAllRailways())
        operator<<(std::cout, elem);
    std::cout << "\nType the name of a starting station to find the rail distances:\n";
    std::string myStation;
    std::getline(std::cin, myStation);
    railMap.printDistancesFromStation(myStation);
}

void Display::printArrivals(Routes &myRoutes) {
    std::string myInput;
    bool isCorrect = false;
    while(!isCorrect){
        std::cout << "\nType the name of a station:\n";

        std::getline(std::cin, myInput);
        isCorrect = true;

        Station tempStation = myRoutes.findStation(myInput);
        /// if there is no Station with the given name, findStation prints an error message
        /// and returns a Station object with the name an empty string
        if(tempStation.getStationName().empty())
            isCorrect = false;
    }

    myRoutes.arrivals(myInput);
    std::cout<< "\nTo find out further details about a train, type its train ID, or type 'Back' to return to the main menu.\n";

    std::getline(std::cin, myInput);
    if (myInput == (std::string) "Back")
        return;
    else {
        int input = std::stoi(myInput);
        for (auto &crtTrain: myRoutes.getAllTrains())
            if (input == crtTrain.getTrainID())
                std::cout << crtTrain;
    }
}

void Display::printDepartures(Routes &myRoutes) {
    std::string myInput;
    bool isCorrect = false;
    while(!isCorrect){
        std::cout << "\nType the name of a station:\n";

        std::getline(std::cin, myInput);
        isCorrect = true;

        Station tempStation = myRoutes.findStation(myInput);
        /// if there is no Station with the given name, findStation prints an error message
        /// and returns a Station object with the name an empty string
        if(tempStation.getStationName().empty())
            isCorrect = false;
    }
    myRoutes.departures(myInput);
    std::cout<< "\nTo find out further details about a train, type its train ID, or type 'Back' to return to the main menu.\n";
    std::getline(std::cin, myInput);
    if (myInput == (std::string) "Back")
        return;
    else {
        int input = std::stoi(myInput);
        for (auto &crtTrain: myRoutes.getAllTrains())
            if (input == crtTrain.getTrainID())
                std::cout << crtTrain;
    }
}

void Display::initialMessage() {
    std::cout << "\n\t\tWelcome...";
}


void Display::findStationsFromInput(Station &startStation, Station &stopStation, Routes &myRoutes) {
    std::string myStartCity, myStopCity;
    bool isCorrect = false;
    std::cout << "\nType the name of the starting station:\n";
    while(!isCorrect){
        std::getline(std::cin, myStartCity);
        isCorrect = true;

        startStation = myRoutes.findStation(myStartCity);
        /// if there is no Station with the given name, findStation prints an error message
        /// and returns a Station object with the name an empty string
        if(startStation.getStationName().empty())
        {
            isCorrect = false;
            std::cout << "\nType the name of the starting station:\n";
        }
    }

    isCorrect = false;
    std::cout << "\nType the name of the stopping station:\n";
    while(!isCorrect){
        std::getline(std::cin, myStopCity);
        isCorrect = true;

        stopStation = myRoutes.findStation(myStopCity);
        /// if there is no Station with the given name, findStation prints an error message
        /// and returns a Station object with the name an empty string
        if(stopStation.getStationName().empty())
        {
            isCorrect = false;
            std::cout << "\nType the name of the stopping station:\n";
        }
    }
}


void Display::printRoute(Routes &myRoutes, RailNetwork &railMap) {

    std::vector<int> myPath(200, 0);
    Station startStation, stopStation;

    findStationsFromInput(startStation, stopStation, myRoutes);

    int departureStationID = startStation.getStationID();
    int arrivalStationID = stopStation.getStationID();
    int routeLength = myRoutes.getRailDistancesMatrix()[departureStationID][arrivalStationID];
    if(routeLength <  0x3F3F3F3F)
    {
        std::cout << "\t\t\t||\tROUTE FOUND!\n\t\t\t||\tLENGTH: " << routeLength << " km\n\t\t\t||\tTHE PATH:\n\t\t\t\t|-->" << startStation.getStationName();
        myRoutes.reconstructPath(departureStationID, arrivalStationID, railMap, myPath);
        for(auto &elem: myPath)
        {
            std::string cityName;
            for(auto &elem2 : railMap.getAllStations()) {
                if (elem2.getStationID() == elem)
                {
                    cityName = elem2.getStationName();
                    std::cout << "\n\t\t\t\t|-->" << cityName ;
                }
            }
        }
    }
    else
    {
        std::cout << "\n\n\t\t\t\tNO ROUTE FOUND!\n";
    }
}

void Display::buyTicket(Routes &myRoutes, RailNetwork &railMap, Traveller &user) {

    std::vector<int> myPath(200, 0);
    Station startStation, stopStation;
    findStationsFromInput(startStation, stopStation, myRoutes);

    int departureStationID = startStation.getStationID();
    int arrivalStationID = stopStation.getStationID();
    int routeLength = myRoutes.getRailDistancesMatrix()[departureStationID][arrivalStationID];

    if(routeLength <  0x3F3F3F3F){
        std::cout << "\n\n\t\t\t\tROUTE FOUND!\n";
        myRoutes.reconstructPath(departureStationID, arrivalStationID, railMap, myPath);

        std::cout << "Choose a ticket category(1-Student, 2-Retiree, 3-FullPrice)\n";
        int option;

        bool goodOption = false;
        while(!goodOption){
            std::cin >> option;
            goodOption = true;
            if(option < 1 or option > 3){
                goodOption = false;

            }
            else{
                std::shared_ptr<Ticket> myTempTicket = TicketFactory::getTicket(option, routeLength, startStation, stopStation);
                myTempTicket = std::make_shared<Ticket>();
                user.addTicket(myTempTicket);
            }
        }
    }
    else{
        std::cout << "\n\n\t\t\t\tNO ROUTE FOUND!\n";
        return;
    }
}

