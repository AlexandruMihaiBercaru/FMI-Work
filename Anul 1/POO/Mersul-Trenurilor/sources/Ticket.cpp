//
// Created by Alex on 28.05.2024.
//

#include "../headers/Ticket.h"

Ticket::Ticket(const Station &departurePlace, const Station &arrivalPlace, int distance)
        : departurePlace(departurePlace), arrivalPlace(arrivalPlace), distance(distance) {}

float Ticket::standardPricePerKm = 0.3;

void Ticket::priceCalculator() {
    totalPrice = standardPricePerKm * static_cast<float>(distance);
}



