#include <iostream>
#include <new>
class Nod{
public:
    Nod *prev;
    int info;
    Nod *next;
    explicit Nod(int info_):info(info_){
        prev = nullptr;
        next = nullptr;
    }
};

class listaCirculara{
private:
    /// capul listei - un nod sentinela (nil)
    Nod *sentinel;
public:
    // crearea unui obiect de tip lista_circulata => se initializeaza lista,
    // creez practic nodul sentinela, cu legaturi catre el insusi
    listaCirculara() {
        sentinel = new Nod(0);
        sentinel->next = sentinel;
        sentinel->prev = sentinel;
    };

    /// afisarea cheilor
    void afisare_elemente(){
        std::cout << "Elementele listei: \n";
        Nod *nod_curent = sentinel->next;
        if(nod_curent == sentinel)
        {   std::cout<<"Lista este vida.!";}
        while(nod_curent != sentinel)
        {
            std::cout << nod_curent -> info << " ";
            nod_curent = nod_curent -> next;
        }
        std::cout<<"\n\n";
    }

    /// inserare dupa un nod dat (prin cheie)

     void inserare(int cheie_de_inserat, Nod* y){
        Nod *nod_de_inserat = new Nod(cheie_de_inserat);
        nod_de_inserat->next = y->next;
        nod_de_inserat->prev = y;
        y->next->prev = nod_de_inserat;
        y->next = nod_de_inserat;
        if(y == sentinel){

        }
    }

    /// cautarea unui nod, dandu-se cheia
    Nod* cautare_nod(int key, int& poz){
        sentinel->info = key;
        Nod *x = sentinel->next;
        while(x->info != key){
            x = x->next;
            poz++;
        }
        if(x == sentinel){
            return nullptr;
        }
        else return x;
    }

    /// stergerea unui nod dat ca parametru (foloseste cautarea)
    static void sterge_nod(Nod *x){
        x->prev->next = x->next;
        x->next->prev = x->prev;
        //delete x;
    }

    void sterge_cap(){
        Nod* x = sentinel->next;
        x->prev->next = x->next;
        x->next->prev = x->prev;
    }

    [[nodiscard]] Nod *getSentinel() const {
        return sentinel;
    }

    ~listaCirculara(){
        delete sentinel;
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
    std::cout << "|6. Sterge capul listei                      |\n";
    std::cout << "|0. Inchide meniul                           |\n";
    std::cout << "|--------------------------------------------|\n";
    std::cout << "|   Alegeti o optiune:                       |\n";
    std::cout << "|--------------------------------------------|\n";
    std::cout << "...";
}

int main() {
    listaCirculara *L = new listaCirculara;

    while(true){
        afisMeniu();
        int optiune;
        std::cin >> optiune;
        switch (optiune) {
            case 1:{
                L->afisare_elemente();
                break;
            }
            case 2:{
                int key, poz = 1;
                std::cout << "Introduceti elementul: "; std::cin >> key;
                Nod *elem = L->cautare_nod(key, poz);
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
                L->inserare(key, L->getSentinel());
                std::cout << "Elementul a fost inserat cu succes.\n";
                break;
            }
            case 4:{
                int key_before, key_current, poz = 1;
                std::cout << "Elementul de introdus: "; std::cin >> key_current;
                std::cout << "Sa se introduca dupa: "; std::cin >> key_before;
                Nod *y = L->cautare_nod(key_before, poz);
                L->inserare(key_current, y);
                std::cout << "Elementul a fost inserat cu succes.\n";
                break;
            }
            case 5:{
                int key, poz;
                std::cout << "Elementul de sters: "; std::cin >> key;
                Nod *x = L->cautare_nod(key, poz);
                if(x != nullptr){
                    listaCirculara::sterge_nod(x);
                    std::cout << "Am sters cu succes.\n";
                }
                else{
                    std::cout << "Elementul nu exista in lista!\n";
                }
                break;
            }
            case 6:{
                L->sterge_cap();
                std::cout << "Primul element din lista a fost sters.\n";
            }
            default:
                break;
        }
        if(optiune == 0)
            break;
    }
    delete L;
    return 0;
}
