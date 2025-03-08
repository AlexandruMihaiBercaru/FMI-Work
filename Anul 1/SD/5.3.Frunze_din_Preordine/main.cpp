///https://www.geeksforgeeks.org/leaf-nodes-preorder-binary-search-tree/?ref=lbp

#include <iostream>
#include <vector>

///implementarea stivei (luata din laboratorul 3.1)
class Nod{
public:
    Nod *prev;
    int info;
    Nod *next;
    explicit Nod(int info_):info(info_){
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
    void prepend(int cheie_de_inserat){
        Nod *nod_de_inserat = new Nod(cheie_de_inserat);
        nod_de_inserat->next = head;
        nod_de_inserat->prev = nullptr;
        if(head != nullptr){
            head->prev = nod_de_inserat;
        }
        head = nod_de_inserat;
    }
    // stergere (pop)
    int sterge_cap(){
        int info_sters = head->info;
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
    void push(int elem){
        list->prepend(elem);
        nr_elem += 1;
    }
    int pop(){
        int p = list->sterge_cap();
        nr_elem -= 1;
        return p;
    }
    int top_of_stack(){
        int top = list->sterge_cap();
        list->prepend(top);
        return top;
    }
    [[nodiscard]] bool is_empty() const{
        return nr_elem == 0;
    }
    ~Stack(){
        delete list;
    }
};

///Pasii algoritmului:
//se parcurge vectorul traversarii preordine utilizand doi indici i si j (pleaca de la 0 si 1)
//daca elementul cu indice i este mai mare decat elementul cu indice j, punem elementul cu indice i pe stiva
//altfel, cat timp stiva nu este goala:
    //- daca elementul cu indice j este mai mare decat elementul din vf stivei
            // => scoatem din stiva, gasit = 1
//daca gasit = 1, atunci afisam elementul cu indice i
//obersvatie: implicit, ultimul element al unei parcurgeri in preordine este frunza


int main() {
    Stack* myStack = new Stack;
    int nr_elemente, elem, i, j;
    std::vector<int> preordine;
    std::cout << "n= "; std::cin >> nr_elemente;
    std::cout << "Parcurgerea in preordine: ";
    for(int i =0; i < nr_elemente; i++){
        std::cin >> elem;
        preordine.push_back(elem);
    }
    std::cout << "FRUNZELE: \n";
    j = 1;
    for(i = 0; i < nr_elemente - 1; i++){
        bool gasit = false;
        if(preordine[i] > preordine[j])
            myStack->push(preordine[i]);
        else{
            while(!myStack->is_empty()){
                int tos = myStack->top_of_stack();
                if(preordine[j] > tos){
                    gasit = true;
                    tos = myStack->pop();
                }
                else{
                    break;
                }
            }
        }
        if(gasit){
            std::cout << preordine[i] << " ";
        }
        j++;
    }
    std::cout << preordine[nr_elemente-1];

    delete myStack;
    return 0;
}
// 5
// 16 10 13 17 21
// rezultat : 13, 21