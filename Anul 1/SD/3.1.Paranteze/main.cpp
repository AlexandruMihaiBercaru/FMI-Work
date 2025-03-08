#include <iostream>
#include <cstring>
class Nod{
public:
    Nod *prev;
    char info;
    Nod *next;
    explicit Nod(char info_):info(info_){
        prev = nullptr; next = nullptr;
    }
};

class List{
private:
    Nod *head;
public:
    List() {
        head = nullptr;
    };
    //inserare (push)
    void prepend(char cheie_de_inserat){
        Nod *nod_de_inserat = new Nod(cheie_de_inserat);
        nod_de_inserat->next = head;
        nod_de_inserat->prev = nullptr;
        if(head != nullptr){
            head->prev = nod_de_inserat;
        }
        head = nod_de_inserat;
    }
    /// stergere (pop)
    char sterge_cap(){
        char info_sters = head->info;
        if (head->next != nullptr)
            head->next->prev = head->prev;
        head = head->next;
        return info_sters;
    }
    [[nodiscard]] Nod *getHead() const {
        return head;
    }
};


class Stack{
private:
    int nr_elem;
    List* list;
public:
    explicit Stack() {
        nr_elem = 0;
        list = new List;
    }
    void push(char elem){
        list->prepend(elem);
        nr_elem += 1;
        //list->afisare_elemente();
    }
    char pop(){
        char p = list->sterge_cap();
        nr_elem -= 1;
        return p;
    }
    char top_of_stack(){
        char top = list->sterge_cap();
        list->prepend(top);
        return top;
    }
    [[nodiscard]] bool is_empty() const{
        return nr_elem == 0;
    }

    [[nodiscard]] int getNrElem() const {
        return nr_elem;
    }

    ~Stack(){
        delete list;
    }

};

int main() {
    Stack myStack;
    char paranteze[100];
    std::cout << "Introduceti un sir de paranteze:";
    std::cin >> paranteze;
    int ok=1;
    int nr_paranteze = std::strlen(paranteze);
    for(int i = 0; i < nr_paranteze; i++){
        //daca este paranteza deschisa
        if(std::strchr("[{(", paranteze[i])){
            myStack.push(paranteze[i]);
        }
        //daca este paranteza inchisa
        else{
            char varf = myStack.top_of_stack();
            if( ( paranteze[i] == ')' && varf == '(' )
                || ( paranteze[i] == ']' && varf == '[' )
                || ( paranteze[i] == '}' && varf == '{' ) )
            {
                char x = myStack.pop();
            }
            else{
                std::cout << "Parantezare gresita.\n";
                ok = 0;
                break;

            }
        }
    }
    if(ok)
        std::cout << "Parantezare corecta.\n";
    //std::cout << myStack.is_empty();
    return 0;
}
