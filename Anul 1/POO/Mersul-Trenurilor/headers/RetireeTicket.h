//
// Created by Alex on 28.05.2024.
//

#ifndef OOP_RETIREETICKET_H
#define OOP_RETIREETICKET_H
#include "Ticket.h"

class RetireeTicket : public Ticket {
private:
    const float discountPct = 0.75;
public:
    void priceCalculator() override;
    RetireeTicket(const Station &departurePlace, const Station &arrivalPlace, int distance);
    RetireeTicket() = default;
};


#endif //OOP_RETIREETICKET_H
