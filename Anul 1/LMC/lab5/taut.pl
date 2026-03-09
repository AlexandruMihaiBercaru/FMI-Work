vars(X, [X]) :-
    atom(X).
vars(imp(T1, T2), Res) :-
    vars(T1, Res1),
    vars(T2, Res2),
    union(Res1, Res2, Res).
vars(non(T), Res) :-
    vars(T, Res).
vars(si(T1, T2), Res) :-
    vars(T1, Res1),
    vars(T2, Res2),
    union(Res1, Res2, Res).
vars(sau(T1, T2), Res) :-
    vars(T1, Res1),
    vars(T2, Res2),
    union(Res1, Res2, Res).

val(Atom, [(Atom, Val)|_], Val).
val(Atom, [_|T], Res) :-
    val(Atom, T, Res).

bnon(0, 1).
bnon(1, 0).
bimp(0, _, 1).
bimp(1, 0, 0).
bimp(1, 1, 1).

bsau(P, Q, Res) :-
    bnon(P, NonP),
    bimp(NonP, Q, Res).

bsi(P, Q, Res) :-
    bnon(P, NonP),
    bnon(Q, NonQ),
    bsau(NonP, NonQ, NonP_V_NonQ),
    bnon(NonP_V_NonQ, Res).

eval(Atom, ListAtoms, Eval) :-
    val(Atom, ListAtoms, Eval).
eval(imp(T1, T2), ListAtoms, Eval) :-
    eval(T1, ListAtoms, EvalT1),
    eval(T2, ListAtoms, EvalT2),
    bimp(EvalT1, EvalT2, Eval).
eval(si(T1, T2), ListAtoms, Eval) :-
    eval(T1, ListAtoms, EvalT1),
    eval(T2, ListAtoms, EvalT2),
    bsi(EvalT1, EvalT2, Eval).
eval(sau(T1, T2), ListAtoms, Eval) :-
    eval(T1, ListAtoms, EvalT1),
    eval(T2, ListAtoms, EvalT2),
    bsau(EvalT1, EvalT2, Eval).
eval(non(T), ListAtoms, Eval) :-
    eval(T, ListAtoms, EvalT),
    bnon(EvalT, Eval).

evals(_, [], []).
evals(Form, [H|T], [HRes|TRes]) :-
    eval(Form, H, HRes),
    evals(Form, T, TRes).

cartesian_product([],_,[_],[]).
cartesian_product([],L,[_|T2],Result) :-
    cartesian_product(L,L,T2,Result).
cartesian_product([H1|T1],L1,[H2|T2],[HRes|TRes]) :-
    append(H1, H2, HRes),
    cartesian_product(T1, L1, [H2|T2], TRes).

zip([],[],[]).
zip([H1|T1],[H2|T2],[(H1,H2)|TRes]) :-
    zip(T1, T2, TRes).

repl([_], [[0],[1]]).
repl([_|T], Res) :-
    repl(T, TempRes),
    cartesian_product(TempRes, TempRes, [[0],[1]], Res).

aux(_, [], []).
aux(ListAtoms, [H|T], [HRes|TRes]) :-
    zip(ListAtoms, H, HRes),
    aux(ListAtoms, T, TRes).

evs(ListAtoms, Res) :-
    repl(ListAtoms, AllEvals),
    aux(ListAtoms, AllEvals, Res).

all_evals(Form, Res) :-
    vars(Form, ListVars),
    evs(ListVars, Evals),
    evals(Form, Evals, Res).


all([],_).
all([H|T], X) :-
    H == X,
    all(T, X).

taut(Form) :-
    all_evals(Form, Evals),
    all(Evals, 1).
