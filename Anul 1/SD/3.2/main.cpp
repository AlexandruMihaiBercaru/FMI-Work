#include <iostream>
template<typename T>
class Nod{
public:
    Nod *prev;
    T info;
    Nod *next;
    explicit Nod(T info_):info(info_){
        prev = nullptr; next = nullptr;
    }
};

template<typename T>
class List{
private:
    Nod<T> *head;
public:
    List() {
        head = nullptr;
    };
    //inserare (push)
    void prepend(T cheie_de_inserat){
        Nod<T> *nod_de_inserat = new Nod<T>(cheie_de_inserat);
        nod_de_inserat->next = head;
        nod_de_inserat->prev = nullptr;
        if(head != nullptr){
            head->prev = nod_de_inserat;
        }
        head = nod_de_inserat;
    }
    /// stergere (pop)
    T sterge_cap(){
        T info_sters = head->info;
        if (head->next != nullptr)
            head->next->prev = head->prev;
        head = head->next;
        return info_sters;
    }

    void insereaza_final(T cheie_de_inserat){
        Nod<T> *nod_de_inserat = new Nod<T>(cheie_de_inserat);
        Nod<T> *de_dinainte = head;
        //ajung la ultimul nod
        while(de_dinainte->next != nullptr){
            de_dinainte = de_dinainte->next;
        }
        nod_de_inserat->next = de_dinainte->next;
        nod_de_inserat->prev = de_dinainte;
        de_dinainte->next = nod_de_inserat;
    }
    [[nodiscard]] Nod<T> *getHead() const {
        return head;
    }
};


class Stack{
private:
    int nr_elem;
    List<int>* list;
public:
    explicit Stack() {
        nr_elem = 0;
        list = new List<int>;
    }
    void push(int elem){
        list->prepend(elem);
        nr_elem += 1;
        //list->afisare_elemente();
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
    [[nodiscard]] int getNrElem() const {
        return nr_elem;
    }
    ~Stack(){
        delete list;
    }
};


class Queue{
private:
    int nr_elem;
    List<std::pair<int, int>>* list;
public:
    explicit Queue() {
        nr_elem = 0;
        list = new List<std::pair<int, int>>;
    }
    void enqueue(std::pair<int, int> pereche){
        if(nr_elem ==0){
            list->prepend(pereche);
        }
        else{
            list->insereaza_final(pereche);
        }
        nr_elem ++;
    }
    std::pair<int, int> dequeue(){
        std::pair<int, int> pereche = list->sterge_cap();
        nr_elem --;
        return pereche;
    }
    [[nodiscard]] bool is_empty() const{
        return nr_elem == 0;
    }
    ~Queue(){
        delete list;
    }
};


int main() {
    Stack myStack;
    Queue myQueue;
    int nr_elem, arr[100];
    std::cout << "Numarul de elemente in vector:";
    std::cin >> nr_elem;
    std::cout << "Elementele:";
    for(int i = 0; i < nr_elem; i++)
        std::cin >> arr[i];

    for(int i = 0; i < nr_elem - 1; i++)
    {
        if(arr[i] < arr[i+1]){
            //daca exista elemente pe stiva, compar varful stivei cu arr[i+1]
            if(!myStack.is_empty()){
                int index = myStack.top_of_stack();
                while(arr[index] < arr[i+1] && !myStack.is_empty()) {
                    myQueue.enqueue(std::pair<int, int>(std::make_pair(index, i + 1)));
                    int p = myStack.pop();
                    if(!myStack.is_empty())
                        index = myStack.top_of_stack();
                }
                myQueue.enqueue(std::pair<int, int>(std::make_pair(i, i+1)));
            }
            // daca stiva este goala
            else{
                myQueue.enqueue(std::pair<int, int>(std::make_pair(i, i+1)));
            }
        }
        else{
            myStack.push(i);
        }
    }
    std::cout << "Primul element mai mare decat: \n";
    while(!myQueue.is_empty()){
        std::pair<int, int> crrt_pair = myQueue.dequeue();
        std::cout << arr[crrt_pair.first] << " -> " << arr[crrt_pair.second] << "\n";
    }

    return 0;
}
// 10
// 1 5 3 4 2 6 9 7 10 3