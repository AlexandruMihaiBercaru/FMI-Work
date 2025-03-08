#include <iostream>
#include <vector>

void BubbleSort(std::vector<int> &vector)
{
    bool swapped;
    do{
        swapped = false;
        for(int i = 0; i < vector.size(); i++)
            if(vector[i] > vector[i + 1])
            {
                std::swap(vector[i], vector[i + 1]);
                swapped = true;
            }
    }while(swapped);
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
    BubbleSort(arr);
    for(int x : arr)
        std::cout << x << " ";
    return 0;
}
//9 14 4 1 16 3 10 2 8 7