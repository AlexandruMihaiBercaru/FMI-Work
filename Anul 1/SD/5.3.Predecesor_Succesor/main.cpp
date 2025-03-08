//https://www.geeksforgeeks.org/inorder-predecessor-successor-given-key-bst/?ref=lbp

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
        root->left = creare_arbore(vect, st, pivot - 1);
        root->right = creare_arbore(vect, pivot + 1, dr);
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


void cautaPredSucc(Nod* radacina, Nod* &pred, Nod* &succ, int val){
    if(radacina == nullptr)
        return;
    if(radacina->getInfo() == val)
    {
        //maximul din subarborele stang, daca exista, este predecesor
        if(radacina->left != nullptr){
            Nod* temp = radacina->left;
            while(temp->right != nullptr){
                temp = temp->right;
            }
            pred = temp;
        }
        //minimul din subarborele drept, daca exista, este succesor
        if(radacina->right != nullptr){
            Nod* temp = radacina->right;
            while(temp->left != nullptr){
                temp = temp->left;
            }
            succ = temp;
        }
        return;
    }
    if(radacina->getInfo() > val){
        succ = radacina;
        cautaPredSucc(radacina->left, pred, succ, val);
    }
    else{
        pred = radacina;
        cautaPredSucc(radacina->right, pred, succ ,val);
    }
}

int main() {
    int n, elem, key;
    std::vector<int> valori_arbore;
    Nod *pred = nullptr, *suc = nullptr;
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

    std::cout << "\nAlegeti un numar:\n";
    std::cin >> key;

    cautaPredSucc((arb->getRadacina()), pred, suc, key);
    if(pred != nullptr){
        std::cout << "Predecesor: " << pred->getInfo()<< " ";
    }
    else{
        std::cout << "Fara predecesor." << "\n";
    }
    if(suc != nullptr){
        std::cout << "Succesor: " << suc->getInfo()<< " ";
    }
    else{
        std::cout << "Fara succesor." << "\n";
    }
    delete arb;
    return 0;
}

//6
//18 12 15 19 11 20