#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
using namespace std;

/*
    Gasirea tuturor muchiilor critice dintr-un graf
    9 10
    1 2
    1 3
    1 4
    2 5
    2 9
    3 5
    4 6
    5 7
    6 7
    6 8
*/
int numarNoduri, numarMuchii;
vector<int> viz, tata;
int timp = 1;

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


vector<int> level, min_level;

void DFS_muchii_critice(vector<vector<int>> &graf, int start)
{
    viz[start] = 1;
    min_level[start] = level[start];
    //cout << start << " ";
    for(auto vecin : graf[start])
    {
        if(viz[vecin] == 0) // vecinul este nevizitat (alb) => [start, vecin] este muchie de avansare in arborele DF
        {
            tata[vecin] = start;
            level[vecin] = level[start] + 1; // nivelul in arborele DF (nu "distanta" -> este data de BFS) // adauga in stiva muchiile
            DFS_muchii_critice(graf, vecin);
            if(min_level[vecin] > level[start]) // ESTE MUCHIE CRITICA (start - punct critic: >=)
            // daca pui >= si elimini din S toate muchiile pana la (start, vecin), inclusiv ea -> ai obtinut componenta biconexa
                cout << start << " " << vecin << endl;
            min_level[start] = min(min_level[start], min_level[vecin]);
        }
        else // vecinul este in explorare
        {
            if(level[vecin] < level[start] - 1) // muchia este de intoarcere (vecinul nu este tatal)
                min_level[start] = min(min_level[start], level[vecin]);
                //adauga (start, vecin) in stiva -> pt biconexitate
        }
    }
}


int main() {
    vector<vector<int>> listeAdiacenta;
    listeAdiacenta = MemoGrafLista(0);

    viz.assign(listeAdiacenta.size(), 0);
    tata.assign(listeAdiacenta.size(), 0);
    min_level.assign(listeAdiacenta.size(), 0);
    level.assign(listeAdiacenta.size(), 1);

    for(int nod = 1; nod <= numarNoduri; nod++)
    {
        if(viz[nod] == 0)
            DFS_muchii_critice(listeAdiacenta, nod);
    }
    return 0;
}
