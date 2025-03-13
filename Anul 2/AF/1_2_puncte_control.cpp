#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <algorithm>
using namespace std;

/*
    Se dă o rețea neorientată cu n noduri și o listă de noduri reprezentând puncte de control pentru rețea. 
    Se citește un nod de la tastatură. Să se determine cel mai apropiat punct de control de acesta 
    și un lanț minim până la acesta

    graf.in (pe ultima linie se dau punctele de control)
    9 11
    1 2
    1 3
    1 4
    2 5
    2 9
    3 5
    3 7
    5 7
    6 7
    6 8
    4 6
    8 9
*/

int nrNoduri, nrMuchii;
vector<int> viz, dist, tata;
ifstream fin("graf.in");


vector<vector<int>> MemoGrafLista(int tip){
    int i, j;
    
    fin >> nrNoduri >> nrMuchii;
    //fin >> s >> x;
    //creez n liste vide
    vector<vector<int>> liste_adiacenta(nrNoduri + 1);
    for (int cnt = 0; cnt < nrMuchii; cnt++) {
        fin >> i >> j;
        liste_adiacenta[i].push_back(j);
        if(tip == 0) //este NEORIENTAT
            liste_adiacenta[j].push_back(i);
    }
    for(int nod = 1; nod <= liste_adiacenta.size() - 1; nod++){
        sort(liste_adiacenta[nod].begin(), liste_adiacenta[nod].end());
    }
    return liste_adiacenta;
}

void bfsDistante(std::vector<std::vector<int>> &graf, int s){
    int nod_crt;
    queue<int> myqueue;
    myqueue.push(s);
    viz[s] = 1;
    dist[s] = 0;
    while(!myqueue.empty()){
        nod_crt = myqueue.front();
        myqueue.pop();
        //std::cout << nod_crt << " ";
        //parcurg lista de adiacenta a nodului
        for(auto vecin : graf[nod_crt]){
            if(viz[vecin] ==0){
                myqueue.push(vecin);
                viz[vecin] = 1;
                dist[vecin] = dist[nod_crt] + 1;
                tata[vecin] = nod_crt;
            }
        }
    }
}

void lant(int v)
{
    if(v != 0)
    {
        lant(tata[v]);
        cout << v << " ";
    }
}

int main()
{
    vector<vector<int>> listeAdiacenta;
    vector<int> puncte_control;
    int nod_start, inf = 2147483647, pc, nod_final;
    int dist_min = inf;
    listeAdiacenta = MemoGrafLista(0);
    
    // pentru un singur nod de start
    // cout << "Nodul de start: ";
    // cin >> nod_start;

    while(fin >> pc)
        puncte_control.push_back(pc);

    viz.resize(listeAdiacenta.size(), 0);
    dist.resize(listeAdiacenta.size(), inf);
    tata.resize(listeAdiacenta.size(), 0);

    
    //bfsDistante(listeAdiacenta, nod_start);
    /*
    for (auto pc : puncte_control)
    {
        if(dist[pc] < dist_min && viz[pc] == 1)
        {
            dist_min = dist[pc];
            nod_final = pc;
        }
    }
    */

    //lant(nod_final);

    /*  adaptare:
        Să se determine pentru fiecare nod din rețea distanța până la cel mai apropiat punct de control de acesta.
    */

    for (int i = 1; i <= nrNoduri; i++)
    {
        dist_min = inf;
        if(find(puncte_control.begin(), puncte_control.end(), i) == puncte_control.end())
        {
            viz.assign(listeAdiacenta.size(), 0);
            dist.assign(listeAdiacenta.size(), inf);
            tata.assign(listeAdiacenta.size(), 0);

            bfsDistante(listeAdiacenta, i);
            //cout << "Distanta de la " << i << " la " << 9 << " este: " << dist[9] << endl;

            for (auto pc : puncte_control)
            {
                if(dist[pc] < dist_min && viz[pc] == 1 && dist[pc] != 0)
                {
                    dist_min = dist[pc];
                    //nod_final = pc;
                }
            }
            cout << dist_min << " ";
        }
        else // e deja punct de control
        {
            cout << 0 << " ";
        }
    }
    return 0;
}

