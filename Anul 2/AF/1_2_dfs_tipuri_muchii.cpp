#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;

// parcurgerea DFS + afișarea arcelor de întoarcere, traversare, avansare (pe categorii)
/*
    dfs.in
    11 15
    1 3
    1 5
    1 9
    2 5
    3 1
    3 2
    3 6
    4 8
    4 9
    7 4
    9 6
    9 7
    9 8
    10 11
    11 8
*/

int inf = 2147483647;
int nrNoduri, nrMuchii;
vector<int> viz, dist, tata;
vector<int> desc, fin;
vector<pair<int, int>> toate_muchiile, muchii_avansare, muchii_intoarcere, muchii_traversare;
int timp;

vector<vector<int>> MemoGrafLista(int tip){
    int i, j;
    ifstream fin;
    fin.open("dfs.in");
    fin >> nrNoduri >> nrMuchii;
    vector<vector<int>> liste_adiacenta(nrNoduri + 1);
    toate_muchiile.resize(nrMuchii + 1);
    for (int cnt = 0; cnt < nrMuchii; cnt++) {
        fin >> i >> j;
        toate_muchiile.push_back(make_pair(i, j));
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
    timp++;
    desc[start] = timp;
    cout << start << " ";
    for(auto vecin : graf[start])
    {
        if(viz[vecin] == 0) // vecinul este nevizitat (alb) => [start, vecin] este muchie de avansare in arborele DF
        {
            tata[vecin] = start;
            dist[vecin] = dist[start] + 1; // nivelul in arborele DF (nu "distanta" -> este data de BFS)
            DFS(graf, vecin);
        }
    }
    timp++;
    fin[start] = timp;
}


int main()
{
    vector<vector<int>> listeAdiacenta;
    listeAdiacenta = MemoGrafLista(1);

    viz.assign(listeAdiacenta.size(), 0);
    tata.assign(listeAdiacenta.size(), 0);
    desc.assign(listeAdiacenta.size(), 0);
    fin.assign(listeAdiacenta.size(), 0);
    dist.assign(listeAdiacenta.size(), 1);
    
    timp = 0;
    for(int nod = 1; nod <= nrNoduri; nod++)
    {
        if(!viz[nod])
        {
            DFS(listeAdiacenta, nod);
            cout << endl;
        }
    }
    int u, v;
    for(auto m : toate_muchiile)
    {
        u = m.first; v = m.second;
        // daca este de avansare => desc[u] < desc[v] < fin[v] < fin[u] si v nu este fiul lui u 
        if(desc[u] < desc[v] && desc[v] < fin[v] && fin[v] < fin[u] && tata[v] != u)
            muchii_avansare.push_back(m);
        // daca este de intoarcere => desc[v] < desc[u] < fin[u] < fin[v]
        else if(desc[v] < desc[u] && desc[u] < fin[u] && fin[u] < fin[v])
            muchii_intoarcere.push_back(m);
        // daca este de traversare => desc[v] < fin[v] < desc[u] < fin[u]
        else if(desc[v] < fin[v] && fin[v] < desc[u] && desc[u] < fin[u])
            muchii_traversare.push_back(m);
    }
    cout << "\nMuchii de avansare: ";
    for(auto m : muchii_avansare)
        cout << "[" << m.first << ", " << m.second << "] ";
    
    cout << "\nMuchii de intoarcere: ";
    for(auto m : muchii_intoarcere)
        cout << "[" << m.first << ", " << m.second << "] ";

    cout << "\nMuchii de traversare: ";
    for(auto m : muchii_traversare)
        cout << "[" << m.first << ", " << m.second << "] ";
    return 0;
}