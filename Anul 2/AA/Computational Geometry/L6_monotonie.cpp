#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>

using namespace std;

struct punct{
    double x, y;
    punct() {}
    punct(double x_, double y_) : x(x_), y(y_) {}
    bool operator==(punct pt){ 
        return x == pt.x && y == pt.y;
    }
};

bool test_x_monotonie(vector<punct>& poligon, int xmin, int xmax){
    bool is_monoton = true;
    int k = 0, pct_lant_inf, pct_lant_sup, n = poligon.size();
    pct_lant_inf = xmin > xmax ? n - (xmin - xmax) : xmax - xmin;
    pct_lant_sup = xmin > xmax ? xmin - xmax : n - (xmax - xmin);

    /* 
        parcurg lanturile superior si inferior (verific daca se respecta x-monotonia)
        xmin -> xmax cu indici crescatori (parcurgerea vectorului spre dreapta) este lantul inferior
        xmin -> xmax cu indici descrescatori (spre stanga) este lantul superior
    */
    while(k < pct_lant_inf){
        double a = poligon[(xmin+k+1) % n].x;
        double b = poligon[(xmin+k) % n].x;

        if(a < b){
            is_monoton = false;
            break;
        }
        k++;
    }
    if(!is_monoton)
        return false;

    k = 0;
    while(k < pct_lant_sup){
        if(poligon[(xmax+k+1) % n].x > poligon[(xmax+k) % n].x){
            is_monoton = false;
            break;
        }
        k++;
    }

    return is_monoton;
}

bool test_y_monotonie(vector<punct>& poligon, int ymin, int ymax){
    bool is_monoton = true;
    int k = 0,  pct_lant_stg, pct_lant_drp, n = poligon.size();
    pct_lant_drp = ymin > ymax ? n - (ymin - ymax) : ymax - ymin;
    pct_lant_stg = ymin > ymax ? ymin - ymax : n - (ymax - ymin);
    k = 0;
    while(k < pct_lant_stg){
        if(poligon[(ymax+k+1) % n].y > poligon[(ymax+k) % n].y){
            is_monoton = false;
            break;
        }
        k++;
    }
    if(!is_monoton)
        return false;

    k = 0;
    while(k < pct_lant_drp){
        if(poligon[(ymin+k+1) % n].y < poligon[(ymin+k) % n].y){
            is_monoton = false;
            break;
        }
        k++;
    }

    return is_monoton;
}


int main(){
    fstream fin("input.txt");
    int n, i; 
    cin >> n;
    vector<punct> poligon(n);

    punct NORD(0, -1e9), SUD(0, 1e9), EST(-1e9, 0), VEST(1e9, 0);
    int ymax, ymin, xmax, xmin;

    for(i = 0; i < n; i++){
        cin >> poligon[i].x >> poligon[i].y;
        if(poligon[i].x < VEST.x) VEST = poligon[i], xmin = i;
        if(poligon[i].x > EST.x) EST = poligon[i], xmax = i;
        if(poligon[i].y > NORD.y) NORD = poligon[i], ymax = i;
        if(poligon[i].y < SUD.y) SUD = poligon[i], ymin = i;
    }
    
    if(test_x_monotonie(poligon, xmin, xmax)) cout <<"YES\n";
        else cout << "NO\n";
    if(test_y_monotonie(poligon, ymin, ymax)) cout << "YES\n";
        else cout << "NO\n";
    return 0;
}