#include <iostream>
#include <fstream>

using namespace std;
//ifstream fin("input.txt");

/*
3
1 1 5 3 2 3
1 1 5 3 4 1
1 1 5 3 3 2
*/

double det(double xp, double yp, double xq, 
    double yq, double xr, double yr){
    return (xq - xp) * (yr - yp) - (yq - yp) * (xr - xp);
}

int main(){

    ifstream fin("input.txt");
    int number_of_tests;
    double x1, y1, x2, y2, x3, y3;
    fin >> number_of_tests;

    for(int i = 0; i < number_of_tests; i++){
        fin >> x1 >> y1 >> x2 >> y2 >> x3 >> y3;
        double D = det(x1, y1, x2, y2, x3, y3);
        if(D > 0)
            cout << "LEFT" << endl;
        else if (D < 0)
            cout << "RIGHT" << endl;
        else
            cout << "TOUCH" << endl;
    }
    return 0;
}
