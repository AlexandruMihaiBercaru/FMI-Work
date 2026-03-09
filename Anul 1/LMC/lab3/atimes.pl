/*Definiti un predicat atimes/3 care sa fie adevarat exact atunci cand
elementul din primul argument apare in lista din al doilea argument de
numarul de ori precizat in al treilea argument.*/

atimes(_, [], 0).
atimes(Nr, [Nr|T], XTimes) :-
    atimes(Nr, T, XTimes2),
    XTimes is XTimes2+1.
atimes(Nr, [H|T], XTimes) :-
    atimes(Nr, T, XTimes),
    H \= Nr.



