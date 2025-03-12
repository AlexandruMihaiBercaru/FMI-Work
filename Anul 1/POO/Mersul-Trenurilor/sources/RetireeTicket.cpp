//
// Created by Alex on 28.05.2024.
//

#include "../headers/RetireeTicket.h"

void RetireeTicket::priceCalculator() {
    totalPrice = (1-discountPct) * standardPricePerKm * static_cast<float>(distance);
}

RetireeTicket::RetireeTicket(const Station &departurePlace, const Station &arrivalPlace, int distance) : Ticket(
        departurePlace, arrivalPlace, distance) {}
