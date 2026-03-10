#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <iomanip>

using namespace std;

struct punct{
    double x, y;
    punct() {}
    punct(double x_, double y_) : x(x_), y(y_) {}
    bool operator==(punct pt){ 
        return x == pt.x && y == pt.y;
    }
};

double findClosestBound(vector<double> coords, double pt_coord, bool asc){

    int poz = 0;
    int n = coords.size();
    if(asc){
        while(poz < n && coords[poz] < pt_coord )
            poz++;
    }
    else{
        while(poz < n && coords[poz] > pt_coord)
            poz++;
    }
    if(poz == 0) return coords[0];
    return coords[poz-1];
}

int main(){
    ifstream fin("input.txt");
    bool ok = true;
    int n, a, b, c, m, i;
    double val, aria;
    punct Q;
    vector<double> x_inf, x_sup, y_inf, y_sup;
    
    cin >> n;
    for (i = 0; i < n; i++){
        cin >> a >> b >> c;  // ax + by + c <= 0
        if(b == 0) // a!=0, ax + c <= 0 => aduc la forma x ? -c/a
        { 
            val = (-1.0) * c / a;
            if(a > 0)
                x_sup.push_back(val);
            else
                x_inf.push_back(val);  
        }
        else // b!=0, bx + c <= 0 => aduc la forma y ? -c/b
        {
            val = (-1.0) * c / b;
            if(b > 0)
                y_sup.push_back(val);
            else
                y_inf.push_back(val);
        }
    }
    //verific daca am cel putin un semiplan in fiecare directie
    if(x_sup.size() == 0 || x_inf.size() == 0 || y_sup.size() == 0 || y_inf.size() == 0){
        ok = false;
    }
    else{
        sort(x_sup.begin(), x_sup.end(), greater<double>());
        sort(x_inf.begin(), x_inf.end());
        sort(y_sup.begin(), y_sup.end(), greater<double>());
        sort(y_inf.begin(), y_inf.end());
    }
    cin >> m;
    for(i = 0; i < m; i++){
        if(!ok){
            cout << "NO\n";
            continue;
        }
        cin >> Q.x >> Q.y;
        if(x_inf[0] < Q.x && Q.x < x_sup[0] && y_inf[0] < Q.y && Q.y < y_sup[0]){

            cout << "YES\n";
            double y1 = findClosestBound(y_inf, Q.y, true), 
                   y2 = findClosestBound(y_sup, Q.y, false),
                   x1 = findClosestBound(x_inf, Q.x, true),
                   x2 = findClosestBound(x_sup, Q.x, false);
            aria = abs(y2 - y1) * abs(x2 - x1);

            cout << fixed;
            cout << setprecision(6) << aria << endl;

        }
        else{
            cout << "NO\n";
        }
    }
    return 0;
}