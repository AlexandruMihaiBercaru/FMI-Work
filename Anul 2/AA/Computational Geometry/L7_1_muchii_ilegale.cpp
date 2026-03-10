#include <iostream>
#include <fstream>

using namespace std;

struct punct{
    double x, y;
    punct() {}
    punct(double x_, double y_) : x(x_), y(y_) {}
    bool operator==(punct pt){ 
        return x == pt.x && y == pt.y;
    }
};

class Geom
{
    public:
    static double three_det(const punct& p1, const punct& p2, const punct& p3){
        return (p2.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (p2.y - p1.y);
    }

    static double three_det(double a, double b, double c,
                            double d, double e, double f,
                            double g, double h, double i)
    {
        return a * e * i + d * h * c + b * f * g 
             - c * e * g - b * d * i - a * f * h; 
    }

    static double four_det(const punct& A, const punct& B, const punct& C, const punct& D){
        return three_det(A.x - D.x, A.y - D.y, (A.x - D.x) * (A.x + D.x) + (A.y - D.y) * (A.y + D.y),
                         B.x - D.x, B.y - D.y, (B.x - D.x) * (B.x + D.x) + (B.y - D.y) * (B.y + D.y),
                         C.x - D.x, C.y - D.y, (C.x - D.x) * (C.x + D.x) + (C.y - D.y) * (C.y + D.y));
    }
};


int main(){
    punct A, B, C, D;
    ifstream fin("input.txt");

    fin >> A.x >> A.y >> B.x >> B.y >> C.x >> C.y >> D.x >> D.y;

    double det1 = Geom::four_det(A, B, C, D);
    double det2 = Geom::four_det(B, C, D, A);

    if(det1 > 0)
        cout << "AC: ILLEGAL\n";
    else
        cout << "AC: LEGAL\n";
    
    if(det2 > 0)
        cout << "BD: ILLEGAL\n";
    else
        cout << "BD: LEGAL\n";


    return 0;
}