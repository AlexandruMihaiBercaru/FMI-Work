#include <iostream>
#include <vector>


int Partition(std::vector<int> &vect, int st, int dr)
{
    int val = vect[dr];
    int i = st - 1;
    for (int j = st; j < dr; j++)
    {
        if (vect[j] <= val)
        {
            i += 1;
            std::swap(vect[i], vect[j]);
        }
    }
    std::swap(vect[i+1], vect[dr]);
    return i + 1;
}


void Quicksort(std::vector<int> &vect, int st, int dr){
    if (st < dr)
    {
        int pivot = Partition(vect, st, dr);
        Quicksort(vect, st, pivot - 1);
        Quicksort(vect, pivot + 1, dr);
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

    Quicksort(arr, 0, n-1);

    for(int x : arr)
        std::cout << x << " ";
    return 0;
}
//9 14 4 1 16 3 10 2 8 7
