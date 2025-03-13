#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <algorithm>
using namespace std;
/*
 * Se considera un graf orientat cu N varfuri si M arce.
 * Fiind dat un nod S, sa se determine, pentru fiecare nod X,
 * numarul minim de arce ce trebuie parcurse pentru a ajunge din nodul sursa S la nodul X.
 * 
 * Se mai citeste un varf x si să se afișeze un drum minim (cu număr minim de arce) de la s la x
 * 
 * --bfs.in--
 *  5 7 2 3
    1 2
    2 1
    2 2
    3 2
    2 5
    5 3
    4 5
 */

int inf = 2147483647;
int nrNoduri, nrMuchii, s, x;
vector<int> viz, dist, tata;

vector<vector<int>> MemoGrafLista(int tip){
    int i, j;
    ifstream fin;
    fin.open("bfs.in");
    fin >> nrNoduri >> nrMuchii;
    fin >> s >> x;
    //creez n liste vide
    vector<vector<int>> liste_adiacenta(nrNoduri + 1);
    for (int cnt = 0; cnt < nrMuchii; cnt++) {
        fin >> i >> j;
        liste_adiacenta[i].push_back(j);
        if(tip == 0)
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
                cout << nod_crt << " " << vecin << endl;
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

int main() {  
    vector<vector<int>> listeAdiacenta;
    listeAdiacenta = MemoGrafLista(0);

    viz.assign(listeAdiacenta.size(), 0);
    dist.assign(listeAdiacenta.size(), inf);
    tata.assign(listeAdiacenta.size(), 0);

    if(nrMuchii < nrNoduri - 1)
        cout << "Nu";
    else
    {
        bfsDistante(listeAdiacenta, s);

        for(int cnt = 1; cnt <= nrNoduri; cnt++){
            if(dist[cnt] == inf)
                cout << -1 << " ";
            else
                cout << dist[cnt] << " ";
        }

        cout << "\nDrumul:\n";

        if(viz[x] == 1)
            lant(x);
        else
            cout << "Nu exista drum de la " << s << " la " << x;

    }
    
    return 0;
}
