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
    ifstream fin("input.txt");
    punct A, B, C, P;
    int n;
    cin >> A.x >> A.y >> B.x >> B.y >> C.x >> C.y;
    cin >> n;
    for(int i = 0; i < n; i++){
        cin >> P.x >> P.y;
        double det = Geom::four_det(A, B, C, P);
        if(det == 0)
            cout << "BOUNDARY\n";
        else{
            if(det > 0)
                cout << "INSIDE\n";
            else
                cout << "OUTSIDE\n";
        }
    }
    return 0;
}