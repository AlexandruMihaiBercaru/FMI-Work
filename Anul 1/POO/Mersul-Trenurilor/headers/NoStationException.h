//
// Created by Alex on 28.05.2024.
//

#ifndef OOP_NOSTATIONEXCEPTION_H
#define OOP_NOSTATIONEXCEPTION_H


class NoStationException : public std::exception{
public:
    [[nodiscard]] const char * what() const noexcept override{
        return "There is no such station... Try again";
    }
};


#endif //OOP_NOSTATIONEXCEPTION_H
