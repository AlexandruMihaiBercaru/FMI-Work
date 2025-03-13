#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <queue>
using namespace std;

/*Algoritm generic pentru determinarea drumurilor minime in DAG (Directed Acyclic Graph)*/

/* Sortarea Topologica pentru a determina ordinea activitatilor
    5 3
    1 2
    3 1
    4 5

    Daca graful este corect (stim ca nu are circuite), merge cu BFS
    Daca nu => detectia de circuite pe DFS
*/
int inf = 10000000;
int nrNoduri, nrMuchii;
vector<int> viz, tata, grad_intern, d;
vector<int> ordonare, circuit;
queue<int> C;

vector<vector<pair<int, int>>> MemoGrafLista(int tip){
    int i, j, cost;
    ifstream fin; fin.open("grafpond.in");
    fin >> nrNoduri >> nrMuchii;
    vector<vector<pair<int, int>>> liste_adiacenta(nrNoduri + 1);
    grad_intern.assign(liste_adiacenta.size(), 0);
    for (int cnt = 0; cnt < nrMuchii; cnt++) {
        fin >> i >> j >> cost;
        liste_adiacenta[i].push_back({j, cost});
        if(tip == 0)
            liste_adiacenta[j].push_back({i, cost});
        grad_intern[j]++;
    }
    for(int nod = 1; nod <= int(liste_adiacenta.size() - 1); nod++){
        sort(liste_adiacenta[nod].begin(), liste_adiacenta[nod].end());
    }
    return liste_adiacenta;   
}

/*
    void DFS(vector<vector<int>> &graf, int start)
{
    if(found) return;
    viz[start] = 1;
    for(auto vecin : graf[start])
    {
        if(viz[vecin] == 0) // muchie de avansare in arborele DF
        {
            tata[vecin] = start;
            DFS(graf, vecin);
        }
        else 
        {
            if(fin[vecin] == 0) // este in explorare (gri/ in stiva)
            {
                int v = start;
                while (v != vecin)
                {
                    circuit.push_back(v);
                    v = tata[v];
                }
                circuit.push_back(vecin);
                circuit.push_back(start);
                // am gasit un circuit
                found = true;
                return;
            }
        }
    }
    fin[start] = 1;
    S.push(start);
}
*/

void TopoSortBFS(vector<vector<pair<int,int>>> &graf)
{
    for(int i = 1; i <= nrNoduri; i++)
        if(grad_intern[i] == 0)
            C.push(i);
    while(!C.empty())
    {
        int nod_crt = C.front();
        C.pop();
        ordonare.push_back(nod_crt);
        for(auto v : graf[nod_crt])
        {
            int vecin = v.first;
            grad_intern[vecin]--;
            if(grad_intern[vecin] == 0)
                C.push(vecin);
        }
    }
}

void DAG(vector<vector<pair<int, int>>> &graf, int start)
{
    d[start] = 0;
    bool found_in_sort = false;
    TopoSortBFS(graf);
    for(auto u : ordonare) // pt fiecare varf din sortarea topologica
    {
        // ca sa ignor vf neaccesibile din start
        if(u != start && !found_in_sort)
            continue;
        else if(u == start)
            found_in_sort = true;
        for(auto vecin : graf[u]) // pentru fiecare v, succesor al lui u
        {
            int v = vecin.first, w_uv = vecin.second;
            if(d[v] > d[u] + w_uv) 
            {
                d[v] = d[u] + w_uv;
                tata[v] = u;
            }
        }
    }
}

void AfisareListe(vector<vector<pair<int,int>>> L){
    cout << "LISTE DE ADIACENTA\n----------------------\n";
    for(int nod = 1; nod <= L.size() - 1; nod++){
        cout << nod << " -> ";
        for(auto vecin : L[nod])
            cout << vecin.first << ", " << vecin.second << "  ";
        cout << "\n";
    }
}

void reconstituie_drum(int v)
{
    if(v != 0)
    {
        reconstituie_drum(tata[v]);
        cout << v << " ";
    }
}

int main()
{
    vector<vector<pair<int,int>>> listeAdiacenta;
    
    listeAdiacenta = MemoGrafLista(1);
    AfisareListe(listeAdiacenta);

    d.assign(listeAdiacenta.size(), inf);
    tata.assign(listeAdiacenta.size(), 0);
    // exemplu
    DAG(listeAdiacenta, 3);
    cout << "Distanta de la 3 la 2 este: ";
    if(d[2] == inf)
        cout << "Nu exista drum!\n";
    else 
    {
        cout << d[2] << endl;
        cout << "Drumul: ";
        reconstituie_drum(2);
    }
}

/*
    5 7 
    1 4 1 
    1 3 5 
    1 2 10 
    2 3 2 
    4 2 6 
    4 5 12 
    5 2 11


    6 8
    1 6 2
    1 5 1
    3 5 4
    3 2 8
    5 2 7
    5 4 2
    4 2 1
    6 2 1
*/