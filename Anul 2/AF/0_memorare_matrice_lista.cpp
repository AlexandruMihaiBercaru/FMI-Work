#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace  std;
/*
  graf.in
    7 8
    1 3
    2 4
    3 4
    3 5
    3 6
    5 6
    6 7
    3 7
*/
int nrNoduri, nrMuchii;

///memorare grafuri cu matrice de adiacenta
void MemoGrafMatrice (int tip, int ad[100][100]){
    int i, j;
    ifstream fin;
    fin.open("graf.in");

    if (!fin.is_open()){
        cout << "Eroare - fisierul nu este deschis \n";
    }

    else{
        fin >> nrNoduri >> nrMuchii;
        for (int cnt = 0; cnt < nrMuchii; cnt++){
            fin >> i >> j;
            ad[i][j] = 1;
            //daca este neorientat
            if (tip == 0){
                ad[j][i] = 1;
            }
        }
    }
}


///memorare grafuri orientate / neorientate cu liste de adiacenta
vector<vector<int>> MemoGrafLista(int tip){
    int i, j;
    ifstream fin;
    fin.open("graf.in");
    if (!fin.is_open()){
        cout << "Eroare - fisierul nu este deschis \n";
    }
    else {
        fin >> nrNoduri >> nrMuchii;
        //creez n liste vide
        vector<vector<int>> liste_adiacenta(nrNoduri + 1);
        for (int cnt = 0; cnt < nrMuchii; cnt++) {
            fin >> i >> j;
            liste_adiacenta[i].push_back(j);
            if(tip == 0)
                liste_adiacenta[j].push_back(i);
        }
        cout << "Memorat cu succes.\n";
        //sortez crescator listele de adiacenta
        for(int nod = 1; nod <= liste_adiacenta.size() - 1; nod++){
            sort(liste_adiacenta[nod].begin(), liste_adiacenta[nod].end());
        }
        return liste_adiacenta;
    }
}


///afisare liste de adiacenta
void AfisareListe(vector<vector<int>> L){
    cout << "LISTE DE ADIACENTA\n----------------------\n";
    for(int nod = 1; nod <= L.size() - 1; nod++){
        cout << nod << " -> ";
        for(auto vecin : L[nod])
            cout <<  vecin << " ";
        cout << "\n";
    }
}

///afisare matrice de adiacenta
void AfisareMatrice(int ad[100][100]){
    cout << "MATRICEA DE ADIACENTA\n----------------------\n";
    for(int i = 1; i <= nrNoduri; i++){
        for(int j = 1; j <= nrNoduri; j++)
            cout << ad[i][j] << " ";
        cout << "\n";
    }
}

int main() {
    cout << "Tipul de graf (0 - neorientat, 1 - orientat) \n";
    int n; cin >> n;

    // pentru memorarea cu matrice de adiacenta
    int matriceAdiacenta[100][100];
    MemoGrafMatrice(n, matriceAdiacenta);
    AfisareMatrice(matriceAdiacenta);

    // pentru memorarea cu lista de adiacenta
    vector<vector<int>> listeAdiacenta;
    listeAdiacenta = MemoGrafLista(n);
    AfisareListe(listeAdiacenta);
    return 0;
}
