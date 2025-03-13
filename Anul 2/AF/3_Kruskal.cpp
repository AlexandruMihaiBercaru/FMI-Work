#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>

using namespace std;

/* DETERMINAREA ARBORELUI PARTIAL DE COST MINIM
    ALGORITMUL LUI KRUSKAL
    IMPLEMENTARE CU ARBORI UNION - FIND + COMPRESIE DE CALE
    COMPLEXITATE: O(m log n) / O(m log*n) */

struct edge
{
    int a, b, cost;
    edge(int x, int y, int c)
    {   a = x; b = y; cost = c; }
};

int n, m, mst_cost;
int parent[100];
int h[100];
int x[3], y[3];
vector<edge> edgeList;
vector<pair<int, int>> mst_edges;


// initializari
void init(int u)
{
    parent[u] = h[u] = 0;
}

/* gasirea reprezentantului - fara compresie de cale
int find(int i)
{
    while(parent[i] != 0)
        i = parent[i];
    return i;
}
*/


// gasirea reprezentantului - cu compresie de cale
int find(int u){
  if (parent[u] == 0) 
	return u;
  parent[u] = find(parent[u]);   
  return parent[u];
}


// reuniunea componentelor conexe (arborilor) -> link by rank
void unite(int i, int j)
{
    int ri = find(i);
    int rj = find(j);
    if(h[ri] > h[rj])
        parent[rj] = ri;
    else
    {
        parent[ri] = rj;
        if(h[ri] == h[rj])
            h[rj] = h[rj] + 1;
    }
}

bool cmp(edge a, edge b)
{
    return a.cost < b.cost;
}

void kruskal()
{
    int nrmsel = 0;
    for(int i = 0; i < n; i ++)
        init(i);
    // sort the edges
    sort(edgeList.begin(), edgeList.end(), cmp);

    /*for(int i = 0; i <= 2; i++)
    {
        if(find(x[i]) != find(y[i]))
        {
            mst_edges.push_back({x[i], y[i]});
            unite(x[i], y[i]);
        }
    }*/


    for(int i = 0; i < m; i ++)
    {
        /*if( (edgeList[i].a == x[0] && edgeList[i].b == y[0]) ||
            (edgeList[i].a == x[1] && edgeList[i].b == y[1]) ||
            (edgeList[i].a == x[2] && edgeList[i].b == y[2]))
        {
            mst_cost += edgeList[i].cost;
            nrmsel ++;
        }*/
        if(find(edgeList[i].a) != find(edgeList[i].b))
        {
            mst_edges.push_back({edgeList[i].a, edgeList[i].b});
            mst_cost += edgeList[i].cost;
            nrmsel ++;
            unite(edgeList[i].a, edgeList[i].b);
            if(nrmsel == n-1)
                break;
        }
    }
}


void read()
{
    ifstream fin("grafpond.in");
    int x, y, c;
    fin >> n >> m;
    for(int i = 0; i < m; i++)
    {
        fin >> x >> y >> c;
        edgeList.emplace_back(x, y, c);
    }
    fin.close();
}

/*
    Modificați programul de la a) astfel încât să determine (dacă există) un arbore parțial 
    de cost cât mai mic care să conțină 3 muchii ale căror extremități se citesc de la tastatură. 
    Se vor afișa muchiile arborelui determinat.
*/
int main() {

    /*for(int i = 0; i <= 2; i++)
        cin >> x[i] >> y[i];*/
    read();
    kruskal();
    cout << mst_cost << endl;
    for(auto & mst_edge : mst_edges)
        cout << mst_edge.first << " " << mst_edge.second <<  "\n";
    return 0;
}


/*
9 14
1 2 10
1 3 -11
2 4 11
2 5 11
5 6 13
3 4 10
4 6 12
4 7 5
3 7 4
3 8 5
8 7 5
8 9 4
9 7 3
6 7 11

*/