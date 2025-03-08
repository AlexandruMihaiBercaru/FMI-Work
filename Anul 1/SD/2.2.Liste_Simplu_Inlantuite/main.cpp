#include <iostream>

class Nod{
public:
    int info{};
    Nod* next;

    Nod(){
        next = nullptr;
    }
    explicit Nod(int i_) : info(i_) {
        next = nullptr;
    }
};

class listaSimpla{
private:
    Nod *head;

public:
    listaSimpla(){
        head = nullptr;
    }

    //afisarea cheilor
    void afisare_lista(){
        Nod* nod_curent = head;
        if(head == nullptr){
            std::cout << "Lista vida!\n";
        }
        while(nod_curent != nullptr){
            std::cout << nod_curent -> info << " ";
            nod_curent = nod_curent -> next;
        }
    }

    //inserare la capul listei
    void prepend(int cheie){
        Nod *nod = new Nod(cheie);
        nod -> next = head;
        head = nod;
    }

    //inserare dupa un nod anume
    void inserare_dupa_nod(int cheie, Nod *y){
        Nod *nod_de_inserat = new Nod(cheie);
        nod_de_inserat->next = y->next;
        y->next = nod_de_inserat;
    }

    //functie care returneaza un nod (+ parametru care tine minte pozitia nodului in lista)
    Nod* cautare_nod(int cheie, int &poz){
        Nod *nod_cautat = head;
        while(nod_cautat != nullptr && nod_cautat->info != cheie){
            nod_cautat = nod_cautat->next;
            poz++;
        }
        return nod_cautat;
    }


    //stergerea unui nod (unei chei)
    void sterge_nod(int cheie){
        int pozitie_nod = 1;
        //returneaza nodul pe care vreau sa il sterg (pp. ca cheile sunt distincte)
        Nod* nod_de_sters = cautare_nod(cheie, pozitie_nod);
        if(nod_de_sters == nullptr){
            std::cout << "Cheia cautata nu se gaseste in lista. Stergere esuata.\n";
        }
        else {
            //daca cumva nodul de sters este chiar capul listei
            if (head == nod_de_sters) {
                head = nod_de_sters->next;
            } else {
                //gasesc care este nodul de dinaintea celui pe care vreau sa il sterg
                Nod *precedent = head;
                for (int i = 1; i < pozitie_nod - 1; i++) {
                    precedent = precedent->next;
                }
                precedent->next = nod_de_sters->next;
            }
            std::cout << "Stergerea a fost efectuata.\n";
        }
    }

};


void afisMeniu(){
    std::cout<<"\n\n";
    std::cout << "|--------------------------------------------|\n";
    std::cout << "|1. Afiseaza continutul listei               |\n";
    std::cout << "|2. Cauta un element                         |\n";
    std::cout << "|3. Insereaza elemente in capul listei       |\n";
    std::cout << "|4. Insereaza un element dupa un nod anume   |\n";
    std::cout << "|5. Sterge un element din lista              |\n";
    std::cout << "|0. Inchide meniul                           |\n";
    std::cout << "|--------------------------------------------|\n";
    std::cout << "|   Alegeti o optiune:                       |\n";
    std::cout << "|--------------------------------------------|\n";
    std::cout << "...";
}


int main() {
    listaSimpla L{};

    while(true){
        afisMeniu();
        int optiune;
        std::cin >> optiune;
        switch (optiune) {
            case 1:{
                L.afisare_lista();
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
                while(key != 0) {
                    L.prepend(key);
                    std::cout << "Elementul a fost inserat cu succes.\n";
                    std::cout << "Elementul de introdus: "; std::cin >> key;
                }
                break;
            }
            case 4:{
                int key_before, key_current, poz = 1;
                std::cout << "Elementul de introdus: "; std::cin >> key_current;
                std::cout << "Sa se introduca dupa: "; std::cin >> key_before;
                Nod *y = L.cautare_nod(key_before, poz);
                L.inserare_dupa_nod(key_current, y);
                std::cout << "Elementul a fost inserat cu succes.\n";
                break;
            }
            case 5:{
                int key, poz;
                std::cout << "Elementul de sters: "; std::cin >> key;
                L.sterge_nod(key);
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
