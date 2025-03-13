#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>

using namespace std;
int nrNoduri, nrMuchii;

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

///memorare grafuri cu matrice de adiacenta
vector<vector<int>>  MemoGrafMatrice (int tip){
    int i, j;
    ifstream fin;
    fin.open("graf.in");

    if (!fin.is_open()){
        cout << "Eroare - fisierul nu este deschis \n";
    }

    else{
        fin >> nrNoduri >> nrMuchii;
        vector<vector<int>> matrice_ad(nrNoduri + 1, vector<int>(nrNoduri+1, 0));
        for (int cnt = 0; cnt < nrMuchii; cnt++){
            fin >> i >> j;
            matrice_ad[i][j] = 1;
            //daca este neorientat
            if (tip == 0){
                matrice_ad[j][i] = 1;
            }
        }
        std::cout << "S-a memorat ca matrice.\n";
        return matrice_ad;
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
        cout << "S-a memorat ca lista.\n";
        return liste_adiacenta;
    }
}


///afisare liste de adiacenta
void AfisareListe(std::vector<std::vector<int>> &L){
    cout << "LISTE DE ADIACENTA\n----------------------\n";
    for(int nod = 1; nod <= L.size() - 1; nod++){
        cout << nod << " -> ";
        for(auto vecin : L[nod])
            cout << vecin << " ";
        cout << "\n";
    }
}


///afisare matrice de adiacenta
void AfisareMatrice(std::vector<std::vector<int>> &M){
   cout << "MATRICEA DE ADIACENTA\n----------------------\n";
    for(int i = 1; i <= nrNoduri; i++){
        for(int j = 1; j <= nrNoduri; j++)
            cout << M[i][j] << " ";
        cout << "\n";
    }
}


///transformare lista -> matrice
vector<vector<int>> ListaToMatrice(vector<vector<int>> &lista_adiacenta)
{
    int N = (int)lista_adiacenta.size(); // N = nr actual noduri + 1
    vector<vector<int>> matrice(N, vector<int>(N, 0));
    for(int nod_crt = 1; nod_crt <= lista_adiacenta.size() - 1; nod_crt++)
    {
        for(auto vecin : lista_adiacenta[nod_crt])
        {
            matrice[nod_crt][vecin] = 1;
        }
    }
    return matrice;
}

///transformare matrice -> lista
vector<vector<int>> MatriceToLista(vector<vector<int>> &matrice_adiacenta)
{
    int N = (int)matrice_adiacenta.size(); // N = nr actual noduri + 1
    vector<vector<int>> lista(N);

    for(int nod_crt = 1; nod_crt <= N - 1; nod_crt++)
    {
        for(int vecin = 1; vecin <= N - 1; vecin++)
            if(matrice_adiacenta[nod_crt][vecin] == 1)
                lista[nod_crt].push_back(vecin);
    }
    return lista;
}



int main() {

    cout << "Tipul de graf (0 - neorientat, 1 - orientat) \n";
    int n; cin >> n;

    //transformare lista -> matrice
    vector<vector<int>> listeAdiacenta;
    listeAdiacenta = MemoGrafLista(n);
    //AfisareListe(listeAdiacenta);
    vector<vector<int>> matrice_din_lista = ListaToMatrice(listeAdiacenta);
    AfisareMatrice(matrice_din_lista);

    //transformare matrice -> llista
    vector<vector<int>> matriceAdiacenta;
    matriceAdiacenta = MemoGrafMatrice(n);
    vector<vector<int>> lista_din_matrice = MatriceToLista(matriceAdiacenta);
    AfisareListe(lista_din_matrice);

    return 0;
}
