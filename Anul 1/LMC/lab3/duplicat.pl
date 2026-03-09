/*Definiti un predicat remove_duplicates/2 care sterge toate duplicatele
din lista data ca prim argument si intoarce rezultatul in al doilea
argument.*/

remove_duplicates([], []).

remove_duplicates([H|T], [H|L]) :-
    remove_duplicates(T, L),
    not(member(H, L)).

remove_duplicates([H|T], L) :-
    remove_duplicates(T, L),
    member(H, L).


