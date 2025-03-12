//
// Created by Alex on 28.05.2024.
//

#ifndef OOP_STUDENTTICKET_H
#define OOP_STUDENTTICKET_H

#include "Ticket.h"
class StudentTicket : public Ticket{
private:


    const float discountPct = 0.9;
public:
    void priceCalculator() override;
    StudentTicket(const Station &departurePlace, const Station &arrivalPlace, int distance);
    StudentTicket() = default;
};


#endif //OOP_STUDENTTICKET_H
