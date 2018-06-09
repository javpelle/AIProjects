% hechos:
transformar(personas(sujeto(P,_), _), 1, P).
transformar(personas(_, subordinada(P1,_), 2, P1)).
transformar(_, 3, 3).


% queremos que la lista de palabras queda separada como un conjunto de palabras

unaPalabra(":", ":"):-!. 
unaPalabra("\"", "\""):-!. 
unaPalabra("¿", "¿"):-!. 
unaPalabra("?", "?"):-!. 
unaPalabra(String, Atomico) :- atom_string(Atomico, String). 

% si la frase entrada es vacía, entonces, hemos terminado
% en otros casos, escribimos la frase original por la pantalla, 
% hacemos el cambio y escribimos la frase cambiada por la pantalla.

cambiar([]):- write('Gracias por su uso.'),nl.
cambiar(Frase):- write(Frase), nl, frase(X, Frase, []), !,
				 maplist(atom_string, X, Y), 
				 atomic_list_concat(Y, " ", FraseFinal), 
				 write(FraseFinal), nl, convertir.
				 


% cambiar pronombres reflexivos: me, te, se, nos, os, se
% en persona guardamos informaciones relacionadas con persona en sujeto
% y en complemento indirecto

cambiarPalabra(Personas, PRdirecto, PRindirecto):-
	esPronRef(Pdirecto, Persona, Numero), 
	esPronRef(Pindirecto, PersonaInd, Numero)
	transformar(Personas, Persona, PersonaInd).
	
% cambiar los verbos de la frase subordinada

cambiarPalabra(Personas, Vdirecto, Vindirecto) :-
	esVerbo(Vdirecto,Infinitivo, Persona, Numero, presente),
	esVerbo(Vindirecto, Infinitivo, PersonaInd, Numero, pasado),
	transformar(Personas, Persona, PersonaInd).
	
% cambiar los pronombres posesivos: mi, tu, su, etc.

cambiarPalabra(Personas, PPdirecto, PPindirecto):-
	esPronPose(PPdirecto, Persona, Numero), 
	esPronPose(PPindirecto, PersonaIndirecto, Numero), 
	transformar(Personas, Persona, PersonaIndirecto).

% cambiar verbo infinitivo junto con un pronombre, por ejemplo, verte

cambiarPalabra(Personas, VPdirecto, VPindirecto):-
	esVerbo(Verbo, _ , _ , _  , _), 
	esPronRef(Pronombre, Persona, Numero), 
	atom_concat(Verbo, Pronombre, VPdirecto),
	esPronRef(ProIndirecto, PersonaIndirecto, Numero),
	atom_concat(Verbo, ProIndirecto, VPindirecto), 
	transformar(Personas, Persona, PersonaIndirecto).

% cambiar articulos como: este, esta, aquellos,etc

cambiarPalabra(Personas, Adirecto, Aindirecto):-
	esArticulo(Adirecto, Genero, Numero, cerca),
	esArticulo(Aindirecto, Genero, Numero, lejos).
	
% cambiar palabras de otros tipos

cambiarPalabra(_, Var, Var):- 
	not(esVerbo(Var,_,_,_,_)), 
	not(esPronRef(Var,_,_)),
	not(esPronPose(Var,_ ,_)).
	

convertir:-  
 	write('Escribe la frase que quieres convertir entre comillas. '), nl,  
 	write('Por ejemplo: "María me dijo : \" juan es mi amigo \"".'), nl,
	write('o : "María me dijo que Juan era su amigo".')
 	write('o la frase vacía "". para terminar.'), nl, 
 	read(FrasePedida), 
 	split_string(FrasePedida, " ", "", StringList), 
 	maplist(unaPalabra, StringList, Frase), 
 	cambiar(Frase). 
