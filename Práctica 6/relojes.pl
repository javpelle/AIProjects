objetivo(estado(_,3,_)).
objetivo(estado(_,8,_)).
objetivo(estado(3,_,_)).
objetivo(estado(4,_,_)).

inicial(estado(7,11,0)).
	
movimiento(estado(X1,Y,T), estado(X2,Y,T), giraSiete) :- X2 is (7 - X1).
movimiento(estado(X,Y1,T), estado(X,Y2,T), giraOnce) :- Y2 is (11 - Y1).
movimiento(estado(X1,Y1,T1), estado(X2,Y2,T2), caer) :- X1 > Y1, Y2 is 0, X2 is (X1 - Y1), T2 is (T1 + Y1).
movimiento(estado(X1,Y1,T1), estado(X2,Y2,T2), caer) :- X1 < Y1, X2 is 0, Y2 is (Y1 - X1), T2 is (T1 + X1).
movimiento(estado(X1,Y1,T1), estado(X2,Y2,T2), caer) :- X1 is Y1, X2 is 0,Y2 is 0, T2 is (T1 + X1).

puede(Estado,_, []) :- objetivo(Estado).
puede(Estado, Visitados, [Operador|Operadores]) :-
	movimiento(Estado, Estado2, Operador),
	\+ member(Estado, Visitados),
	puede(Estado2, [Estado2|Visitados], Operadores).
	
consulta() :- inicial(Estado),puede(Estado,[Estado], Operadores), write(Operadores).