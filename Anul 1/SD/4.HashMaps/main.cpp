#include <iostream>
#include <fstream>
#include <vector>
class Nod{
public:
    std::string info;
    Nod *next;
    explicit Nod(const std::string &c_) : info(c_) {
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
    void afisare_lista(){
        Nod* nod_curent = head;
        if(head == nullptr){
            std::cout << "-";
        }
        else {
            while (nod_curent->next != nullptr) {
                std::cout << nod_curent->info << ", ";
                nod_curent = nod_curent->next;
            }
            std::cout << nod_curent->info;
        }
    }

    //inserare la capul listei
    void prepend(const std::string& cheie){
        Nod *nod = new Nod(cheie);
        nod -> next = head;
        head = nod;
    }

    //inserare dupa un nod anume
    void inserare_dupa_nod(const std::string& cheie, Nod *y){
        Nod *nod_de_inserat = new Nod(cheie);
        nod_de_inserat->next = y->next;
        y->next = nod_de_inserat;
    }

    //functie care returneaza nodul dupa care trebuie sa introduc noul nod
    Nod* cautare_nod(const std::string& cheie){
        Nod *nod_cautat = head;
        while(nod_cautat->next != nullptr && (nod_cautat->next->info).substr(1) < cheie.substr(1)){
            nod_cautat = nod_cautat->next;
        }
        return nod_cautat;
    }

    [[nodiscard]] Nod *getHead() const {
        return head;
    }
};


class HashTable{
private:
    std::vector<listaSimpla*> dictionar{26, nullptr}; //declar un vector de pointeri
    //fiecare pointer reprezinta head-ul unei liste simplu inlantuite
public:
    HashTable(){
        for (int i = 0; i <= 25; i++)
            dictionar[i] = new listaSimpla;
    }
    // adauga un nod nou la lista corespunzatoare obtinuta prin fc. de hash
    // cheile se afla in ordine lexicografica
    void adaugaCuvant(listaSimpla *L, std::string& cuv){
        if(L->getHead() == nullptr){
            L->prepend(cuv);
        }
        else{
            if(cuv.substr(1) < L->getHead()->info.substr(1))
                L->prepend(cuv);
            else {
                Nod *previous = L->cautare_nod(cuv);;
                L->inserare_dupa_nod(cuv, previous);
            }
        }
    }
    /// afiseaza toate cuvintele dintr-o lista
    void afiseazaLitera(listaSimpla* L){
        L->afisare_lista();
    }
    [[nodiscard]] const std::vector<listaSimpla*> &getDictionar() const {
        return dictionar;
    }

    ~HashTable(){
        for(int i = 0; i <= 25; i++)
            delete dictionar[i];
    }
};


char hash(const std::string& myWord){
    if('A' <= myWord[0] && myWord[0] <='Z')
        return myWord[0] + 32;
    return myWord[0];
}


int main() {
    HashTable T;
    std::vector<std::string> cuvinte;
    std::ifstream fin;
    //cuvintele vor fi citite din fisierul words.in
    fin.open("words.in");
    if (!fin) {
        std::cerr << "Eroare la deschiderea fisierului" << std::endl;
        return 1;
    }
    std::string cuvant_curent;
    while(fin>>cuvant_curent)
        cuvinte.push_back(cuvant_curent);
    fin.close();

    for(auto &cuv:cuvinte) {
        int cheie = hash(cuv) - 'a';
        T.adaugaCuvant(T.getDictionar()[cheie], cuv);
    }
    std::cout << "\nDICTIONAR\n";
    char letter = 'A';
    for (int i = 0; i <= 25; i++){
        std::cout << letter << ": ";
        T.afiseazaLitera(T.getDictionar()[i]);
        letter = static_cast<char>(letter) + 1;
        std::cout << "\n";
    }
}
