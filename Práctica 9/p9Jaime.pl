% Convertidor de frases directas en indirectas y viceversa
% Jaime Sevilla 2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

consulta:- 
	write('Escribe frase entre comillas'), nl, 
	write('Ejemplo: "maría me dijo : \" juan es mi amigo \"".'), nl, 
	write('o "". para parar'), nl,
	read(Entrada),
	split_string(Entrada, " ", "", StringList),
	maplist(myString_atom, StringList, Frase),
	trata(Frase).

% tratamiento final
trata([]):- write('final'). 
% tratamiento caso general
trata(F):- 
	%print(F), nl,
	frase(Frase, F, []), !,
	maplist(atom_string, Frase, Aux),
	atomic_list_concat(Aux, " ", Salida),
	write(Salida), nl,
	consulta.


myString_atom("¿", "¿"):-!.
myString_atom("?", "?"):-!.
myString_atom("\"", "\""):-!.
myString_atom(":", ":"):-!.
myString_atom(String, Atom) :- atom_string(Atom, String).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TEST1: "maría me dijo : \" juan es mi amigo \"".
% TEST1: "maría me dijo que juan era su amigo".

% TEST2: "miguel me dijo : \" estoy contento de verte \"".
% TEST2: "miguel me dijo que estaba contento de verme".

% TEST3: "lucía me dijo : \" necesito un cambio en mi vida \"".
% TEST3: "lucía me dijo que necesitaba un cambio en su vida".

% TEST4: "luis me preguntó : \" ¿ estás ocupada esta noche ? \"".
% TEST4: "luis me preguntó que si estaba ocupada esa noche". --> WRONG

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCIONES AUXILIARES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TEST: transformarSubordinada([yo, verte, estoy], FraseIndirecta, contexto(sujeto(3, singular), ci(1, singular))).
% TEST: transformarSubordinada(FraseDirecta, [él, verme, estaba], contexto(sujeto(3, singular), ci(1, singular))).
% TEST: transformarSubordinada([juan, es, mi, amigo], FraseIndirecta, contexto(sujeto(3, singular), ci(1, singular))).
% TEST: transformarSubordinada(FraseDirecta, [juan, era, su, amigo], contexto(sujeto(3, singular), ci(1, singular))).
% TEST: transformarSubordinada([estoy,contento,de,verte], FraseIndirecta, contexto(sujeto(3, singular), ci(1, singular))).
% TEST: transformarSubordinada(FraseDirecta, [estaba, contento, de, verme], contexto(sujeto(3, singular), ci(1, singular))).

transformarSubordinada(Contexto, Directa, Indirecta):-
	maplist(transformarPalabra(Contexto), Directa, Indirecta).

% TEST: transformarPalabra(contexto(sujeto(3, singular), ci(1, singular)), verte, X).

% Pronombres
transformarPalabra(Contexto, PronombreDirecto, PronombreIndirecto):-
	esPronombrePersonal(PronombreDirecto, DPersona, Numero, Genero),
	esPronombrePersonal(PronombreIndirecto, IPersona, Numero, Genero),
	transformarPersona(Contexto, DPersona, IPersona).

% Verbo infinitivo + pronombre reflexivo
transformarPalabra(Contexto, CompuestaDirecta , CompuestaIndirecta):-
	esVerbo(_, Verbo, _, _, _, _),
	esPronombreComplementoIndirecto(PronombreD, DPersona, Numero),
	atom_concat(Verbo, PronombreD, CompuestaDirecta),
	esPronombreComplementoIndirecto(PronombreI, IPersona, Numero),
	atom_concat(Verbo, PronombreI, CompuestaIndirecta),
	transformarPersona(Contexto, DPersona, IPersona).

% Verbos
transformarPalabra(Contexto, VerboD, VerboI):-
	esVerbo(VerboD, Infinitivo, presente, DPersona, Numero, _),
	esVerbo(VerboI, Infinitivo, pasado, IPersona, Numero, _),
	transformarPersona(Contexto, DPersona, IPersona).

% Posesivos
transformarPalabra(Contexto, PosesivoD, PosesivoI):-
	esPosesivo(PosesivoD, DPersona, Numero, GeneroPoseido, NumeroPoseido),
	esPosesivo(PosesivoI, IPersona, Numero, GeneroPoseido, NumeroPoseido),
	transformarPersona(Contexto, DPersona, IPersona).

% Pronombres reflexivos
transformarPalabra(Contexto, PronombreD, PronombreI):-
	esPronombreReflexivo(PronombreD, DPersona, Numero),
	esPronombreReflexivo(PronombreI, IPersona, Numero),
	transformarPersona(Contexto, DPersona, IPersona).

% Demostrativos
transformarPalabra(_, DemostrativoD, DemostrativoI):-
	esDemostrativo(DemostrativoD, Persona, Numero, cercano),
	esDemostrativo(DemostrativoI, Persona, Numero, lejano).

% Resto
transformarPalabra(_, X, X):-
	\+ esPronombrePersonal(X, _, _, _),
	\+ esPronombreEnclitico(X),
	\+ esVerbo(X, _, _, _, _, _),
	\+ esPosesivo(X, _, _, _, _),
	\+ esPronombreReflexivo(X, _, _),
	\+ esDemostrativo(X, _, _, _).

esPronombreEnclitico(X):-
	esVerbo(_, Verbo, _, _, _, _),
	esPronombreComplementoIndirecto(Pronombre, _, _),
	atom_concat(Verbo, Pronombre, X).

% transformarPersona(Contexto, PersonaDirecta, PersonaIndirecta).
transformarPersona(
	contexto(sujeto(SPersona, _), _),
	1, 
	SPersona
	).

transformarPersona(
	contexto(_, ci(CIPersona, _)),
	2, 
	CIPersona 
	).

transformarPersona(_, 3, 3).

componerFraseDirecta(afirmativo, FrasePrincipal, OracionSubordinada, Salida):-
	append([FrasePrincipal, [":", "\""], OracionSubordinada ,["\""]], Salida).

componerFraseDirecta(interrogativo, FrasePrincipal, OracionSubordinada, Salida):-
	append([FrasePrincipal, [":", "\"", "¿"], OracionSubordinada ,["?","\""]], Salida).

componerFraseIndirecta(afirmativo, FrasePrincipal, Resultado, Salida):-
	append([FrasePrincipal, [que], Resultado], Salida).

componerFraseIndirecta(interrogativo, FrasePrincipal, Resultado, Salida):-
	append([FrasePrincipal, [que, si], Resultado], Salida).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   GRAMATICA     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TEST: frase(Salida, [maría, me, dijo, ":", "\"", juan, es, mi, amigo,"\""], []).
% TEST: frase(Salida, [maría, me, dijo, que, juan, era, su, amigo], []).
% TEST: frase(Salida, [luis, me, preguntó, que, si, estaba, ocupada, esa, noche], []).
% TEST: frase(Salida, [luis, me, preguntó, que, si, yo, estaba, ocupada, esa, noche], []).
frase(Salida) --> (fraseDirecta(Salida) ; fraseIndirecta(Salida)).

fraseDirecta(Salida) --> 
	frasePrincipal(FrasePrincipal, Contexto, Modo, GeneroSujeto), 
	[":"], ["\""],  oracionSubordinada(OracionSubordinadaDirecta, Modo, presente, GeneroSujeto), ["\""],
	{
		transformarSubordinada(Contexto, OracionSubordinadaDirecta, OracionSubordinadaIndirecta),
		oracionSubordinada(_, _, pasado, _, OracionSubordinadaIndirecta, []), % Check grammatical correctness
		componerFraseIndirecta(Modo, FrasePrincipal, OracionSubordinadaIndirecta, Salida)
	}.

fraseIndirecta(Salida) -->
	frasePrincipal(FrasePrincipal, Contexto, Modo, GeneroSujeto), 
	[que],
	([si] ; []),
	oracionSubordinada(OracionSubordinadaIndirecta, afirmativo, pasado, _),
	{
		transformarSubordinada(Contexto, OracionSubordinadaDirecta, OracionSubordinadaIndirecta),
		oracionSubordinada(_, _, presente, GeneroSujeto, OracionSubordinadaDirecta, []), % Check grammatical correctness
		componerFraseDirecta(Modo, FrasePrincipal, OracionSubordinadaDirecta, Salida)
	}.

% TEST: frasePrincipal(FrasePrincipal, Contexto, Modo, SGenero, [maría, me, dijo], []).
frasePrincipal(FrasePrincipal, contexto(sujeto(SPersona, SNumero), ci(CIPersona, CINumero)), Modo, SGenero) -->
	sujeto(Sujeto, SPersona, SNumero, SGenero), 
	[Pronombre], {esPronombreComplementoIndirecto(Pronombre, CIPersona, CINumero)}, 
	[Verbo], {esVerbo(Verbo, _, _, SPersona, SNumero, declarativo(Modo))},
	{append([Sujeto, [Pronombre, Verbo]],FrasePrincipal)}.

% TEST: sujeto(S, Persona, Numero, Genero, [maría], []).
% TEST: sujeto(S, Persona, Numero, Genero, [yo], []).
sujeto([Nombre], 3, Numero, Genero) --> [Nombre], {esNombrePropio(Nombre, Genero, Numero)}.
sujeto([Pronombre], Persona, Numero, Genero) --> [Pronombre], {esPronombrePersonal(Pronombre,Persona, Numero, Genero)}.
% sujeto([Pronombre], Persona, Numero, Genero) --> sintagmaNominal

% TEST: oracionSubordinada(OracionSubordinada, Modo, Tiempo, Genero1aPersona, [juan, es, mi, amigo], []).
% TEST: oracionSubordinada(OracionSubordinada, Modo, Tiempo, [juan, era, su, amigo], []).
% TEST: oracionSubordinada(OracionSubordinada, Modo, Tiempo, [yo, estaba, ocupada, esa, noche], []).
oracionSubordinada(OracionSubordinada, afirmativo, Tiempo, Genero1aPersona)--> 
	(sujeto(Sujeto, Persona, Numero, Genero) ; {Sujeto = []}),
	[Verbo], {esVerbo(Verbo, _, Tiempo, Persona, Numero, copulativo)}, 
	atributo(Atributo, Genero, Numero),
	(complementoTemporal(CN) ; {CN = []}),
	{append([Sujeto, [Verbo], Atributo, CN], OracionSubordinada)},
	{(Persona \= 1) ; (Genero == Genero1aPersona) }.

oracionSubordinada(OracionSubordinada, afirmativo, Tiempo, Genero1aPersona)-->
	(sujeto(Sujeto, Persona, Numero, Genero) ; {Sujeto = []}), 
	[Verbo], {esVerbo(Verbo, _, Tiempo, Persona, Numero, transitivo)}, 
	complementoDirecto(CD), 
	(complementoCircunstancial(CC) ; CC = []),
	{append([Sujeto, [Verbo], CD, CC], OracionSubordinada)},
	{(Persona \= 1) ; (Genero = Genero1aPersona) }.

oracionSubordinada(OracionSubordinada, interrogativo, Tiempo, Genero1aPersona)-->
	["¿"], 
	%(PronombreInterrogativo ; []),
	oracionSubordinada(OracionSubordinada, afirmativo, Tiempo, Genero1aPersona) 
	,["?"].

% TEST: atributo(Atributo, Genero, Numero, [ocupada], []).
atributo(SA, Genero, Numero) --> sintagmaAdjetival(SA, Genero, Numero).
atributo(SN, Genero, Numero) --> sintagmaNominal(SN, Genero, Numero).

complementoDirecto(CD) --> (sintagmaNominal(CD,_,_) ; sintagmaPreposicional(CD)).

sintagmaNominal([Det, Sust], Genero, Numero) --> 
	[Det], {esDeterminante(Det, Genero, Numero)}, 
	[Sust],{esSustantivoComun(Sust, Genero, Numero)}.
	%, (complementoDelNombre ; []).

sintagmaNominal([Nombre],Genero, Numero) --> [Nombre], {esNombrePropio(Nombre, Genero, Numero)}.

% TEST: sintagmaAdjetival(SA, Genero, Numero, [contento,de,verte], []).
sintagmaAdjetival(SA, Genero,Numero) --> 
	[Adj], {esAdjetivo(Adj, Genero, Numero)},
	(complementoAdjetivo(CA) ; {CA = []}),
	{append([[Adj], CA], SA)}.

complementoAdjetivo(CA) --> sintagmaPreposicional(CA).

%TEST: sintagmaPreposicional(SP, [de, verte], []).

sintagmaPreposicional([Preposicion | Termino]) --> 
	[Preposicion], {esPreposicion(Preposicion)},
	termino(Termino).

termino(SN) --> sintagmaNominal(SN, _, _) ; subordinadaSustantiva(SN).
subordinadaSustantiva([Compuesta]) --> [Compuesta], 
	{	
		esVerbo(_, Verbo, _, _, _, _), 
		esPronombreReflexivo(Pron, _, _),
		atom_concat(Verbo, Pron, Compuesta)
	}.

complementoCircunstancial(CC) --> sintagmaPreposicional(CC).

% TEST: complementoTemporal(CT, [esta, noche], []).
complementoTemporal([Demostrativo, T]) -->
	[Demostrativo],{esDemostrativo(Demostrativo, femenino, singular, _)},
	[T], {T = mañana ; T=tarde ; T=noche}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   DICCIONARIO   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Verbos  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% esVerbo(Verbo, Infinitivo, Tiempo, Persona, Numero, tipo).

% verbo ser
esVerbo(soy, ser, presente, 1, singular, copulativo).
esVerbo(eres, ser, presente, 2, singular, copulativo).
esVerbo(es, ser, presente, 3, singular, copulativo).
esVerbo(somos, ser, presente, 1, plural, copulativo).
esVerbo(sois, ser, presente, 2, plural, copulativo).
esVerbo(son, ser, presente, 3, plural, copulativo).

esVerbo(era, ser, pasado, 1, singular, copulativo).
esVerbo(eras, ser, pasado, 2, singular, copulativo).
esVerbo(era, ser, pasado, 3, singular, copulativo).
esVerbo(eramos, ser, pasado, 1, plural, copulativo).
esVerbo(erais, ser, pasado, 2, plural, copulativo).
esVerbo(eran, ser, pasado, 3, plural, copulativo).

% verbo estar
esVerbo(estoy, estar, presente, 1, singular, copulativo).
esVerbo(estás, estar, presente, 2, singular, copulativo).
esVerbo(está, estar, presente, 3, singular, copulativo).
esVerbo(estamos, estar, presente, 1, plural, copulativo).
esVerbo(estáis, estar, presente, 2, plural, copulativo).
esVerbo(están, estar, presente, 3, plural, copulativo).

esVerbo(estaba, estar, pasado, 1, singular, copulativo).
esVerbo(estabas, estar, pasado, 2, singular, copulativo).
esVerbo(estaba, estar, pasado, 3, singular, copulativo).
esVerbo(estabamos, estar, pasado, 1, plural, copulativo).
esVerbo(estabais, estar, pasado, 2, plural, copulativo).
esVerbo(estaban, estar, pasado, 3, plural, copulativo).

% verbo decir
esVerbo(digo, decir, presente, 1, singular, declarativo(afirmativo)).
esVerbo(dices, decir, presente, 2, singular, declarativo(afirmativo)).
esVerbo(dice, decir, presente, 3, singular, declarativo(afirmativo)).
esVerbo(decimos, decir, presente, 1, plural, declarativo(afirmativo)).
esVerbo(decis, decir, presente, 2, plural, declarativo(afirmativo)).
esVerbo(dicen, decir, presente, 3, plural, declarativo(afirmativo)).

esVerbo(dije, decir, pasado, 1, singular, declarativo(afirmativo)).
esVerbo(dijiste, decir, pasado, 2, singular, declarativo(afirmativo)).
esVerbo(dijo, decir, pasado, 3, singular, declarativo(afirmativo)).
esVerbo(dijimos, decir, pasado, 1, plural, declarativo(afirmativo)).
esVerbo(dijisteis, decir, pasado, 2, plural, declarativo(afirmativo)).
esVerbo(dijeron, decir, pasado, 3, plural, declarativo(afirmativo)).

% verbo ver
esVerbo(veo, ver, presente, 1, singular, transitivo).

% Conjugación automática de verbos regulares 

esVerbo(Verbo, Infinitivo, presente, 1, singular, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, o, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, presente, 2, singular, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, as, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, presente, 3, singular, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, a, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, presente, 1, plural, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, amos, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, presente, 2, plural, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, ais, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, presente, 3, plural, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, an, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

% pasado
esVerbo(Verbo, Infinitivo, pasado, 1, singular, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, aba, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasado, 2, singular, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, abas, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasado, 3, singular, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, aba, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasado, 1, plural, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, abamos, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasado, 2, plural, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, abais, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasado, 3, plural, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, aban, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

% pasadoPerfecto
esVerbo(Verbo, Infinitivo, pasadoPerfecto, 1, singular, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, é, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasadoPerfecto, 2, singular, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, aste, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasadoPerfecto, 3, singular, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, ó, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasadoPerfecto, 1, plural, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, amos, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasadoPerfecto, 2, plural, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, asteis, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

esVerbo(Verbo, Infinitivo, pasadoPerfecto, 3, plural, Tipo):-
	esLexemaVerboRegular(Lexema, ar, Tipo),
	atom_concat(Lexema, aron, Verbo),
	atom_concat(Lexema, ar, Infinitivo).

% esLexemaVerboRegular(Lexema, Conjugacion, tipo)
esLexemaVerboRegular(pregunt, ar, declarativo(interrogativo)).
esLexemaVerboRegular(necesit, ar, transitivo).

%% verboDeclarativo(1, singular, preteritoPerfectoSimple, interrogativo) --> [pregunté].
%% verboDeclarativo(3, singular, preteritoPerfectoSimple, interrogativo) --> [preguntó].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sustantivos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% esNombrePropio(Nombre, Genero, Numero).
esNombrePropio(luis, masculino, singular).
esNombrePropio(miguel, masculino, singular).
esNombrePropio(juan, masculino, singular).
esNombrePropio(maría, femenino, singular).
esNombrePropio(lucía, femenino, singular).

% esSustantivoComun(Sustantivo, Genero, Numero)
esSustantivoComun(cambio, masculino, singular).
esSustantivoComun(amigo, masculino, singular).
esSustantivoComun(amiga, femenino, singular).
esSustantivoComun(vida, femenino, singular).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Adjetivos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generacion automatica de adjetivos regulares
esAdjetivo(Adjetivo, masculino, singular):-
	esLexemaAdjetivoRegular(Lexema),
	atom_concat(Lexema, o, Adjetivo).
esAdjetivo(Adjetivo, femenino, singular):-
	esLexemaAdjetivoRegular(Lexema),
	atom_concat(Lexema, a, Adjetivo).
esAdjetivo(Adjetivo, masculino, plural):-
	esLexemaAdjetivoRegular(Lexema),
	atom_concat(Lexema, os, Adjetivo).
esAdjetivo(Adjetivo, femenino, plural):-
	esLexemaAdjetivoRegular(Lexema),
	atom_concat(Lexema, as, Adjetivo).

esLexemaAdjetivoRegular(content).
esLexemaAdjetivoRegular(ocupad).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Determinantes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

esDeterminante(Determinante, Genero, Numero):-
	esArticulo(Determinante, Genero, Numero,_ );
	esPosesivo(Determinante, _, _, Genero, Numero);
	esDemostrativo(Determinante, Genero, Numero, _).

% esArticulo(Articulo, Genero, Numero, GradoDeDeterminacion)
esArticulo(el, masculino, singular, definido).
esArticulo(un, masculino, singular, indefinido).
esArticulo(la, femenino, singular, definido).
esArticulo(una, femenino, singular, indefinido).
esArticulo(los, masculino, plural, definido).
esArticulo(unos, masculino, plural, indefinido).
esArticulo(las, femenino, plural, definido).
esArticulo(unas, femenino, plural, indefinido).

% esPosesivo(Posesivo, PersonaPoseedor, NumeroPoseedor, GeneroPoseido, NumeroPoseido).
esPosesivo(mi, 1, singular, _, singular).
esPosesivo(tu, 2, singular, _, singular).
esPosesivo(su, 3, singular, _, singular).
esPosesivo(mis, 1, singular, _, plural).
esPosesivo(tus, 2, singular, _, plural).
esPosesivo(sus, 3, singular, _, plural).

% esDemostrativo(Demostrativo, Genero, Numero, GradoDeDeixis).
esDemostrativo(este, masculino, singular, cercano).
esDemostrativo(esta, femenino, singular, cercano).
esDemostrativo(estos, masculino, plural, cercano).
esDemostrativo(estas, femenino, plural, cercano).
esDemostrativo(ese, masculino, singular, lejano).
esDemostrativo(esa, femenino, singular, lejano).
esDemostrativo(esos, masculino, plural, lejano).
esDemostrativo(esas, femenino, plural, lejano).


%%%%%%%%%%%%%%%%%%%%%%%%% Pronombres %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% esPronombrePersonal(Pronombre,Persona, Numero, Genero).
esPronombrePersonal(yo, 1, singular, _).
esPronombrePersonal(tu, 2, singular, _).
esPronombrePersonal(él, 3, singular, masculino).
esPronombrePersonal(ella, 3, singular, femenino).
esPronombrePersonal(nosotros, 1, plural, masculino).
esPronombrePersonal(nosotras, 1, plural, femenino).
esPronombrePersonal(vosotros, 2, plural, masculino).
esPronombrePersonal(vosotras, 2, plural, femenino).
esPronombrePersonal(ellos, 3, plural, masculino).
esPronombrePersonal(ellas, 3, plural, femenino).

% esPronombreReflexivo(Pronombre, Persona, Numero).
esPronombreReflexivo(me, 1, singular).
esPronombreReflexivo(te, 2, singular).
esPronombreReflexivo(se, 3, singular).
esPronombreReflexivo(nos, 1, plural).
esPronombreReflexivo(os, 2, plural).
esPronombreReflexivo(se, 3, plural).

% esPronombreComplementoIndirecto(Pronombre, Persona, Numero)
esPronombreComplementoIndirecto(me, 1, singular).
esPronombreComplementoIndirecto(te, 2, singular).
esPronombreComplementoIndirecto(le, 3, singular).
esPronombreComplementoIndirecto(nos, 1, plural).
esPronombreComplementoIndirecto(os, 2, plural).
esPronombreComplementoIndirecto(les, 3, plural).

%%%%%%%%%%%%%%%%%%%%% Preposiciones %%%%%%%%%%%%%%%%%%%%%%%%%
esPreposicion(de).
esPreposicion(en).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%