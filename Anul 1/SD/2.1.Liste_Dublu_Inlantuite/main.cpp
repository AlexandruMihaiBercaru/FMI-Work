#include <iostream>
#include <new>
class Nod{
public:
    Nod *prev;
    int info;
    Nod *next;
    //Nod() = default;
    explicit Nod(int info_):info(info_){
        prev = nullptr;
        next = nullptr;
    }
};

class listaDubla{
private:
    /// capul listei
    Nod *head;
public:
    // crearea unui obiect de tip listaDubla => se initializeaza lista, head este un pointer
    // care arata catre capul listei (catre null)
    listaDubla() {
        head = nullptr;
    };

    /// afisarea cheilor
    void afisare_elemente(){
        std::cout << "Elementele listei: \n";
        Nod *nod_curent;
        nod_curent = head;
        if(nod_curent == nullptr)
        {   std::cout<<"Lista este vida.!";}
        while(nod_curent != nullptr)
        {
            std::cout << nod_curent -> info << " ";
            nod_curent = nod_curent -> next;
        }
        std::cout<<"\n\n";
        delete nod_curent;
    }

    ///inserare in capul listei (prin cheie)
    void prepend(int cheie_de_inserat){
        Nod *nod_de_inserat = new Nod(cheie_de_inserat);
        nod_de_inserat->next = head;
        nod_de_inserat->prev = nullptr;
        if(head != nullptr){
            head->prev = nod_de_inserat;
        }
        head = nod_de_inserat;
    }

    /// inserare dupa un nod dat (prin cheie)
    static void inserare(int cheie_de_inserat, Nod* y){
        Nod *nod_de_inserat = new Nod(cheie_de_inserat);
        nod_de_inserat->next = y->next;
        nod_de_inserat->prev = y;
        if(y->next != nullptr){
            y->next->prev = nod_de_inserat;
        }
        y->next = nod_de_inserat;
    }

    /// cautarea unui nod, dandu-se cheia
    Nod* cautare_nod(int key, int& poz){
        Nod *x = head;
        while(x != nullptr && x->info != key){
            x = x -> next;
            poz++;
        }
        return x;
    }

    /// stergerea unui nod dat ca parametru (foloseste cautarea)
    void sterge_nod(Nod *x){
        if(x->prev != nullptr){
            x->prev->next = x->next;
        }
        else //inseamna ca x era capul listei
            head = x->next;
        if (x->next != nullptr)
            x->next->prev = x->prev;
    }

};

void afisMeniu(){
    std::cout<<"\n\n";
    std::cout << "|--------------------------------------------|\n";
    std::cout << "|1. Afiseaza continutul listei               |\n";
    std::cout << "|2. Cauta un element                         |\n";
    std::cout << "|3. Insereaza un element in capul listei     |\n";
    std::cout << "|4. Insereaza un element dupa un nod anume   |\n";
    std::cout << "|5. Sterge un element din lista              |\n";
    std::cout << "|0. Inchide meniul                           |\n";
    std::cout << "|--------------------------------------------|\n";
    std::cout << "|   Alegeti o optiune:                       |\n";
    std::cout << "|--------------------------------------------|\n";
    std::cout << "...\n\n\n";
}

int main() {
    listaDubla L{};
    //L.init_lista();
    while(true){
        afisMeniu();
        int optiune;
        std::cin >> optiune;
        switch (optiune) {
            case 1:{
                L.afisare_elemente();
                break;
            }
            case 2:{
                int key, poz = 1;
                std::cout << "Introduceti elementul: "; std::cin >> key;
                Nod *elem = L.cautare_nod(key, poz);
                if(elem == nullptr){
                    std::cerr << "\nElementul nu se gaseste in lista!\n";
                }
                else{
                    std::cout << "\nElementul a fost gasit cu succes.\n";
                    std::cout << "Se afla pe a " << poz << "-a pozitie in lista.\n";
                    std::cout << "Cheia: " << elem->info << "\n";
                }
                break;
            }
            case 3:{
                int key;
                std::cout << "Elementul de introdus: "; std::cin >> key;
                L.prepend(key);
                std::cout << "Elementul a fost inserat cu succes.\n";
                break;
            }
            case 4:{
                int key_before, key_current, poz = 1;
                std::cout << "Elementul de introdus: "; std::cin >> key_current;
                std::cout << "Sa se introduca dupa: "; std::cin >> key_before;
                Nod *y = L.cautare_nod(key_before, poz);
                L.inserare(key_current, y);
                std::cout << "Elementul a fost inserat cu succes.\n";
                break;
            }
            case 5:{
                int key, poz;
                std::cout << "Elementul de sters: "; std::cin >> key;
                Nod *x = L.cautare_nod(key, poz);
                if(x != nullptr){
                    L.sterge_nod(x);
                    std::cout << "Am sters cu succes.\n";
                }
                else{
                    std::cout << "Elementul nu exista in lista!\n";
                }
                break;
            }
            default:
                break;
        }
        if(optiune == 0)
            break;
    }
    return 0;
}
