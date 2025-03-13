#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>

using namespace std;


struct edge
{
    int a, b, cost;
    edge(int x, int y, int c)
    {   a = x; b = y; cost = c; }

    bool operator== (const edge &e)
    { 
        if (a == e.a && b == e.b) 
            return true; 
        return false; 
    } 
};


int n, m, mst_cost, mst_cost2;
int parent[100];
int h[100];
int x[3], y[3];
vector<edge> edgeList, mst_edges, mst_edges2, mst_2_corect;
//vector<pair<int, int>> mst_edges;



void init(int u)
{
    parent[u] = h[u] = 0;
}

int find(int u){
  if (parent[u] == 0) 
	return u;
  parent[u] = find(parent[u]);   
  return parent[u];
}

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

    sort(edgeList.begin(), edgeList.end(), cmp);

    for(int i = 0; i < m; i ++)
    {
        if(find(edgeList[i].a) != find(edgeList[i].b))
        {
            mst_edges.push_back(edgeList[i]);
            mst_cost += edgeList[i].cost;
            nrmsel ++;
            unite(edgeList[i].a, edgeList[i].b);
            if(nrmsel == n-1)
                break;
        }
    }
}

// calculez mst ignorand muchia j
int kruskal_second_best(int j)
{
    int nrmsel = 0;
    mst_cost2 = 0;
    mst_edges2.clear();
    for(int i = 0; i < n; i ++)
        init(i);
    
    for(int i = 0; i < m; i ++)
    {
        if(edgeList[i] == mst_edges[j])
            continue;
        if(find(edgeList[i].a) != find(edgeList[i].b))
        {
            mst_edges2.push_back(edgeList[i]);
            mst_cost2 += edgeList[i].cost;
            nrmsel ++;
            unite(edgeList[i].a, edgeList[i].b);
            if(nrmsel == n-1)
                break;
        }
    }
    if(nrmsel == n - 1)
        return mst_cost2;
    else
        return -1;
}

void read()
{
    ifstream fin("2ndMST.in");
    int x, y, c;
    fin >> n >> m;
    for(int i = 0; i < m; i++)
    {
        fin >> x >> y >> c;
        edgeList.emplace_back(x, y, c);
    }
    fin.close();
}

int main() {

    read();
    kruskal();

    cout<< "Primul\n" << "Cost " << mst_cost << "\nMuchii\n";
    for(auto & mst_edge : mst_edges)
        cout << mst_edge.a << " " << mst_edge.b <<  "\n";

    int sec_best_mst = INT_MAX, cost;
    
    for (int j = 0; j < mst_edges.size(); j++)
    {
        mst_2_corect.clear();
        cost = kruskal_second_best(j);
        if(cost == -1)
            continue;
        if(cost < sec_best_mst)
        {
            sec_best_mst = cost;
            mst_2_corect = mst_edges2;
        }
    }

    cout<< "Al doilea\n" << "Cost " << sec_best_mst << "\nMuchii\n";
    for(auto & mst_edge : mst_2_corect)
        cout << mst_edge.a << " " << mst_edge.b <<  "\n";
    return 0;
}
