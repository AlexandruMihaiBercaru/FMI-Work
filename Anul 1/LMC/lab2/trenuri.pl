directTrain(saarbruecken,dudweiler).
directTrain(forbach,saarbruecken).
directTrain(freyming,forbach).
directTrain(stAvold,freyming).
directTrain(fahlquemont,stAvold).
directTrain(metz,fahlquemont).
directTrain(nancy,metz).

travelFromTo(A, B) :- directTrain(A, B).
travelFromTo(A, B) :-
    directTrain(A, C),
    travelFromTo(C, B).


