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


int main(){
    ifstream fin("input.txt");
    int n, a, b, c;
    double x_lte = 1e9, x_gte = -1e9, y_lte = 1e9, y_gte = -1e9, val;

    fin >> n;
    for(int i = 0; i < n; i++){
        fin >> a >> b >> c;  // ax + by + c <= 0
        if(b == 0) // a!=0, ax + c <= 0 => aduc la forma x ? -c/a
        { 
            val = (-1) * c / a;
            if(a > 0){
                if(val < x_lte)
                    x_lte = val;
            }
            else{
                if(val > x_gte)
                    x_gte = val;
            }
               
        }
        else // b!=0, bx + c <= 0 => aduc la forma y ? -c/b
        {
            val = (-1) * c / b;
            if(b > 0){
                if(val < y_lte)
                    y_lte = val;
            }
            else{
                if(val > y_gte)
                    y_gte = val;
            }
        }
    }

    if(y_lte < y_gte || x_lte < x_gte)
        cout << "VOID";
    else
        if(x_lte != -1e9 && y_lte != -1e9 && y_gte != -1e9 && x_gte != -1e9)
            cout << "BOUNDED";
        else
            cout << "UNBOUNDED";
    
    return 0;
}

