/* Definiti un predicat listaNelem/3 astfel incat, pentru orice L, N, M, listaNelem(L,N,M) este adevarat exact atunci cand M este o lista cu N elemente care sunt toate elemente ale lui L (cu eventuale repetitii). */

listaNelem(_, 0, []).
listaNelem(L, N, [H|T]) :-
    N>0,
    P is N-1,
    member(H, L),
    listaNelem(L, P, T).

listaNelem(L,N,LL) :- bagof(M, listaNelem(L,N,M), LL).


