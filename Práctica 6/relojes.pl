% Representación de los estados del problema:
% estado(minutosParteArribaSiete, minutosParteArribaOnce)
% donde minutosParteArribaSiete es la cantidad de arena en minutos en la parte de arriba del reloj de 7.
%       minutosParteArribaOnce  es la cantidad de arena en minutos en la parte de arriba del reloj de 11.

% Estados Objetivo. Se considera que haya 3 minutos en cualquiera de las dos partes de cualquiera de los dos relojes.
objetivo(estado(_,3)).
objetivo(estado(_,8)).
objetivo(estado(3,_)).
objetivo(estado(4,_)).

% Estado inicial. Toda la arena en las partes de abajo de ambos relojes.
inicial(estado(0,0)).

% Definicion de posibles operadores.
movimiento(estado(X1,Y), estado(X2,Y), giraSiete, 0) :- X2 is (7 - X1).
movimiento(estado(X,Y1), estado(X,Y2), giraOnce, 0) :- Y2 is (11 - Y1).
movimiento(estado(X1,Y1), estado(X2,Y2), caer, Y1) :- X1 > Y1, Y2 is 0, X2 is (X1 - Y1).
movimiento(estado(X1,Y1), estado(X2,Y2), caer, X1) :- X1 < Y1, X2 is 0, Y2 is (Y1 - X1).
movimiento(estado(X1,Y1), estado(X2,Y2), caer, X1) :- X1 is Y1, X2 is 0,Y2 is 0.

% Busqueda de la secuencia de operadores.
puede(Estado,_, [],0) :- objetivo(Estado).
puede(Estado, Visitados, [Operador|Operadores], T) :-
	movimiento(Estado, Estado2, Operador, T2),
	\+ member(Estado2, Visitados),
	puede(Estado2, [Estado2|Visitados], Operadores, T1),
	T is (T1 + T2).
	
% Consulta e impresion de los resultados.	
consulta() :- inicial(Estado),puede(Estado,[Estado], Operadores, Tiempo),
write('SOLUCION ENCONTRADA sin repeticion de estados: '), nl, write(Operadores), nl,
write('TIEMPO DE LA SOLUCION: '), write(Tiempo), write(' MINUTOS.').