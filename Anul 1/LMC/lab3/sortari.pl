
%InsertionSort
/* Predicatul insertsort/2 sorteaz¢ lista de pe primul argument folosind algoritmul insertion sort. Scrieti regulile care definesc comportamentul predicatului ajutator insert/3. */


insertsort([],[]).
insertsort([H|T],L) :- insertsort(T,L1), insert(H,L1,L).

insert(X, [], [X]).
insert(X, [H|T], [X|[H|T]]) :- X<H.
insert(X, [H|T], [H|L]) :-
    X >= H,
    insert(X, T, L).


%Quicksort
/* Predicatul quicksort/2 sorteaz¢a lista de pe primul argument folosind
algoritmul quicksort. Scrieti regulile care definesc comportamentul
predicatului ajutator split/4. */


quicksort([],[]).
quicksort([H|T],L) :-
    split(H,T,A,B),
    quicksort(A,M),
    quicksort(B,N),
    append(M,[H|N],L).

split(_, [], [], []).
split(X, [H|T], [H|A], B) :-
    H<X,
    split(X, T, A, B).
split(X, [H|T], A, [H|B]) :-
    H>=X,
    split(X, T, A, B).



