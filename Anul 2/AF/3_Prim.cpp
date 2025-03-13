#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <queue>
using namespace std;

/* DETERMINAREA ARBORELUI PARTIAL DE COST MINIM
   ALGORITMUL LUI PRIM
   COMPLEXITATE: O(m log n) - IMPLEMENTAREA CU MIN-HEAP */

#define inf 2147483647

struct edge
{
    int a, b, cost;
    edge(int x, int y, int c)
    {   a = x; b = y; cost = c; }
};

int n, m, mst_cost;
// muchiile din apcm
vector<pair<int, int>> mst_edges;
// listele de adiacenta: pentru un nod -> (vecin1, d[vecin1]), (vecin2, d[vecin2]),...
vector<vector<pair<int, int>>> listeAdiacenta;
vector<int> d, tata, viz;
// heap-ul (implementat cu un pq)
priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> Q;

void prim(int s)
{
    int nrmsel = 0;
    d[s] = 0;
    //initializez heap
    Q.push({d[s], s});
    while(!Q.empty())
    {
        //extrag din heap un element de forma (d[nod], nod)
        pair<int, int> per = Q.top(); 
        Q.pop();
        int c = per.first, u = per.second;
        if(viz[u] == 1)
            continue;
        cout << "Am extras nodul " << u << " cu costul " << c << "\n";
        if(tata[u] != 0) // pt orice alt nod in afara de cel de start -> adaug muchia incidenta lui si tatalui sau in apcm
        {
            mst_edges.push_back({tata[u], u});
            nrmsel++;
        }
        mst_cost += c;
        // dupa ce il scot din coada, il vizitez
        viz[u] = 1;
        // pentru fiecare vecin al lui u, care nu a fost vizitat, actualizez etichetele d si tata
        for(int v = 0; v < listeAdiacenta[u].size(); v++)
        {
            int vecin = listeAdiacenta[u][v].first, w_uv = listeAdiacenta[u][v].second;
            if(viz[vecin] == 0 && w_uv < d[vecin])
            {
                d[vecin] = w_uv;
                tata[vecin] = u;
                //repar heap-ul
                Q.push({d[vecin], vecin});
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

int main()
{
    ifstream fin("grafpond.in");
    int x, y, c;
    fin >> n >> m;
    listeAdiacenta.resize(n + 1);
    for(int i = 0; i < m; i++)
    {
        fin >> x >> y >> c;
        listeAdiacenta[x].push_back({y, c});
        listeAdiacenta[y].push_back({x, c});
    }
    fin.close();
    AfisareListe(listeAdiacenta);
    viz.assign(n + 1, 0);
    tata.assign(n + 1, 0);
    d.assign(n + 1, inf);

    prim(1);
    cout << mst_cost << endl;
    for(auto & mst_edge : mst_edges)
        cout << mst_edge.first << " " << mst_edge.second <<  "\n";
    return 0;
}