#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
using namespace std;

/*
    Verificarea daca un graf este bipartit
    5 3
    1 2
    1 3
    4 5

    (daca este, se va afisa o modalitate de impartire a nodurilor <=> o modalitate de a 2-colora graful)
    alt test:
    9 9
    1 2
    1 3
    2 5
    2 9
    3 5
    4 6
    5 7
    6 7
    6 8

*/
int numarNoduri, numarMuchii;
vector<int> viz, tata, culori;
bool bipartit = true;

vector<vector<int>> MemoGrafLista(int tip){
    int i, j;
    ifstream fin;
    fin.open("graf.in");
    fin >> numarNoduri >> numarMuchii;
    vector<vector<int>> liste_adiacenta(numarNoduri + 1);
    for (int cnt = 0; cnt < numarMuchii; cnt++) {
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

void AfisareListe(vector<vector<int>> L){
    cout << "LISTE DE ADIACENTA\n----------------------\n";
    for(int nod = 1; nod <= L.size() - 1; nod++){
        cout << nod << " -> ";
        for(auto vecin : L[nod])
            cout <<  vecin << " ";
        cout << "\n";
    }
}

void DFS(int nod_start, int culoare, vector<vector<int>>&graf)
{
    if(!bipartit) 
        return;
    int culoare_copil;
    viz[nod_start] = 1;
    culori[nod_start] = culoare;
    //cout << "nod: " << nod_start << " - culoare: " << culori[nod_start] << "\n";
    for(auto vecin : graf[nod_start])
    {
        if(viz[vecin] == 0) //nevizitat => coloram vecinul nevizitat cu culoarea diferita fata de cea a nodului curent
        {
            tata[vecin] = nod_start;
            culoare_copil = culoare % 2 + 1; // schimb culoarea
            DFS(vecin, culoare_copil, graf);
        }
        else // testez daca muchiile au extremitatile colorate diferit
        {
            if(culori[vecin] == culori[nod_start]) // are extremitatile colorate la fel => nu e bipartit
                bipartit = false;
        }
    }
}


int main() {
    vector<vector<int>> listeAdiacenta;
    listeAdiacenta = MemoGrafLista(0);
    viz.assign(listeAdiacenta.size(), 0);
    tata.assign(listeAdiacenta.size(), 0);
    culori.assign(listeAdiacenta.size(), -1);

    for(int nod = 1; nod <= numarNoduri; nod++)
    {
        if(viz[nod] == 0)
            DFS(nod, 1, listeAdiacenta);
    }

    if (bipartit)
    {
        for(int i = 1; i <= numarNoduri; i++)
            cout << culori[i] << " ";
        cout << "\n";
    }
    else
        cout << "IMPOSSIBLE\n";
    return 0;
}
