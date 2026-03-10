#include <iostream>
#include <fstream>
#include <vector>
#include <iomanip>

using namespace std;
ifstream fin("input.txt");


double det( double xp,  double yp,  double xq, 
     double yq,  double xr,  double yr){
    return (xq - xp) * (yr - yp) - (yq - yp) * (xr - xp);
}

int main(){

    int nr_puncte, i, k, sz;
    double d;
    fin >> nr_puncte;
    vector<pair<double,  double>> poligon(nr_puncte), frontiera;

    for(i = 0; i < nr_puncte; i++){
        fin >> poligon[i].first >> poligon[i].second;
    }
    frontiera.push_back(poligon[0]);
    frontiera.push_back(poligon[1]);

    k = 2;
    while (k < nr_puncte){
        
        frontiera.push_back(poligon[k]);
        sz = frontiera.size();
        while(sz >= 3){
            d = det(frontiera[sz-3].first, frontiera[sz-3].second,
                frontiera[sz-2].first, frontiera[sz-2].second, 
                frontiera[sz-1].first, frontiera[sz-1].second);

            if(d > 0)
                break;

            frontiera.erase(frontiera.begin() + (sz-2));
            sz--;
        }

        while(sz >= 3){
            d = det(frontiera[sz-2].first, frontiera[sz-2].second,
            frontiera[sz-1].first, frontiera[sz-1].second, 
            frontiera[0].first, frontiera[0].second);

            if(d > 0)
                break;

            frontiera.erase(frontiera.begin() + (sz-1));
            sz--;
        }
        k++;
    }

    if(det(frontiera[frontiera.size()-1].first, frontiera[frontiera.size()-1].second,
                   frontiera[0].first, frontiera[0].second,
                   frontiera[1].first, frontiera[1].second) <= 0)
    {
        frontiera.erase(frontiera.begin());
        sz--;
    }


    cout << sz << endl;

    for(i = 0 ; i < sz; i ++){
        cout << setprecision(10);
        cout << frontiera[i].first << " " << frontiera[i].second << "\n";
    }

    return 0;
}

