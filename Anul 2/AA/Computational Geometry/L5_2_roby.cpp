#include <iostream>
#include <fstream>
#include <vector>

using namespace std;
ifstream fin("input.txt");

/*
7
1 1
2 2
2 0
3 0
4 0
5 0
6 0
*/

double det(double xp, double yp, double xq, 
    double yq, double xr, double yr){
    return (xq - xp) * (yr - yp) - (yq - yp) * (xr - xp);
}

void check_turn(double det, int v[]){
    if (det > 0)
        v[0]++;
    else if (det < 0)
        v[1]++;
    else
        v[2]++;
}

int main(){

    int nr_puncte, i;
    fin >> nr_puncte;

    pair<double, double> p;
    vector<pair<double, double>> puncte;

    // viraje[0] = stanga, viraje[1] = dreapta, viraje[2] = linie
    
    int viraje[3] = {0, 0, 0};

    for(i = 0; i < nr_puncte; i++){
        fin >> p.first >> p.second;
        puncte.push_back(p);
    }

    // numarul total de viraje (sau puncte in care se continua pe aceeasi dreapta) = nr_puncte - 1

    for(i = 0; i < nr_puncte - 1; i++){
        double D;
        // daca suntem inainte de ultimul viraj:
        if(viraje[0] + viraje[1] + viraje[2] != nr_puncte - 2)
            D = det(puncte[i].first, puncte[i].second,
                    puncte[i+1].first, puncte[i+1].second,
                    puncte[i+2].first, puncte[i+2].second);
        else
            D = det(puncte[i].first, puncte[i].second,
                    puncte[i+1].first, puncte[i+1].second,
                    puncte[0].first, puncte[0].second);
        check_turn(D, viraje);
    }

    cout << viraje[0] << " " << viraje[1] << " " << viraje[2] << endl;

    return 0;
}