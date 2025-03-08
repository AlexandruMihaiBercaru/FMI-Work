#include <iostream>
#include <vector>

void SelectionSort(std::vector<int> &vector)
{
    int maxValue, positionOfMax;
    for (int i = vector.size() - 1; i >= 1; i--)
    {
        maxValue = vector[i];
        positionOfMax = i;
        for(int j = 0; j < i; j++)
            if(vector[j] > maxValue){
                maxValue = vector[j];
                positionOfMax = j;
            }
        std::swap(vector[positionOfMax], vector[i]);
    }
}

int main() {
    std::vector<int> arr;
    int elem;

    int n;
    std::cin >> n;
    for (int i = 0; i < n; i ++){
        std::cin >> elem;
        arr.push_back(elem);
    }
    SelectionSort(arr);
    for(int x : arr)
        std::cout << x << " ";
    return 0;
}
//9 14 4 1 16 3 10 2 8 7