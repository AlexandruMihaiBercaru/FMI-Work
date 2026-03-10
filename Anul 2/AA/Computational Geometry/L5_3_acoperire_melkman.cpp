#include <iostream>
#include <fstream>
#include <vector>
#include <deque>
#include <iomanip>

using namespace std;
ifstream fin("input.txt");

double det( double xp,  double yp,  double xq, 
     double yq,  double xr,  double yr){
    return (xq - xp) * (yr - yp) - (yq - yp) * (xr - xp);
}

deque<pair< double, double>> determina_frontiera(vector<pair< double,  double>> varfuri){
    deque<pair< double, double>> frontiera;

    double D = det(varfuri[0].first, varfuri[0].second, varfuri[1].first, varfuri[1].second, varfuri[2].first, varfuri[2].second);
    if (D > 0){
        frontiera.push_back(varfuri[0]);
        frontiera.push_back(varfuri[1]);
    } 
    else{
        frontiera.push_back(varfuri[1]);
        frontiera.push_back(varfuri[0]);
    }
    frontiera.push_back(varfuri[2]); frontiera.push_front(varfuri[2]);

    for(int i = 3; i < (int)varfuri.size(); i++){
        auto p = varfuri[i];

        double det1 = det(frontiera[frontiera.size() - 2].first, frontiera[frontiera.size() - 2].second,
                          frontiera[frontiera.size() - 1].first, frontiera[frontiera.size() - 1].second,
                          p.first, p.second);

        double det2 = det(p.first, p.second,
                          frontiera[0].first, frontiera[0].second,
                          frontiera[1].first, frontiera[1].second);

        // daca p este punct interior poligonului determinat pana in acest moment, ignor punctul  
        // (nu va face parte din frontiera)                
        if (det1 > 0 && det2 > 0)
            continue;

        // cat timp nu am viraj la stanga cand iau din varf (back), elimin
        while (det(frontiera[frontiera.size()-2].first, frontiera[frontiera.size()-2].second,
                   frontiera[frontiera.size()-1].first, frontiera[frontiera.size()-1].second,
                   p.first, p.second) <= 0 && frontiera.size() >= 3)
            frontiera.pop_back();
        frontiera.push_back(p);

        // cat timp nu am viraj la stanga cand iau din coada (top), elimin
        while (det(p.first, p.second,
                   frontiera[0].first, frontiera[0].second,
                   frontiera[1].first, frontiera[1].second) <= 0 && frontiera.size() >= 3)
            frontiera.pop_front();
        frontiera.push_front(p);
    }
    return frontiera;
}

int main(){

    int nr_puncte, i;
    fin >> nr_puncte;
    vector<pair<double,  double>> poligon(nr_puncte);

    for(i = 0; i < nr_puncte; i++){
        fin >> poligon[i].first >> poligon[i].second;
    }

    deque<pair< double,  double>> hull = determina_frontiera(poligon);

    cout << hull.size() - 1 << "\n";
    for(i = 0; i < (int)hull.size() - 1; i++){
        cout << setprecision(10);
        cout << hull[i].first << " " << hull[i].second << "\n";
    }
        
    // cout << det(0, 10000, 1, 9999, 10000, 0);
    return 0;
}