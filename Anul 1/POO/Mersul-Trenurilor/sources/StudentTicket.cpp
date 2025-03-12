//
// Created by Alex on 28.05.2024.
//

#include "../headers/StudentTicket.h"

void StudentTicket::priceCalculator() {
    totalPrice = (1-discountPct) * standardPricePerKm * static_cast<float>(distance);
}

StudentTicket::StudentTicket(const Station &departurePlace, const Station &arrivalPlace, int distance) : Ticket(departurePlace, arrivalPlace, distance){}
