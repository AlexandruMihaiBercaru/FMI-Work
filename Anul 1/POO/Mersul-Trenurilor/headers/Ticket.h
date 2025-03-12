//
// Created by Alex on 28.05.2024.
//

#ifndef OOP_TICKET_H
#define OOP_TICKET_H

#include "Station.h"

class Ticket {
protected:
    static float standardPricePerKm;
    Station departurePlace;
    Station arrivalPlace;
    float totalPrice{};
    int distance{};
public:
    Ticket() = default;

    Ticket(const Station &departurePlace, const Station &arrivalPlace, int distance);

    virtual void priceCalculator();

    virtual ~Ticket() = default;
};


#endif //OOP_TICKET_H
