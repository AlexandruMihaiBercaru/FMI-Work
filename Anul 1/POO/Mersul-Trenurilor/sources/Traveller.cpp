//
// Created by Alex on 28.05.2024.
//

#include "../headers/Traveller.h"

Traveller::Traveller(const std::vector<std::shared_ptr<Ticket>> &tickets) : tickets(tickets) {}

const std::vector<std::shared_ptr<Ticket>> &Traveller::getTickets() const {
    return tickets;
}

//void Traveller::setTickets(const std::vector<std::shared_ptr<Ticket>> &tickets) {
//    Traveller::tickets = tickets;
//}

void Traveller::addTicket(const std::shared_ptr<Ticket> &myTicket) {
    tickets.push_back(myTicket);
}
