//
// Created by Alex on 28.05.2024.
//

#ifndef OOP_TRAVELLER_H
#define OOP_TRAVELLER_H

#include <memory>
#include "RetireeTicket.h"
#include "StudentTicket.h"

class Traveller {
private:
    std::vector<std::shared_ptr<Ticket>>tickets;

public:
    Traveller() = default;

    explicit Traveller(const std::vector<std::shared_ptr<Ticket>> &tickets);

    [[nodiscard]] const std::vector<std::shared_ptr<Ticket>> &getTickets() const;

    //void setTickets(const std::vector<std::shared_ptr<Ticket>> &tickets);

    void addTicket(const std::shared_ptr<Ticket> &myTicket);
};


#endif //OOP_TRAVELLER_H
