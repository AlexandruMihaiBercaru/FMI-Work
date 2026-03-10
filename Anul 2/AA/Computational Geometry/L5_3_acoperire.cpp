#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <iomanip>

using namespace std;
ifstream fin("input.txt");

bool cmp(pair< double,  double> a, pair< double,  double> b){
    return (a.first < b.first) || (a.first == b.first && a.second < b.second);
}

 double det( double xp,  double yp,  double xq, 
     double yq,  double xr,  double yr){
    return (xq - xp) * (yr - yp) - (yq - yp) * (xr - xp);
}

vector<pair< double, double>> determina_frontiera(vector<pair< double,  double>> varfuri){
    vector<pair< double, double>> frontiera = {varfuri[0], varfuri[1]};
    int k = frontiera.size();
    for(int i = 2; i < (int)varfuri.size(); i++){
        frontiera.push_back(varfuri[i]);
        
        k++;

        while(k >= 3){
            double D = det(frontiera[k-3].first, frontiera[k-3].second, 
                       frontiera[k-2].first, frontiera[k-2].second,
                       frontiera[k-1].first, frontiera[k-1].second);

            if(D > 0)
                break;

            // sterg din frontiera punctul in care a avut loc virajul (antepenultimul => indicele k-2)    
            frontiera.erase(frontiera.begin() + (k-2));
            k--;   
        }
    }
    // sterg ultimul element (pentru a nu aparea duplicate cel mai din stanga si dreapta punct)
    frontiera.pop_back();
    return frontiera;
}

int main(){

    int nr_puncte, i;
    fin >> nr_puncte;
    vector<pair<double,  double>> poligon(nr_puncte);

    for(i = 0; i < nr_puncte; i++){
        fin >> poligon[i].first >> poligon[i].second;
    }

    sort(poligon.begin(), poligon.end(), cmp);

    vector<pair< double,  double>> frontiera_inf = determina_frontiera(poligon);
    reverse(poligon.begin(), poligon.end());
    vector<pair< double,  double>> frontiera_sup = determina_frontiera(poligon);
    frontiera_inf.insert(frontiera_inf.end(), frontiera_sup.begin(), frontiera_sup.end());

    cout << int(frontiera_inf.size()) << "\n";
    for(i = 0; i < (int)frontiera_inf.size(); i++){
        cout << setprecision(10);
        cout << frontiera_inf[i].first << " " << frontiera_inf[i].second << "\n";

    }
        
    return 0;
}