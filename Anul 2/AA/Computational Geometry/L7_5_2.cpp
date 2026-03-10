#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <algorithm>
#include <iomanip>
#include <iterator>

using namespace std;

struct punct{
    double x, y;

    int segment; // indicele segmentului
    bool is_vertical; // tin minte daca e vertical sau nu
    punct() {}
    punct(double x_, double y_, int segment_, bool is_vertical_) :
        x(x_), y(y_), segment(segment_), is_vertical(is_vertical_){}
    bool operator==(punct pt){ 
        return x == pt.x && y == pt.y;
    }
};

bool comp(punct p1, punct p2){
    return p1.y > p2.y || (p1.y == p2.y && p1.x < p2.x); 
}

bool comp2(punct p1, punct p2){
    return p1.x < p2.x || (p1.x == p2.x && p1.y < p2.y);
}


int main(){
    ifstream fin("input.txt");

    int n, i;
    double x1, y1, x2, y2;
    vector<punct> puncte;
    vector<int> segmente_statut;
    set<double> statut;
    int nr_intersectii = 0;

    fin >> n;
    for(i = 0; i < n; i++){
        bool ok = false;
        fin >> x1 >> y1 >> x2 >> y2; 
        // verific daca este segment vertical <-> x1 == x2
        if(x1 == x2){
            ok = true;
        }
        punct P1(x1, y1, (i+1), ok);
        punct P2(x2, y2, (i+1), ok);

        puncte.push_back(P1);
        puncte.push_back(P2);
    }


    sort(puncte.begin(), puncte.end(), comp2);
    bool citit_capat_jos=false;
    punct capat_jos, capat_sus;

    for(auto pt : puncte){
        if(!pt.is_vertical){
            auto it = find(segmente_statut.begin(), segmente_statut.end(), pt.segment);
            auto it2 = find(statut.begin(), statut.end(), pt.y);
            if(it != segmente_statut.end()){
                segmente_statut.erase(it);
                statut.erase(it2);
            }
            else{
                statut.insert(pt.y);
                segmente_statut.push_back(pt.segment);
            }
        }
        else{

            if(!citit_capat_jos){
                capat_jos = pt;
                citit_capat_jos = true;
            }
            else{
                capat_sus = pt;
                citit_capat_jos = false;        
                auto it_l = statut.lower_bound(capat_jos.y);
                auto it_r = statut.upper_bound(capat_sus.y);
                int cnt = distance(it_l, it_r);
                nr_intersectii += cnt;
            }
        }
    }
     
    cout << nr_intersectii << endl;
    return 0;
}