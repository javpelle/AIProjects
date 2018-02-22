objetivo(Estado(_,3,_)).
objetivo(Estado(_,8,_)).
objetivo(Estado(3,_,_)).
objetivo(Estado(4,_,_)).

consulta() :- puede(Estado(7,11,0), objetivo,[inicial], [giraSiete, giraOnce, caer]).

puede(Estado, Estado,_, []).
puede(EstadoX, EstadoY, Visitados, [Operador|Operadores]) :-
	movimiento(EstadoX, Estadoi, Operador),
	\+ member(Estadoi, Visitados), puede(Estadoi, EstadoY, [Estadoi|Visitados], Operadores).
	
movimiento(EstadoX(X1,Y1,T), Estadoi(X2,Y2,T), giraSiete) :- is X2 (7 - X1), is Y2 Y1.
movimiento(EstadoX(X1,Y1,T), Estadoi(X2,Y2,T), giraOnce) :- is X2 X1, is Y2 (11 - Y1).
movimiento(EstadoX(X1,Y1,T1), Estadoi(X2,Y2,T2), caer) :- (7 - X1) >= (11 - X2), Y2 is 11, Y1 is (11 - X2 + X1), T2 is (T1 + 11 - X2).
movimiento(EstadoX(X1,Y1,T1), Estadoi(X2,Y2,T2), caer) :- (7 - X1) < (11 - X2), Y1 is 7,Y2 is (7 - X1 + X2), T2 is (T1 + 7 - X1).