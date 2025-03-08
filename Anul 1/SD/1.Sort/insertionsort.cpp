#include <iostream>
#include <vector>

void InsertionSort(std::vector<int> &vect)
{
    auto dim = vect.size() ; //numarul de elemente ale vectorului
    for (int i = 1; i < dim; i ++)
    {
        int j = i;
        while(j > 0 && vect[j-1] > vect[j])
        {
            std::swap(vect[j-1], vect[j]);
            j--;
        }
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
    InsertionSort(arr);
    for(int x : arr)
        std::cout << x << " ";
    return 0;
}
//9 14 4 1 16 3 10 2 8 7