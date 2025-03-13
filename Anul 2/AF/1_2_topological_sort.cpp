#include <iostream>
#include <fstream>
#include <vector>
#include <stack>
#include <algorithm>
using namespace std;

/*
    SORTAREA TOPOLOGICA  // Organizarea unor activitati + DETECTAREA DE CICLURI
    5 3
    1 2
    3 1
    4 5

    Daca nu exista o sortare topologica (graful are cicluri), sa se afiseze o lista de activitati
    [c1, c2,..., ck, c1] care depind circular unele de altele
    (c_i sa se desfasoare inainte de c_i-1 si c_k inainte de c_1)
*/

int nrNoduri, nrMuchii;
vector<int> viz, tata, grad_intern, fin;
vector<int> ordonare, circuit;
bool found = false;
stack<int> S;

vector<vector<int>> MemoGrafLista(int tip){
    int i, j;
    ifstream fin; fin.open("dfs.in");
    fin >> nrNoduri >> nrMuchii;
    vector<vector<int>> liste_adiacenta(nrNoduri + 1);
    grad_intern.assign(liste_adiacenta.size(), 0);
    for (int cnt = 0; cnt < nrMuchii; cnt++) {
        fin >> i >> j;
        liste_adiacenta[i].push_back(j);
        if(tip == 0)
            liste_adiacenta[j].push_back(i);
        grad_intern[j]++;
    }
    for(int nod = 1; nod <= int(liste_adiacenta.size() - 1); nod++){
        sort(liste_adiacenta[nod].begin(), liste_adiacenta[nod].end());
    }
    return liste_adiacenta;   
}

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


int main()
{
    vector<vector<int>> listeAdiacenta;
    bool exists = false; // exista nod cu grad intern 0
    
    listeAdiacenta = MemoGrafLista(1);

    viz.assign(listeAdiacenta.size(), 0);
    tata.assign(listeAdiacenta.size(), 0);
    fin.assign(listeAdiacenta.size(), 0);

    // incep dfs-ul dintr-un nod care are gradul intern 0 (ca sa respecte ordonarea)
    for(int i = 1; i <= nrNoduri; i++)
    {
        if(grad_intern[i] == 0)
        {
            exists = true;
            DFS(listeAdiacenta, i);
        }
        else
            if(viz[i] == 0)
                DFS(listeAdiacenta, i);      
    }

    if(!found)
    {
        while(!S.empty())
        {
            int v = S.top();
            S.pop();
            cout << v << " ";
        }
    }
    else
    {
        cout << "\nIMPOSSIBLE\n";
        if(!circuit.empty())
        {
            for(auto v = circuit.rbegin(); v != circuit.rend(); v++)
                cout << *v << " ";
        }  
    }
    return 0;
}