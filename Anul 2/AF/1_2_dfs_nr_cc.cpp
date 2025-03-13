#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;

/*
    Se da un graf neorientat cu N noduri si M muchii.
    Sa se determine numarul componentelor conexe ale grafului.

    ---dfs.in---
        6 3
        1 2
        1 4
        3 5
*/

int inf = 2147483647;
int nrNoduri, nrMuchii;
vector<int> viz, dist, tata;

vector<vector<int>> MemoGrafLista(int tip){
    int i, j;
    ifstream fin;
    fin.open("dfs.in");
    fin >> nrNoduri >> nrMuchii;
    vector<vector<int>> liste_adiacenta(nrNoduri + 1);
    for (int cnt = 0; cnt < nrMuchii; cnt++) {
        fin >> i >> j;
        liste_adiacenta[i].push_back(j);
        if(tip == 0)
            liste_adiacenta[j].push_back(i);
    }

    for(int nod = 1; nod <= int(liste_adiacenta.size() - 1); nod++){
        sort(liste_adiacenta[nod].begin(), liste_adiacenta[nod].end());
    }
    return liste_adiacenta;   
}

void DFS(vector<vector<int>> &graf, int start)
{
    viz[start] = 1;
    for(auto vecin : graf[start])
    {
        if(viz[vecin] == 0)
        {
            tata[vecin] = start;
            DFS(graf, vecin);
        }
    }
}

int main()
{
    vector<vector<int>> listeAdiacenta;
    listeAdiacenta = MemoGrafLista(0);
    int componente_conexe = 0;

    viz.assign(listeAdiacenta.size(), 0);
    tata.assign(listeAdiacenta.size(), 0);

    for(int nod = 1; nod <= nrNoduri; nod++)
    {
        if(viz[nod] == 0)
        {
            DFS(listeAdiacenta, nod);
            componente_conexe ++;
        }
    }
    cout << componente_conexe;
    return 0;
}

