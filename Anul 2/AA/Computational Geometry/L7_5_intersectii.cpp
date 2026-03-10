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


int main(){
    ifstream fin("input.txt");

    int n, i;
    double x1, y1, x2, y2;
    vector<punct> puncte;
    vector<int> segmente_statut;
    set<double> statut;
    int nr_intersectii = 0;

    cin >> n;
    for(i = 0; i < n; i++){
        bool ok = false;
        cin >> x1 >> y1 >> x2 >> y2; 
        // verific daca este segment vertical <-> x1 == x2
        if(x1 == x2)
            ok = true;

        punct P1(x1, y1, (i+1), ok);
        punct P2(x2, y2, (i+1), ok);

        puncte.push_back(P1);
        puncte.push_back(P2);
    }

    sort(puncte.begin(), puncte.end(), comp);

    bool citit_capat_stanga=false;
    punct capat_stanga, capat_dreapta;

    for(auto pt : puncte){
        // cout << "punctul: " << pt.x << " " << pt.y;
        if(pt.is_vertical){
            // verific daca segmentul nu se afla in statutul cu segmente
            // daca se afla, doar il elimin din statut
            auto it = find(segmente_statut.begin(), segmente_statut.end(), pt.segment);
            auto it2 = find(statut.begin(), statut.end(), pt.x);
            if(it != segmente_statut.end()){
                segmente_statut.erase(it);
                statut.erase(it2);
                // cout << "Am eliminat segmentul " << pt.segment << " din statut.\n";
            }
            else{
            // altfel, adaug in statut coordonata x a segmentului si in segmente_statut adaug indicele segmentului
                statut.insert(pt.x);
                segmente_statut.push_back(pt.segment);
                // cout << "Am adaugat segmentul " << pt.segment << " in statut.\n";
            }
        }
        else{
            // daca este segment orizontal, vad in statut cate elemente am 
            // intre capat_stanga si capat_dreapta, dar doar daca am citit si capat_dreapta

            if(!citit_capat_stanga){
                capat_stanga = pt;
                citit_capat_stanga = true;
            }
            else{
                capat_dreapta = pt;
                citit_capat_stanga = false;        
                auto it_l = statut.lower_bound(capat_stanga.x);
                auto it_r = statut.upper_bound(capat_dreapta.x);
                int cnt = distance(it_l, it_r);
                nr_intersectii += cnt;
                // cout << "s-au gasit " << cnt << "intersectii " << "intre " << capat_stanga.x << " si " << capat_dreapta.x<< ".\n";
            }
        }
    }
    cout << nr_intersectii << endl;
    return 0;
}