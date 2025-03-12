//
// Created by Alex on 28.05.2024.
//

#include "../headers/TicketFactory.h"

std::shared_ptr<Ticket> TicketFactory::getTicket(int myType, int distance, Station &start, Station &stop) {
    std::shared_ptr<Ticket> producedTicket;
    switch(myType){
        case 1: {
            producedTicket = std::make_shared<StudentTicket>(start, stop, distance);
            break;
        }
        case 2: {
            producedTicket = std::make_shared<RetireeTicket>(start, stop, distance);
            break;
        }
        case 3: {
            producedTicket = std::make_shared<Ticket>(start, stop, distance);
            break;
        }
        default: {
            std::cout << "Wrong option..." << "\n";
            return nullptr;
        }
    }
    producedTicket->priceCalculator();
    return producedTicket;
}
