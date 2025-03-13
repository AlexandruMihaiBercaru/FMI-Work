#include <iostream>
#include <fstream>
#include <vector>
#include <stack>
#include <algorithm>
using namespace std;

/*  Infoarena - determinarea componentelor tare conexe (CTC) - Algoritmul lui Kosaraju
    Dându-se un graf orientat G = (V, E) se cere să se determine componentele sale tare conexe.
    8 12
    1 2
    2 6
    6 7
    7 6
    3 1
    3 4
    2 3
    4 5
    5 4
    6 5
    5 8
    8 7
*/

int nrNoduri, nrMuchii;
vector<int> viz, tata;
vector<int> noduri_ctc;
bool found = false;
vector<vector<int>> GT;

vector<vector<int>> MemoGrafLista(){
    int i, j;
    ifstream fin; fin.open("ctc.in");
    fin >> nrNoduri >> nrMuchii;
    vector<vector<int>> liste_adiacenta(nrNoduri + 1);
    GT.resize(nrNoduri + 1);
    for (int cnt = 0; cnt < nrMuchii; cnt++) {
        fin >> i >> j;
        liste_adiacenta[i].push_back(j);
        GT[j].push_back(i);
    }
    for(int nod = 1; nod <= int(liste_adiacenta.size() - 1); nod++){
        sort(liste_adiacenta[nod].begin(), liste_adiacenta[nod].end());
        sort(GT[nod].begin(), GT[nod].end());
    }
    return liste_adiacenta;   
}

void DFS(vector<vector<int>> &graf, int start, stack<int> &pstack, vector<int> &varfuri)
{
    viz[start] = 1;
    varfuri.push_back(start);
    for(auto vecin : graf[start])
    {
        if(viz[vecin] == 0)
        {
            tata[vecin] = start;
            DFS(graf, vecin, pstack, varfuri);
        }
    }
    pstack.push(start);
}

int main()
{
    vector<vector<int>> G, lista_ctc;
    vector<int> vf_ctc;
    stack<int> S, ST;
    int nr_ctc = 0;
    
    G = MemoGrafLista();

    viz.assign(G.size(), 0);
    tata.assign(G.size(), 0);

    for(int i = 1; i <= nrNoduri; i++)
    {
        if(viz[i] == 0)
            DFS(G, i, S, vf_ctc);              
    }

    viz.assign(G.size(), 0);
    while(!S.empty())
    {
        int v = S.top();
        S.pop();
        if(viz[v] == 0)
        {
            vf_ctc.clear();
            DFS(GT, v, ST, vf_ctc);
            nr_ctc++;
            lista_ctc.push_back(vf_ctc);
        }
    }
    ofstream g("ctc.out");
    g << nr_ctc << endl;
    for(auto ctc : lista_ctc)
    {
        for(int i = 0; i < int(ctc.size()); i++)
            g << ctc[i] << " ";
        g << endl;
    }
    return 0;
}