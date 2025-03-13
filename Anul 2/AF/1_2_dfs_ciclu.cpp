#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;

/*  
    Laborator 1-2: aplicatie DFS
    Dat un graf neorientat (nu neapărat conex), să se verifice dacă graful conține un ciclu
    elementar (nu este aciclic). În caz afirmativ să se afișeze un astfel de ciclu.

    7 8
    1 3
    2 4
    3 4
    3 5
    3 6
    5 6
    6 7
    3 7

    hint : parcurg DFS(1) si la fiecare pas, verific daca muchia pe care ma aflu este de intoarcere 
    (daca este, inseamna ca am gasit un ciclu)
*/

int timp;
int nrNoduri, nrMuchii;
vector<int> viz, dist, tata;
vector<int> desc, fin, ciclu;
bool found = false;

vector<vector<int>> MemoGrafLista(int tip){
    int i, j;
    ifstream fin; fin.open("dfs.in");
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
    if(found) return;
    viz[start] = 1;
    timp++;
    desc[start] = timp;
    for(auto vecin : graf[start])
    {
        if(viz[vecin] == 0) // vecinul este nevizitat (alb) => [start, vecin] este muchie de avansare in arborele DF
        {
            tata[vecin] = start;
            DFS(graf, vecin);
        }
        else // este in explorare
        {
            if(tata[start] != vecin && !found) // nu e muchie din arbore => sigur este de intoarcere
            {
                int v = start;
                while (v != vecin)
                {
                    ciclu.push_back(v);
                    v = tata[v];
                }
                ciclu.push_back(vecin);
                ciclu.push_back(start);
                // am gasit un ciclu
                found = true;
                return;
            }
        }
    }
    timp++;
    fin[start] = timp;
}

int main()
{
    vector<vector<int>> listeAdiacenta;
    listeAdiacenta = MemoGrafLista(0);

    viz.assign(listeAdiacenta.size(), 0);
    tata.assign(listeAdiacenta.size(), 0);
    desc.assign(listeAdiacenta.size(), 0);
    fin.assign(listeAdiacenta.size(), 0);
    dist.assign(listeAdiacenta.size(), 1);

    DFS(listeAdiacenta, 1);
    if(!ciclu.empty())
    {
        for(auto v : ciclu)
            cout << v << " ";
    }   
    else
        cout << "Nu are cicluri";
    cout << endl;
    return 0;
}