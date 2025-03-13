#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <algorithm>
#include <math.h>
using namespace std;

/*
    Se dă o matrice n*m (n,m <= 1000), cu p <= 100 puncte marcate cu 1 (restul valorilor din matrice vor fi 0).
    Distanța dintre 2 puncte ale matricei se măsoară în locații străbătute mergând pe orizontală și pe verticală 
    între cele 2 puncte (distanța Manhattan). Se dă o mulțime M de q puncte din matrice (q <= 1000000). 
    Să se calculeze cât mai eficient pentru fiecare dintre cele q puncte date, care este cea mai apropiată locație
    marcată cu 1 din matrice.

    5 4
    0 0 1 0
    0 0 0 0
    0 1 0 0
    0 0 0 1
    0 0 0 0
    1 1
    1 2
    1 4
    4 1
    5 3
*/

int nrNoduri, nrMuchii;
vector<int> viz, dist;
vector<int> puncte_control;
ifstream fin("graf.in");

vector<vector<int>> MemoGrafLista(int tip){
    int i, j, elem, vecin1, vecin2, x;
    fin >> nrNoduri >> nrMuchii;
    vector<vector<int>> liste_adiacenta(nrNoduri * nrMuchii + 1);
    for(i = 1; i <= nrNoduri; i++)
    {
        for(j = 1; j <= nrMuchii; j++)
        {
            fin >> x;
            elem = nrMuchii * (i - 1) + j; //elem = 4 * (3 - 1) + 4 = 12
            vecin1 = elem + 1; // vecin1 = 13
            vecin2 = elem + nrMuchii; // vecin2 = 12 + 4 = 16
            if (vecin1 - (i - 1) * nrMuchii <= nrMuchii) // vecin1 - (1 - 1) * 4 = 5 - 0 = 5 <= 4 NU 
            {
                liste_adiacenta[elem].push_back(vecin1);
                liste_adiacenta[vecin1].push_back(elem);
            }
            if (vecin2 <= nrNoduri * nrMuchii)
            {
                liste_adiacenta[elem].push_back(vecin2);
                liste_adiacenta[vecin2].push_back(elem);
            }
            if(x == 1)
                puncte_control.push_back(elem);
        }
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
            }
        }
    }
}


int main()
{
    vector<vector<int>> listeAdiacenta;
    listeAdiacenta = MemoGrafLista(0);

    vector<int> puncte_plecare;
    int x, y, elem, inf = 2147483647, dist_min, nod_final;
    while(fin >> x >> y)
    {
        elem = nrMuchii * (x - 1) + y;
        puncte_plecare.push_back(elem);
        //cout << elem << " ";
    }
    for (auto start : puncte_plecare)
    {
        dist_min = inf;

        viz.assign(listeAdiacenta.size(), 0);
        dist.assign(listeAdiacenta.size(), inf);
           
        bfsDistante(listeAdiacenta, start);

        for (auto pc: puncte_control)
        {
            if(dist[pc] < dist_min)
            {
                dist_min = dist[pc];
                nod_final = pc;
            }
        }
        int nr_linie = nod_final % nrMuchii == 0 ? floor(nod_final / nrMuchii) : floor(nod_final / nrMuchii) + 1;
        int nr_coloana = nod_final % nrMuchii == 0 ? nrMuchii : nod_final % nrMuchii;
        cout << dist_min << " [" << nr_linie << ", " << nr_coloana << "]\n";
    }
    return 0;
}