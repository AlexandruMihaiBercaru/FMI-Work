#include <fstream>
#include <iostream>
#include <vector>
#include <set>
#include <queue>
#include <algorithm>

using namespace std;
/*
Se consideră o reţea de transport (care verifică ipotezele din curs) şi un flux în
această reţea. Se citesc din fișierul retea.in următoarele informații despre această rețea:
numărul de vârfuri n (numerotate 1…n), două vârfuri s şi t reprezentând sursa şi destinaţia,
numărul de arce m şi pe câte o linie informaţii despre fiecare arc: extremitatea iniţială,
extremitatea finală, capacitatea arcului şi fluxul deja trimis pe arc.
a) Să se verifice dacă fluxul dat este corect (respectă constrângerile de mărginire şi conservare)
şi să se afişeze un mesaj corespunzător
b) Să se determine un flux maxim în reţea pornind de la acest flux, prin revizuiri succesive
ale fluxului pe s-t lanţuri nesaturate de lungime minimă (Algoritmul Ford - Fulkerson va
porni de la fluxul dat, nu de la fluxul vid). Se vor afişa
- Valoarea fluxului obţinut şi fluxul pe fiecare arc
- Capacitatea minimă a unei tăieturi în reţea şi arcele directe ale unei tăieturi minime
O(mL), L= capacitatea minimă a unei tăieturi / O(nm2)

        ------retea.in----------
        6
        1 6
        8
        1 3 6 3
        1 5 8 2
        3 2 5 0
        3 4 3 3
        5 4 4 2
        2 6 7 0
        4 6 5 5
        3 5 1 0
*/
int inf = 10000000;
int nrNoduri, nrMuchii, s, t;
vector<int> viz, tata, grad_intern, d, flux, capacitate;
// pentru fiecare i => arce_directe[i] = LISTA INDICILOR ARCELOR DIRECTE / analog inverse
// arcul uv : direct pentru u, invers pentru v (are sens?)
vector<vector<int>> arce_directe, arce_inverse;
vector<pair<int, int>> lant_nesat;
vector<int> Xf; // multimea nodurilor determinate de ultima parcurgere (sunt in multimea lui s)

vector<pair<int, int>> MemoListaMuchii(){
    int i, j, f, c;
    ifstream fin; fin.open("retea.in");
    fin >> nrNoduri >> s >> t >> nrMuchii;

    vector<pair<int, int>> liste_muchii(nrMuchii + 1);
    liste_muchii.push_back({-1,-1}); flux.push_back(-1); capacitate.push_back(-1);
    arce_directe.resize(nrMuchii + 1); arce_inverse.resize(nrMuchii + 1);
    for (int cnt = 1; cnt <= nrMuchii; cnt++) {
        fin >> i >> j >> c >> f;
        liste_muchii[cnt]={i, j};
        flux.push_back(f); 
        capacitate.push_back(c);
        arce_directe[i].push_back(cnt); 
        arce_inverse[j].push_back(cnt);
    }
    return liste_muchii;   
}


bool check_proprietati_flux()
{
    for(int k = 1; k <= nrMuchii; k++)
        if(flux[k] < 0 || flux[k] > capacitate[k])
            return false;
    return true;
}


bool construieste_st_lant_nesat(vector<pair<int, int>> &edgeList)
{
    bool e_lant = false;
    bool exit_check = false;
    tata.assign(nrNoduri + 1, 0);
    viz.assign(nrNoduri + 1, 0);
    lant_nesat.clear();
    Xf.clear();
    viz[s] = 1;
    queue<int> myqueue;
    myqueue.push(s);
    while(!myqueue.empty())
    {
        int nod_crt = myqueue.front();
        Xf.push_back(nod_crt);
        myqueue.pop();
        //cout << "A scos din coada nodul " << nod_crt << endl;
        //parcurg lista de arce directe pentru acel varf
        for(auto cnt : arce_directe[nod_crt])
        {
            pair<int, int> arc = edgeList[cnt];
            //cout << "    Arcul curent: " << arc.first << " " << arc.second << "\n";
            if(viz[arc.second] == 0 && capacitate[cnt] - flux[cnt] > 0)
            {
                //cout << "    PARCURGE ARCUL: " << arc.first << " " << arc.second << " SI VIZITEAZA NODUL " << arc.second << "\n";
                myqueue.push(arc.second);
                viz[arc.second] = 1; 
                tata[arc.second] = arc.first;
                if(arc.second == t)
                {
                    e_lant = true;
                    int y = t;
                    //cout << "am gasit lant!!\n";
                    while(tata[y] != 0)
                    {  
                        if(tata[y] > 0)
                            lant_nesat.push_back({tata[y], y});
                        else
                            lant_nesat.push_back({y, abs(tata[y])});
                        y = abs(tata[y]);
                    }
                    break;
                }
            }
        }
        if(e_lant) 
        {
            exit_check = true;
            break;
        }
        //parcurg lista de arce inverse pentru acel varf
        for(auto cnt : arce_inverse[nod_crt])
        {
            pair<int, int> arc = edgeList[cnt];
            //cout << "    Arcul curent: " << arc.second << " " << arc.first << "\n";
            if(viz[arc.first] == 0 && flux[cnt] > 0)
            {
                //cout << "    PARCURGE ARCUL: " << arc.second << " " << arc.first << " SI VIZITEAZA NODUL " << arc.first << "\n";
                myqueue.push(arc.first);
                viz[arc.first] = 1; 
                tata[arc.first] = -1 * arc.second;
                if(arc.first == t)
                {
                    //cout << "am gasit lant!!\n";
                    e_lant = true;
                    int y = t;
                    while(tata[y] != 0)
                    {  
                        if(tata[y] > 0)
                            lant_nesat.push_back({tata[y], y});
                        else
                            lant_nesat.push_back({y, abs(tata[y])});
                        y = abs(tata[y]);
                    }
                    break;
                }
            }
        }
        if(e_lant) 
        {
            exit_check = true;
            break;
        }
    }
    return exit_check;
}


void revizuieste_flux(vector<pair<int, int>> &edgeList)
{
    int capacitate_reziduala_min = 100000, capacitate_reziduala_arc;
    //cout << "lantul nesaturat este: " << endl;
    // DETERMIN CAPACITATEA REZIDUALA A LANTULUI
    for(auto v = lant_nesat.rbegin(); v != lant_nesat.rend(); v++)
    {
        pair<int, int> arc = *v;
        //cout << "(" << arc.first << " " << arc.second << ") ";
        auto it = find(edgeList.begin(), edgeList.end(), arc);
        int poz = distance(edgeList.begin(), it);
        if(tata[arc.first] == -1 * arc.second) // e invers
        {
            capacitate_reziduala_arc = flux[poz];
            if(capacitate_reziduala_min > capacitate_reziduala_arc)
                capacitate_reziduala_min = capacitate_reziduala_arc;
        }
        if(tata[arc.second] == arc.first) // e direct
        {
            capacitate_reziduala_arc = capacitate[poz] - flux[poz];
            if(capacitate_reziduala_min > capacitate_reziduala_arc)
                capacitate_reziduala_min = capacitate_reziduala_arc;
        }
    }
    //ACTUALIZEZ FLUXUL PE ARCELE DIN LANTUL NESATURAT
    for(auto v = lant_nesat.rbegin(); v != lant_nesat.rend(); v++)
    {
        pair<int, int> arc = *v;
        //cout << "ACTUALIZEZ CU " << capacitate_reziduala_min << endl; 
        auto it = find(edgeList.begin(), edgeList.end(), arc);
        int poz = distance(edgeList.begin(), it);
        if(tata[arc.first] == -1 * arc.second) // e invers
            flux[poz] -= capacitate_reziduala_min;
        if(tata[arc.second] == arc.first) // e direct
            flux[poz] += capacitate_reziduala_min;
    }
}


int determina_val_flux()
{
    int valf = 0;
    for(int i = 0; i < arce_inverse[t].size(); i++)
        valf += flux[arce_inverse[t][i]];
    return valf;
}


int determina_mincut(vector<pair<int, int>> &edgeList)
{
    int K = 0;
    for(auto vf : Xf)
        for(int i = 0; i < arce_directe[vf].size(); i++)
            if(flux[arce_directe[vf][i]] == capacitate[arce_directe[vf][i]])
            {
                cout << vf << " " << edgeList[arce_directe[vf][i]].second << endl;
                K += flux[arce_directe[vf][i]];
            }
    return K;
}


void afiseaza_flux(vector<pair<int, int>> &edgeList)
{
    cout << determina_val_flux() << endl;
    for(int i = 1; i <= nrMuchii; i++)
        cout << edgeList[i].first << " " << edgeList[i].second << " " << flux[i] << endl;
    int cK = determina_mincut(edgeList);
    cout << cK << endl;
}



int main()
{
    vector<pair<int, int>> lista_muchii = MemoListaMuchii();
    d.assign(nrNoduri + 1, inf);
    tata.assign(nrNoduri + 1, 0);
    viz.assign(nrNoduri + 1, 0);

    if(check_proprietati_flux() == true)
        cout << "\nDA" << endl;
    else 
        cout << "\nNU" << endl;

    bool exista_lant = construieste_st_lant_nesat(lista_muchii);
    while(exista_lant == true)
    {
        revizuieste_flux(lista_muchii);
        exista_lant = construieste_st_lant_nesat(lista_muchii);
    }
    afiseaza_flux(lista_muchii);

    return 0;
}