//
// Created by Alex on 16.04.2024.
//

#include "../headers/App.h"

void App::startApp() {
    std::vector<std::vector<int> > connections1 (200, std::vector<int>(200,0));
    std::vector<std::vector<int> > distances1 (200, std::vector<int>(200,0));
    std::vector<std::vector<int> > connections2 (200, std::vector<int>(200,0));
    std::vector<std::vector<int> > distances2 (200, std::vector<int>(200,0));
    std::vector<Station> myStations;
    std::vector<Railway> myRailways;
    std::vector<Train> myTrains;

    std::shared_ptr<Traveller> myUser = std::make_shared<Traveller>();
    Display::initialMessage();

    Network *tempMap = new RailNetwork(connections1, distances1, myRailways, myStations);
    auto *myRailMap = dynamic_cast<RailNetwork*>(tempMap);

    if (myRailMap != nullptr)
    {
        myRailMap->parseRailsCSV();
        myRailMap->addConnectionsAndDistances();
        myRailMap->updateConnectionsCalculateDistances();

        std::shared_ptr<Network> tempTrainMap2;
        tempTrainMap2 = std::make_shared<Routes>(connections2, distances2, myTrains);

        std::shared_ptr<Routes> myTrainMap;
        myTrainMap = std::dynamic_pointer_cast<Routes>(tempTrainMap2);

        if (myTrainMap != nullptr)
        {
            myTrainMap->parseTrainsCSV(*myRailMap);
            myTrainMap->buildTrainConnectionsDistances(*myRailMap);
            const std::vector<std::string> options{"Exit", "1", "2", "3", "4", "5"};

            while(true) {
                bool gaveInput = false;

                while (!gaveInput) {
                    Display::printMenu();
                    std::string keyboardInput;
                    getline(std::cin, keyboardInput);
                    gaveInput = true;
                    try {
                        auto iterator = std::find(options.begin(), options.end(), keyboardInput);
                        if (iterator == options.end())
                            throw MenuOptionException(keyboardInput);
                        auto index = std::distance(options.begin(), iterator);
                        switch (index) {
                            case 0: {
                                return;
                               // break;
                            }
                            case 1: {
                                Display::printNetworkInfos(*myRailMap);
                                break;
                            }
                            case 2: {
                                Display::printArrivals(*myTrainMap);
                                break;
                            }
                            case 3: {
                                Display::printDepartures(*myTrainMap);
                                break;
                            }
                            case 4: {
                                Display::printRoute(*myTrainMap, *myRailMap);
                                break;
                            }
                            case 5 : {
                                Display::buyTicket(*myTrainMap, *myRailMap, *myUser);
                                break;
                            }
                            default:
                                break;
                        }
                    }
                    catch (MenuOptionException &e) {
                        std::cerr << "Error! " << e.what() << std::endl;
                        gaveInput = false; //re-enters while-loop
                    }
                }
            }
        }
        else{
            std::cout << "Second Cast failed" << "\n";
        }
        delete myRailMap;
    }
    else{
        std::cout << "First Cast failed" << "\n";
    }
}
