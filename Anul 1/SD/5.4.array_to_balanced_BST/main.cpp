#include <iostream>
#include <vector>
#include <algorithm>

class Nod{
private:
    int info;
public:
    Nod* left;
    Nod* right;
    explicit Nod(int val_){
        info = val_;
        left = nullptr;
        right = nullptr;
    }
    [[nodiscard]] int getInfo() const {
        return info;
    }
};
class Arbore{
private:
    Nod* radacina;
    std::vector<int> valori;
public:
    explicit Arbore(std::vector<int> &vals_){
        valori = vals_;
        radacina = creare_arbore(valori, 0, valori.size() - 1);
    }
    Nod* creare_arbore(std::vector<int> vect, int st, int dr){
        if(st > dr)
            return nullptr;
        int pivot = (st + dr) / 2;
        Nod *root = new Nod(vect[pivot]);
        root -> left = creare_arbore(vect, st, pivot - 1);
        root -> right = creare_arbore(vect, pivot + 1, dr);
        return root;
    }
    [[nodiscard]] Nod *getRadacina() const {
        return radacina;
    }
};
/// parcurgere inordine
void SRD(Nod* radacina){
    if(radacina == nullptr)
        return;
    SRD(radacina->left);
    std::cout << radacina->getInfo() << " ";
    SRD(radacina->right);
}
int main() {
    int n, elem;
    std::vector<int> valori_arbore;
    std::cout << "Numarul de elemente: "; std::cin >> n;
    std::cout << "Elementele: ";
    for(int i = 0; i < n; i++)
    {
        std::cin >> elem;
        valori_arbore.push_back(elem);
    }
    std::sort(valori_arbore.begin(), valori_arbore.end());
    Arbore* arb = new Arbore(valori_arbore);
    std::cout << "Arborele a fost format.\n" << "Arborele parcurs in inordine este:\n";
    SRD(arb->getRadacina());
    delete arb;
    return 0;
}
