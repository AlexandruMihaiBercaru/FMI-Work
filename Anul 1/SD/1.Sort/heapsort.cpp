//implementarea algoritmului de sortare HeapSort utilizand MaxHeap

#include <iostream>
#include <vector>
#include <cmath>

int LeftChild(int i){
    return 2 * i;
}

int RightChild(int i){
    return 2 * i + 1;
}

void MaxHeapify(std::vector<int> &vect, int rad, int heap_size)
{
    int maxim;
    rad -= 1;
    int poz_fiu_st = LeftChild(rad) + 1;
    int poz_fiu_dr = RightChild(rad) + 1;
    if(poz_fiu_st <= heap_size && vect[poz_fiu_st] > vect[rad])
        maxim = poz_fiu_st;
    else
        maxim = rad;
    if(poz_fiu_dr <= heap_size && vect[poz_fiu_dr] > vect[maxim])
        maxim = poz_fiu_dr;
    if(rad != maxim)
    {
        std::swap(vect[maxim], vect[rad]);
        maxim += 1;
        MaxHeapify(vect, maxim, heap_size);
    }
}

void BuildHeap(std::vector<int> &vect)
{
    int dim = vect.size();
    for (int index = floor(dim/2); index >= 1; index--)
        MaxHeapify(vect, index, dim-1);
}

void Heapsort(std::vector<int> &vect)
{
    BuildHeap(vect);
    auto dim = vect.size() - 1;
    for(int i = dim; i >=1; i--)
    {
        std::swap(vect[0], vect[i]);
        dim -= 1;
        MaxHeapify(vect, 1, dim);
    }
}

int main() {
    std::vector<int> arr;
    int elem;
    std::string str;
    int n;
    std::cin >> n;
    for (int i = 0; i < n; i ++){
        std::cin >> elem;
        arr.push_back(elem);
    }
    Heapsort(arr);
    for(int x : arr)
        std::cout << x << " ";

    return 0;
}
//9 14 4 1 16 3 10 2 8 7

