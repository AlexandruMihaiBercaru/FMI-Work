#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <math.h>
using namespace std;

enum Position{
    INSIDE, OUTSIDE, BOUNDARY
};

struct punct{
    double x, y;
    punct() {}
    punct(double x_, double y_) : x(x_), y(y_) {}
    bool operator==(punct pt){ 
        return x == pt.x && y == pt.y;
    }
};

class Geom{
    public:
    
    static double det(const punct& p1, const punct& p2, const punct& p3){
        return (p2.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (p2.y - p1.y);
    }

    static bool between(const punct& a, const punct& b, const punct& c) {
        return min(a.x, c.x) <= b.x && b.x <= max(a.x, c.x) &&
            min(a.y, c.y) <= b.y && b.y <= max(a.y, c.y);
    }

    static bool on_segment(const punct& a, const punct& b, const punct& c) {
        if(det(a, b, c) == 0)
            return between(a, b, c);
        return false;
    }

    static bool compara_puncte(punct& p1, punct& p2){
        return p1.x < p2.x || (p1.x == p2.x && p1.y < p2.y);
    }

    static Position verific_arii(punct& p0, punct& pi, punct& pi1, punct pt){
        // daca pt este in interior, determinantul va fi mereu pozitiv (doar viraje la stanga)
        double a1 = det(pt, p0, pi);
        double a2 = det(pt, pi, pi1);
        double a3 = det(pt, pi1, p0);

        if (a1 >= 0 && a2 >= 0 && a3 >= 0)
            return INSIDE;

        return OUTSIDE;
    }
};

int sign(double x) {return x == 0 ? 0 : (x > 0 ? 1 : -1);}

Position punctInPoligon(vector<punct>& poligon, int& n, punct& pt){
    
    if( Geom::det(poligon[0], poligon[1], pt) < 0)
        return OUTSIDE;
    
    if( Geom::det(poligon[0], poligon[n-1], pt) > 0)
        return OUTSIDE;

    // daca pt este pe dreapta determinata de p0 si p1,
    //verific ca punctul sa fie situat intre p0 si p1; daca se intampla asta => BOUNDARY
    if( Geom::on_segment(poligon[0], pt, poligon[1]) )
        return BOUNDARY;
    
    if (Geom::on_segment(poligon[0], pt, poligon[n-1]))
        return BOUNDARY;

    int l = 0, r = n - 1;
    while(r - l > 1){
        int mid = (l + r) / 2;
        // test de orientare pentru p0-pi-pt (i = mijlocul)
        // caut ultimul punct in care se face viraj la stanga in pi pentru a ajunge in pt
        if(Geom::det(poligon[0], poligon[mid], pt) >= 0)
            l = mid;
        else
            r = mid;
        if(Geom::on_segment(poligon[l], pt, poligon[l+1]))
            return BOUNDARY;
    }
    if(Geom::det(poligon[0], poligon[l], poligon[r]) == 0)
    {
        if( Geom::on_segment(poligon[0], pt, poligon[l]) || 
            Geom::on_segment(poligon[l], pt, poligon[r]))
            return BOUNDARY;
        else return OUTSIDE;
    }

    return Geom::verific_arii(poligon[0], poligon[l], poligon[l+1], pt);
}


int main(){
    ifstream fin("input.txt");
    int n, m, i, pos = 0;
    cin >> n;
    vector<punct> poligon(n);
    vector<string> pozitii = {"INSIDE", "OUTSIDE", "BOUNDARY"}; 

    for(i = 0; i < n; i++){
        cin >> poligon[i].x >> poligon[i].y;
        if(Geom::compara_puncte(poligon[i], poligon[pos]))
            pos = i;
    }
    n = poligon.size();

    rotate(poligon.begin(), poligon.begin() + pos, poligon.end());
    cin >> m;
    punct pct;
    for (i = 0; i < m; i++)
    {
        cin >> pct.x >> pct.y;
        int p = punctInPoligon(poligon, n, pct);
        cout << pozitii[p] << "\n";
    }
    return 0;
}
