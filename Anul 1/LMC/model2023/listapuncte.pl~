
/*Definiti un predicat lista_puncte/3 care, pentru o lista L formata din puncte reprezentate sub forma punct(coordX, coordY) si un numar Val, calculeaza lista acelor puncte din L care au a doua coordonata mai mare decat Val */

lista_puncte([], _, []).
lista_puncte([punct(X, Y)|T], Val, [punct(X, Y)|L]) :-
    Y > Val,
    lista_puncte(T, Val, L).
lista_puncte([punct(_, Y)|T], Val, L) :-
    Val >= Y,
    lista_puncte(T, Val, L).




/*Definiti un predicat dropN/3, astfel incat, pentru orice liste L, R ¸si numar natural N, dropN(L, R, N) este adevarat daca si numai daca R este lista care
rezulta din eliminarea ultimelor N elemente ale lui L. Predicatul va fi fals in cazul in care N este mai mare decat lungimea lui L*/

dropreverse(AR, A, 0) :- reverse(A, AR).
dropreverse([_|T], R, N):-
    N>0,
    N1 is N-1,
    dropreverse(T, R, N1).

dropN(L, R, N) :- dropreverse(LRev, R, N), reverse(L, LRev).

%dropN(L, R, N) :- append(R, L1, L), length(L1, N).



/* Consideram in continuare reprezentarea formulelor logicii propozitionale folosita in laboratorul 5. Scrieti un predicat rmdn/2 cu proprietatea ca rmdn(Phi,
Psi) este adevarat daca si numai daca Psi este rezultatul eliminarii
tuturor negatiilor duble din Phi.*/


rmdn(Phi, Phi) :- atom(Phi).
rmdn(non(Phi), non(Phi)) :- atom(Phi).
rmdn(non(non(Phi)), Psi) :- rmdn(Phi, Psi).
rmdn(non(si(Phi,Psi)),non(A)) :- rmdn(si(Phi,Psi),A).
rmdn(non(sau(Phi,Psi)),non(A)) :- rmdn(sau(Phi,Psi),A).
rmdn(non(imp(Phi,Psi)),non(A)) :- rmdn(imp(Phi,Psi),A).
rmdn(si(Phi, Psi), si(Phi1, Psi1)) :- rmdn(Phi, Phi1), rmdn(Psi, Psi1).
rmdn(sau(Phi, Psi), sau(Phi1, Psi1)) :- rmdn(Phi, Phi1), rmdn(Psi, Psi1).
rmdn(imp(Phi, Psi), imp(Phi1, Psi1)) :- rmdn(Phi, Phi1), rmdn(Psi, Psi1).


