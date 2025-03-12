//
// Created by Alex on 28.05.2024.
//

#ifndef OOP_UNKNOWNFILEEXCEPTION_H
#define OOP_UNKNOWNFILEEXCEPTION_H


#include <stdexcept>

class UnknownFileException : public std::runtime_error{
private:
    int flag;
public:
    explicit UnknownFileException(const std::string &arg, int flag_) : runtime_error(arg), flag(flag_) {}

    [[nodiscard]] const char* what() const noexcept override {
        switch(flag) {
            case 0: {
                return "Input file for rail networks not found! Maybe try railway_lines.csv?";
            }
            case 1: {
                return "Input file for trains not found! Maybe try trains.csv?";
            }
            default:{
                return "What!?";
            }
        }
    }
};


#endif //OOP_UNKNOWNFILEEXCEPTION_H
