
fibo(0, 0, 1).
fibo(1, 1, 1).
fibo(N, Acc, X) :-
    N>=2,
    N1 is N-1,
    fibo(N1, Acc2, Acc),
    X is Acc+Acc2.

fib(N, X) :- fibo(N, _, X).





