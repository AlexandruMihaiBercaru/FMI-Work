connected(1,2).
connected(3,4).
connected(5,6).
connected(7,8).
connected(9,10).
connected(12,13).
/*Faptele indica ce puncte sunt conectate (din ce punct se poate ajunge
intr-un alt punct intr-un pas). Drumurile sunt cu sens unic. Adaugati un
predicat path/3 care indica daca dintr-un punct se poate ajunge intr-un
alt punct, in mai multi pasi, cel de-al treilea argument reprezentand
lista pasilor. Pe baza lui, construiti un predicat pathc/2 care spune
doar daca dintr-un punct se poate ajunge intr-un alt punct.
*/


connected(13,14).
connected(15,16).
connected(17,18).
connected(19,20).
connected(4,1).
connected(6,3).
connected(4,7).
connected(6,11).
connected(14,9).
connected(11,15).
connected(16,12).
connected(14,17).
connected(16,19).


path(X, X, [X]).
path(A, B, [A|L]) :-
    connected(A, C),
    path(C, B, L).


pathc(X, Y) :- path(X, Y, _).

