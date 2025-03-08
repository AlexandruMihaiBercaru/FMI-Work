#include <iostream>
#include <vector>

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

    MergeSort(arr, 0, n-1);

    for(int x : arr)
        std::cout << x << " ";
    return 0;
}
//9 14 4 1 16 3 10 2 8 7
