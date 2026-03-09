word(abalone,a,b,a,l,o,n,e).
word(abandon,a,b,a,n,d,o,n).
word(anagram,a,n,a,g,r,a,m).
word(connect,c,o,n,n,e,c,t).
word(elegant,e,l,e,g,a,n,t).
word(enhance,e,n,h,a,n,c,e).

crosswd(V1, V2, V3, H1, H2, H3) :-
    word(V1,_,L22,_,L42,_,L62,_),
    word(V2,_,L24,_,L44,_,L64,_),
    word(V3,_,L26,_,L46,_,L66,_),
    word(H1,_,L22,_,L24,_,L26,_),
    word(H2,_,L42,_,L44,_,L46,_),
    word(H3,_,L62,_,L64,_,L66,_).


