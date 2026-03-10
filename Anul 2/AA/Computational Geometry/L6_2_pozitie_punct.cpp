#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>

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

};

int sign(double x) {return x == 0 ? 0 : (x > 0 ? 1 : -1);}

Position poz_punct(vector<punct>& poligon, int n, const punct& q){
    bool succes;
    punct reper(1e9, q.y);
    int nr_intersectii;
    do{
        succes = true;
        nr_intersectii = 0;
        for(int i = 0; i < n; i++){
            punct p1 = poligon[i], p2 = poligon[(i+1)%n];
            
            if(Geom::on_segment(reper, p1, q) || Geom::on_segment(reper, p2, q) || Geom::det(reper, p1, p2) == 0){
                succes = false;
                break;
            }

            double det1 = Geom::det(p1, p2, q),
                   det2 = Geom::det(p1, p2, reper),
                   det3 = Geom::det(q, reper, p1),
                   det4 = Geom::det(q, reper, p2);
            
            if((sign(det1) != sign(det2)) && (sign(det3) != sign(det4)))
                nr_intersectii++;

            if(Geom::on_segment(p1, q, p2))
                return BOUNDARY;
                    
        }
        if(!succes){
            reper.x-= 10000; reper.y-= 1000;
        }
    }while(!succes);

    if(nr_intersectii % 2)
        return INSIDE;
    else return OUTSIDE;
}

int main(){

    ifstream fin("input.txt");
    int n, m, i;
    vector<string> pozitii = {"INSIDE", "OUTSIDE", "BOUNDARY"}; 
    fin >> n;
    vector<punct> poligon(n);

    for(i = 0; i < n; i++){
        fin >> poligon[i].x >> poligon[i].y;
    }
    punct pct;
    fin >> m;
    for (i = 0; i < m; i++)
    {
        fin >> pct.x >> pct.y;
        int p = poz_punct(poligon, n, pct);
        cout << pozitii[p] << "\n";
    }
    return 0;
}