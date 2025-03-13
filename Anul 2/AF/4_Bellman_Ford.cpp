#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <queue>
using namespace std;

/* 
    Bellman Ford
    DRUMURI MINIME IN GRAF ORIENTAT, CU CIRCUITE, CU COSTURI REALE (se accepta costuri negative)
    ++ detectia de circuit negativ si afisarea unui circuit

    exemplu fara circuite

    4 5
    1 2 2
    4 2 7
    2 3 2
    3 4 3
    1 3 1
    1

    exemplu cu circuite

    4 4
    1 2 1
    4 2 -7
    2 3 2
    3 4 3
    2
*/
int inf = 10000000;
int nrNoduri, nrMuchii, s;
bool are_circuit;
vector<int> tata, d;
vector<int> circuit;

vector<vector<pair<int, int>>> MemoGrafLista(int tip){
    int i, j, cost;
    ifstream fin; fin.open("grafpond.in");
    fin >> nrNoduri >> nrMuchii;
    vector<vector<pair<int, int>>> liste_adiacenta(nrNoduri + 1);
    for (int cnt = 0; cnt < nrMuchii; cnt++) {
        fin >> i >> j >> cost;
        liste_adiacenta[i].push_back({j, cost});
        if(tip == 0)
            liste_adiacenta[j].push_back({i, cost});
    }
    fin >> s;
    for(int nod = 1; nod <= int(liste_adiacenta.size() - 1); nod++){
        sort(liste_adiacenta[nod].begin(), liste_adiacenta[nod].end());
    }
    return liste_adiacenta;   
}

void bellman_ford(vector<vector<pair<int, int>>> &graf, int start)
{
    d[start] = 0;
    are_circuit = false;
    // n-1 pasi
    for(int k = 1; k <= nrNoduri - 1; k++)
    {
        // parcurg listele de adiacenta => O(m)
        for(int u = 1; u <= graf.size() - 1; u++){
            for(auto vecin : graf[u])
            {
                int v = vecin.first, cost = vecin.second;
                if(d[u] + cost < d[v])
                {
                    d[v] = d[u] + cost;
                    tata[v] = u;
                }
            }
        }
    }
    // al n-lea pas pentru detectarea circuitelor negative
    // pentru fiecare muchie din lista de adiacenta, verific daca se mai actualizeaza o data
    for(int u = 1; u <= graf.size() - 1; u++){
        int v, cost;
        for(auto vecin : graf[u])
        {
            int v = vecin.first, cost = vecin.second;
            if(d[u] + cost < d[v])
            {
                // s-a actualizat eticheta lui v => circuit
                d[v] = d[u] + cost;
                tata[v] = u;
                are_circuit = true;
                int x = v;
                // facem n pasi inapoi din v catre s (!! v nu este obligatoriu din circuit, x dupa n pasi sigur este)
                for(int t = 1; t <= nrNoduri; t++)
                    x = tata[x];
                // aflam circuitul folosind tata
                circuit.push_back(x);
                int y = tata[x];
                while (y != x)
                {
                    circuit.push_back(y);
                    y = tata[y];
                }
                // il pun pe x si la final ca sa ma asigur ca 
                circuit.push_back(y);
                break;
            }
        }
        if(are_circuit)
            break;
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
    //AfisareListe(listeAdiacenta);

    d.assign(listeAdiacenta.size(), inf);
    tata.assign(listeAdiacenta.size(), 0);
    bellman_ford(listeAdiacenta, s);
    if(!are_circuit)
    {
        for(int nod = 1; nod <= nrNoduri; nod++)
        {
            // daca varful nod este accesibil din s (si nu este s)
            if(d[nod] != inf && nod != s)   
            {
                cout << "Drum: ";
                reconstituie_drum(nod);
                cout << "Cost: " << d[nod];
                cout << endl;
            }
        }
    }
    else // afisam circuitul cu cost negativ detectat
    {
        if(!circuit.empty())
        {
            cout << "Circuit de cost negativ: " << endl;
            for(auto v = circuit.rbegin(); v != circuit.rend(); v++)
                cout << *v << " ";
        }
    }
    return 0;
}