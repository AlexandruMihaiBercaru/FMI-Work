//
// Created by Alex on 28.05.2024.
//

#ifndef OOP_MENUOPTIONEXCEPTION_H
#define OOP_MENUOPTIONEXCEPTION_H
#include <cstring>

class MenuOptionException : public std::exception {
private:
    std::string myOption;
public:
    explicit MenuOptionException(const std::string& myOption_) : myOption(myOption_) {}
    [[nodiscard]] const char * what() const noexcept override{
        return "Your input does not correspond to any of the possible options. Try again...";
    }
};


#endif //OOP_MENUOPTIONEXCEPTION_H
