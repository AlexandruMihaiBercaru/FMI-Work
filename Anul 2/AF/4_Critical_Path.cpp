#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <queue>
using namespace std;

/*Algoritm generic pentru determinarea drumurilor minime in DAG (Directed Acyclic Graph)*/

/* 
    Drum critic in graf de dependente - Aplicatie DAG
    Durata minimă a proiectului = costul maxim al unui drum de la S la T
    Timpul minim de început al unei activități u = costul maxim al unui drum de la S la u
*/

int inf = 10000000;
vector<int> viz, tata, grad_intern, d;
vector<int> ordonare, start_time;
queue<int> C;
ifstream fin("activitati.in");

void TopoSortBFS(vector<vector<pair<int,int>>> &graf)
{
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
            // daca gasesc un drum cu cost mai mare -> actualizez
            if(d[v] < d[u] + w_uv) 
            {
                d[v] = d[u] + w_uv;
                tata[v] = u;
            }
        }
    }
}


void reconstituie_drum(int v, int n)
{
    if(v != 0)
    {
        reconstituie_drum(tata[v], n);
        if(v != n + 1)
            cout << v << " ";
    }
}

void AfisareListe(vector<vector<pair<int,int>>> L){
    cout << "LISTE DE ADIACENTA\n----------------------\n";
    for(int nod = 0; nod <= L.size() - 1; nod++){
        cout << nod << " -> ";
        for(auto vecin : L[nod])
            cout << vecin.first << ", " << vecin.second << "  ";
        cout << "\n";
    }
}

int main()
{
    int n, m, i, j, tp;
    vector<int> activitati;
    activitati.push_back(0);
    fin >> n;
    int T = n + 1;
    vector<vector<pair<int, int>>> listeAdiacenta(n + 2);
    grad_intern.assign(listeAdiacenta.size() + 1, 0);
    for(int i = 1; i <= n; i++)
    {
        fin >> tp;
        activitati.push_back(tp);
    }
    fin >> m;
    for(int k = 1; k <= m; k++)
    {
        fin >> i >> j;
        listeAdiacenta[i].push_back({j, activitati[i]});
        grad_intern[j]++;
    }
    C.push(0);
    for(int i = 1; i <= n; i++)
    {
        if(grad_intern[i] == 0)
        {
            C.push(i);
            listeAdiacenta[0].push_back({i, 0});
            grad_intern[i]++;
        }
        else if(listeAdiacenta[i].size() == 0) // activitate fara dependente
        {
            listeAdiacenta[i].push_back({T, activitati[i]});
            grad_intern[T]++;
        }
    }
    cout << endl << grad_intern[T] << endl;
    AfisareListe(listeAdiacenta);
    TopoSortBFS(listeAdiacenta);

    d.assign(listeAdiacenta.size(), -inf);
    tata.assign(listeAdiacenta.size(), 0);

    DAG(listeAdiacenta, 0);

    cout << "Timp minim: " << d[n+1] << endl;
    cout << "Activitati critice: ";
    reconstituie_drum(T, n);
    cout << endl;
    for(i = 1; i <= n; i++)
        cout << i << ": " << d[i] << " " << d[i] + activitati[i] << "\n";

    return 0;
}
