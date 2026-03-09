
/*Definiti un predicat palindrome/1 care este adevarat daca lista primita
ca argument este palindrom (lista citita de la stanga la dreapta este
identica cu lista citita de la dreapta la stanga).*/

/*Nu folositi predicatul predefinit reverse, ci propria implementare a
acestui predicat.*/

rev([], []).
rev([H|T], L) :-
    rev(T, L1),
    append(L1, [H], L).

palindrome(L) :- rev(L, L).


