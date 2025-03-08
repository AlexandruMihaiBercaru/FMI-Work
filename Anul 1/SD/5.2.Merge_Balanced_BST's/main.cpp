#include <iostream>
#include <vector>
#include <algorithm>

void Merge(std::vector<int> &vect, int st, int mij, int dr) {
    int lungst, lungdr, it, i = 0, j = 0, k = st;
    lungst = mij - st + 1;
    lungdr = dr - mij;
    int ST[lungst + 1], DR[lungdr + 1];
    for (it = 0; it < lungst; it++)
        ST[it] = vect[st + it];
    for (it = 0; it < lungdr; it++)
        DR[it] = vect[it + mij + 1];
    while (i < lungst && j < lungdr)
    {
        if (ST[i] <= DR[j]) {
            vect[k] = ST[i];
            i++;
            k++;
        }
        else {
            vect[k] = DR[j];
            j++;
            k++;
        }
    }
    while (i < lungst) { vect[k] = ST[i]; i++; k++;}
    while (j < lungdr) { vect[k] = DR[j]; j++; k++;}
}
void MergeSort(std::vector<int> &vect, int st, int dr) {
    if (st < dr)
    {
        int mij = (st + dr) / 2;
        MergeSort(vect, st, mij);
        MergeSort(vect, mij + 1, dr);
        Merge(vect, st, mij, dr);
    }
}
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
    std::vector<int> valori_arbore_1, valori_arbore_2;
    std::cout << "Numarul de elemente pentru primul arbore: "; std::cin >> n;
    std::cout << "Elementele primului arbore: ";
    for(int i = 0; i < n; i++)
    {
        std::cin >> elem;
        valori_arbore_1.push_back(elem);
    }
    std::sort(valori_arbore_1.begin(), valori_arbore_1.end());
    auto* arbore_1 = new Arbore(valori_arbore_1);
    std::cout << "Arborele a fost format.\n" << "Arborele parcurs in inordine este:\n";
    SRD(arbore_1->getRadacina());

    std::cout << "\n\nNumarul de elemente pentru al doilea arbore: "; std::cin >> n;
    std::cout << "Elementele celui de-al doilea arbore: ";
    for(int i = 0; i < n; i++)
    {
        std::cin >> elem;
        valori_arbore_2.push_back(elem);
    }
    std::sort(valori_arbore_2.begin(), valori_arbore_2.end());
    auto* arbore_2 = new Arbore(valori_arbore_2);
    std::cout << "Arborele a fost format.\n" << "Arborele parcurs in inordine este:\n";
    SRD(arbore_2->getRadacina());


    valori_arbore_1.insert(valori_arbore_1.end(), valori_arbore_2.begin(), valori_arbore_2.end());
    std::sort(valori_arbore_1.begin(), valori_arbore_1.end());
    auto* arbore_3 = new Arbore(valori_arbore_1);
    std::cout << "\n\nS-a format arborele interclasat.\nParcurgerea in inordine a acestuia este:\n";
    SRD(arbore_3->getRadacina());

    delete arbore_3;
    delete arbore_1;
    delete arbore_2;
    return 0;
}