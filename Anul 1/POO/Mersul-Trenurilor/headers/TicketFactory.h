//
// Created by Alex on 28.05.2024.
//

#ifndef OOP_TICKETFACTORY_H
#define OOP_TICKETFACTORY_H

#include "StudentTicket.h"
#include "RetireeTicket.h"
#include <memory>

class TicketFactory {
public:
    static std::shared_ptr<Ticket> getTicket(int myType, int distance, Station &start, Station &stop);
};


#endif //OOP_TICKETFACTORY_H
