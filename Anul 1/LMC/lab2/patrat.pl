
%afisez o linie de stelute

line(0, _).
line(N, Char) :-
    N>0, M is N-1,
    write(Char),
    line(M, Char).

%afisez un dreptunghi

rectangle(0, _, _) :- nl.
rectangle(X, Z, Char) :-
    X>0,
    Y is X-1,
    line(Z, Char),
    nl,
    rectangle(Y, Z, Char).

%afisez un patrat

square(X, Char) :- rectangle(X, X, Char).



