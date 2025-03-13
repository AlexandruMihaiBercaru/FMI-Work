#include <fstream>
#include <iostream>
#include <vector>
#include <set>
#include <queue>
#include <algorithm>

using namespace std;
ifstream f("djikstra.in");

/*
    djikstra cu puncte de control 
    (se dau k puncte de control, sa se afle care este cel mai apropiat de sursa s + afisarea drumului)
    COMPLEXITATE DJIKSTRA : idem prim
    7 9
    1 2 8
    1 3 1
    1 4 2
    3 2 4
    2 6 3
    3 5 6
    4 5 5
    6 5 2
    5 7 6
    3
    5 6 7
    1
*/
struct edge
{
    int a, b, cost;
    edge(int x, int y, int c)
    {
        a = x;
        b = y;
        cost = c;
    }
    friend ostream& operator<< (ostream &os, const edge & e)
    {
        os << "(" << e.a << "," << e.b << ")";
        return os;
    }
    friend bool operator< (const edge &e1, const edge &e2)
    {
        if(e1.cost < e2.cost)
            return true;
        return false;
    }
};

priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> H;

int inf = 10000000;
int nrNoduri, nrMuchii, s, k;
bool are_circuit;
vector<int> tata, d, viz, puncte_control;
vector<int> circuit;

vector<vector<pair<int, int>>> MemoGrafLista(int tip){
    int i, j, cost, pc;
    ifstream fin; fin.open("grafpond.in");
    fin >> nrNoduri >> nrMuchii;
    vector<vector<pair<int, int>>> liste_adiacenta(nrNoduri + 1);
    for (int cnt = 0; cnt < nrMuchii; cnt++) {
        fin >> i >> j >> cost;
        liste_adiacenta[i].push_back({j, cost});
        if(tip == 0)
            liste_adiacenta[j].push_back({i, cost});
    }
    fin >> k;
    for(int i = 0; i < k; i++)
    {
        fin >> pc; 
        puncte_control.push_back(pc);
    }
    fin >> s;
    for(int nod = 1; nod <= int(liste_adiacenta.size() - 1); nod++){
        sort(liste_adiacenta[nod].begin(), liste_adiacenta[nod].end());
    }
    return liste_adiacenta;   
}

void djikstra(vector<vector<pair<int, int>>> &graf, int start)
{
    d[start] = 0;
    H.push(make_pair(d[start], start));
    while(!H.empty())
    {
        pair<int, int> nod = H.top();
        H.pop();
        int u = nod.second;
        if(viz[u] == 1)
            continue;
        viz[u] = 1;
        for(auto p: graf[u]) 
        {
            int v = p.first, w_uv = p.second;
            if (d[v] > w_uv + d[u]) {
                d[v] = w_uv + d[u];
                tata[v] = u;
                H.push(make_pair(d[v], v));
            }
        }
    }
}

void AfisareListe(vector<vector<pair<int,int>>> L){
    cout << "LISTE DE ADIACENTA\n----------------------\n";
    for(int nod = 1; nod <= L.size() - 1; nod++){
        cout << nod << " -> ";
        for(auto vecin : L[nod])
            cout << "(" << vecin.first << " " << vecin.second << ") ";
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


int main() {
    vector<vector<pair<int,int>>> listeAdiacenta;
    
    listeAdiacenta = MemoGrafLista(0);

    AfisareListe(listeAdiacenta);
    d.assign(listeAdiacenta.size(), inf);
    tata.assign(listeAdiacenta.size(), 0);
    viz.assign(listeAdiacenta.size(), 0);

    djikstra(listeAdiacenta, s);
    
    int costmin = inf, punct_control;
    for(auto pc : puncte_control)
    {
        if(d[pc] < costmin)
        {
            costmin = d[pc];
            punct_control = pc;
        }
    }

    cout << punct_control << endl;
    reconstituie_drum(punct_control);

    return 0;
}
