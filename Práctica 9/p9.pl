% Javier Pellejero Ortega. Zhaoyan Ni
% Debido a la falta de tiempo porque estamos en el periodo de examenes, no hemos hecho la parte 2, 
% y en la primera parte solo hemos el reconocimiento de frases en directo o en indirecto.

% A priori, lo que falta es la tranformación de la frase subordinada. La gramática está completa y compila.


% el programa recibe una frase en directo o en indirecto, lo reconocemos y hacemos el cambio directo-indirecto o 
% indirecto-directo.

frase(Salida) --> directo(Salida).
frase(Salida) --> indirecto(Salida).

% tansformar una frase en directo a indirecto
% No nos lee las comillas y da rechazo.
directo(Salida) -->	
	principioOracion(OracionPpio), 
	[":"], ["\""],
	interrogacion(Int),
	{write(hola),nl},
	oracionFinal(OracionFinal, Sujeto, Verbo, Persona, Numero), interrogacion(Int), ["\""],
	{
		transformarAIndirecta(OracionFinal, Sujeto, Verbo, Persona, Numero, Int, Indirecta),
		append([OracionPpio,Indirecta], Salida)
	}.

% transformar una frase indirecto a directo
indirecto(Salida) -->
	principioOracion(OracionPpio), 
	[que],
	pregunta(Pregunta),
	oracionFinal(OracionFinal, Sujeto, Verbo, Persona, Numero),
	{
		transformarADirecta(OracionFinal, Sujeto, Verbo, Persona, Numero, Pregunta, Directa),
		append([OracionPpio,Directa], Salida)
	}.

pregunta(si) --> [si].
pregunta(no) --> [].
interrogacion(si) --> ["¿"].
interrogacion(no) --> [].
interrogacion(si) --> ["?"].

% Analiza la oración principal.
principioOracion(OracionPpio) -->
	sujeto(Sujeto, Persona, Num, _),
	[CI], {pronAtono(CI, _, _)}, 
	[Verbo], {verboDecir(Verbo, Persona, Num)},
	{append([Sujeto, [CI, Verbo]], OracionPpio)}.
	

sujeto([Pronombre], Persona, Numero, Genero) --> [Pronombre], {pronPersonal(Pronombre,Persona, Numero, Genero)}.
sujeto([Nombre], 3, singular, Genero) --> [Nombre], {nombrePropio(Nombre, Genero)}.

% Analiza la oración con verbos nominales, es decir, ser, estar, parecer.
oracionFinal(OracionFinal, Sujeto, Verbo, Persona, Numero) -->
	(sujeto(Sujeto, Persona, Numero, Genero) ; {Sujeto = []}),
	[Verbo], {verboCop(Verbo, _, _, Persona, Numero)}, 
	atributo(Atributo, Genero, Numero),
	(sPreposicional(SP) ; {SP = []}),
	{append([Atributo, SP], OracionFinal)}.

% Analiza las oraciones con complemento directo
oracionFinal(OracionFinal, Sujeto, Verbo, Persona, Numero)-->
	(sujeto(Sujeto, Persona, Numero, _) ; {Sujeto = []}), 
	[Verbo], {verboPred(Verbo, _, _, Persona, Numero)}, 
	cDirecto(CD), 
	(sPreposicional(SP) ; {SP = []}),
	{append([CD, CC], OracionFinal)}.

atributo(Atributo, Genero, Numero) --> sAdjetival(Atributo, Genero, Numero).
atributo(Atributo, Genero, Numero) --> sNominal(Atributo, Genero, Numero).

% sintagma adjetival
sAdjetival(Adjetival, Genero, Numero) -->
	[Adjetivo], {adjetivo(Adjetivo, Numero, Genero)},
	(sPreposicional(SP) ; {SP = []}),
	{append([[Adjetivo], SP], Adjetival)}.

% sintagma preposicional con sintagma nomial
sPreposicional(SP) --> 
	[Prep], {preposicion(Prep)},
	sNominal(SN,_,_),
	{append([[Prep], SN], SP)}.
	
% sintagma preposicional con sintagma verbal
sPreposicional(SP) --> 
	[Prep], {preposicion(Prep)},
	sVerbal(SV),
	{append([[Prep], SV], SP)}.
	
% sintagma nominal
sNominal(SN, Genero, Numero) -->
	[Det], {determinante(Det, Numero, Genero)}, 
	[Sust],{sustantivo(Sust, Genero, Numero)},
	{append([[Det], [Sust]], SN)}.

sNominal([Nombre],Genero,_) --> [Nombre], {nombrePropio(Nombre, Genero)}.

% sintagma verbal. Podría ser más complejo, como otra subordinada, pero lo hemos reducido a infinitivos (mas, opcionalmente, un sufijo).
sVerbal([Verbo]) --> [Verbo], {infinitivo(Verbo)}.

% complemento directo, que puede ser un sintagma nominal o un sintagma preposicional 
cDirecto(CD) --> sNominal(CD).
cDirecto(CD) --> sPreposicional(CD).

%--------------- FUNCIONES ------------------------%

%-- Ambigüedad: me dijo que estaba bien puede ser
%-- me dijo "yo estoy bien"
%-- me dijo "él estaba bien" (nos quedamos con esta transformacion)
transformarADirecta(OracionFinal, Sujeto, Verbo, 3, Numero, Pregunta, Directa) :-
	((Pregunta = si, Inicio = ["¿"], Final = ["?"]) ; (Pregunta = no, Inicio = [], Final = [])),
	verbo(Verbo, Infinitivo,_,_,_),
	verbo(VerboNuevo, Infinitivo, presente, 3, Numero),	
	append([[":\""],Inicio, Sujeto, [VerboNuevo], OracionFinal, Final,["\""]], Directa).
	
transformarADirecta(OracionFinal, Sujeto, Verbo, 1, Numero, Pregunta, Directa) :-
	((Pregunta = si, Inicio = ["¿"], Final = ["?"]) ; (Pregunta = no, Inicio = [], Final = [])),
	verbo(Verbo, Infinitivo,_,_,_),
	verbo(VerboNuevo, Infinitivo, presente, 2, Numero),	
	append([[":\""],Inicio, ["tú"], [VerboNuevo], OracionFinal, Final,["\""]], Directa).

%-- Faltaría alguna más de transformacion a indirecta.
transformarAIndirecta(OracionFinal, Sujeto, Verbo, 1, Numero, Pregunta, Directa) :-
	((Pregunta = si, Inicio = [si]) ; (Pregunta = no, Inicio = [])),
	verbo(Verbo, Infinitivo,_,_,_),
	verbo(VerboNuevo, Infinitivo, pasado, 3, Numero),	
	append([[que],Inicio, ["él"], [VerboNuevo], OracionFinal], Indirecta).


%--------------- DICCIONARIO ----------------------%
pronPersonal(yo, 1, singular, _).
pronPersonal(tu, 2, singular, _).
pronPersonal(él, 3, singular, masculino).
pronPersonal(ella, 3, singular, femenino).
pronPersonal(nosotros, 1, plural, masculino).
pronPersonal(nosotras, 1, plural, femenino).
pronPersonal(vosotros, 2, plural, masculino).
pronPersonal(vosotras, 2, plural, femenino).
pronPersonal(ellos, 3, plural, masculino).
pronPersonal(ellas, 3, plural, femenino).

nombrePropio(maría, femenino).
nombrePropio(juan, masculino).
nombrePropio(miguel, masculino).
nombrePropio(lucía, femenino).
nombrePropio(luis, masculino).

pronAtono(me, 1, singular).
pronAtono(te, 2, singular).
pronAtono(le, 3, singular).
pronAtono(nos, 1, plural).
pronAtono(os, 2, plural).
pronAtono(les, 3, plural).

verboDecir(dije, 1, singular).
verboDecir(dijiste, 2, singular).
verboDecir(dijo, 3, singular).
verboDecir(dijimos, 1, plural).
verboDecir(dijisteis, 2, plural).
verboDecir(dijeron, 3, plural).

verboDecir(pregunté, 1, singular).
verboDecir(preguntaste, 2, singular).
verboDecir(preguntó, 3, singular).
verboDecir(preguntamos, 1, plural).
verboDecir(preguntasteis, 2, plural).
verboDecir(preguntaron, 3, plural).

verbo(Verbo, Infinitivo, Tiempo, Persona, Numero) :- verboCop(Verbo, Infinitivo, Tiempo, Persona, Numero).
verbo(Verbo, Infinitivo, Tiempo, Persona, Numero) :- verboPred(Verbo, Infinitivo, Tiempo, Persona, Numero).

verboCop(soy, ser, presente, 1, singular).
verboCop(eres, ser, presente, 2, singular).
verboCop(es, ser, presente, 3, singular).
verboCop(somos, ser, presente, 1, plural).
verboCop(sois, ser, presente, 2, plural).
verboCop(son, ser, presente, 3, plural).

verboCop(era, ser, pasado, 1, singular).
verboCop(eras, ser, pasado, 2, singular).
verboCop(era, ser, pasado, 3, singular).
verboCop(eramos, ser, pasado, 1, plural).
verboCop(erais, ser, pasado, 2, plural).
verboCop(eran, ser, pasado, 3, plural).

verboCop(estoy, estar, presente, 1, singular).
verboCop(estás, estar, presente, 2, singular).
verboCop(está, estar, presente, 3, singular).
verboCop(estamos, estar, presente, 1, plural).
verboCop(estáis, estar, presente, 2, plural).
verboCop(están, estar, presente, 3, plural).

verboCop(estaba, estar, pasado, 1, singular).
verboCop(estabas, estar, pasado, 2, singular).
verboCop(estaba, estar, pasado, 3, singular).
verboCop(estábamos, estar, pasado, 1, plural).
verboCop(estábais, estar, pasado, 2, plural).
verboCop(estaban, estar, pasado, 3, plural).

verboPred(necesitaba, necesitar, pasado, 1, singular).
verboPred(necesitabas, necesitar, pasado, 2, singular).
verboPred(necesitaba, necesitar, pasado, 3, singular).
verboPred(necesitábamos, necesitar, pasado, 1, plural).
verboPred(necesitábais, necesitar, pasado, 2, plural).
verboPred(necesitaban, necesitar, pasado, 3, plural).

verboPred(necesito, necesitar, presente, 1, singular).
verboPred(necesitas, necesitar, presente, 2, singular).
verboPred(necesita, necesitar, presente, 3, singular).
verboPred(necesitamos, necesitar, presente, 1, plural).
verboPred(necesitais, necesitar, presente, 2, plural).
verboPred(necesitan, necesitar, presente, 3, plural).

adjetivo(guapo, singular, masculino).
adjetivo(guapos, plural, masculino).
adjetivo(guapa, singular, femenino).
adjetivo(guapas, plural, femenino).
adjetivo(contento, singular, masculino).
adjetivo(contentos, singular, masculino).
adjetivo(contenta, singular, femenino).
adjetivo(contentas, singular, femenino).
adjetivo(ocupado, singular, masculino).
adjetivo(ocupados, singular, masculino).
adjetivo(ocupada, singular, femenino).
adjetivo(ocupadas, singular, femenino).

determinante(mi, singular, _).
determinante(mis, plural, _).
determinante(tu, singular, _).
determinante(tus, plural, _).
determinante(su, singular, _).
determinante(sus, plural, _).

determinante(el, singular, masculino).
determinante(la, singular, femenino).
determinante(los, plural, masculino).
determinante(las, plural, femenino).

determinante(Det, Numero, Genero) :- determinanteDemostrativo(Det, Numero, Genero, _).

determinanteDemostrativo(este, singular, masculino, cerca).
determinanteDemostrativo(esta, singular, femenino, cerca).
determinanteDemostrativo(ese, singular, masculino, lejos).
determinanteDemostrativo(esa, singular, femenino, lejos).

sustantivo(cambio, masculino, singular).
sustantivo(amigo, masculino, singular).
sustantivo(amigo, femenino, singular).
sustantivo(vida, femenino, singular).
sustantivo(noche, femenino, singular).

infinitivo(ver).
infinitivo(verme).
infinitivo(verte).

preposicion(a).
preposicion(de).
preposicion(en).


%------------- MAIN -------------%
consulta:- write('Escribe frase entre corchetes separando palabras con comas '), nl,
	write('o lista vacía para parar '), nl,
	read(F),
	trata(F).


trata(F):- frase(Salida, F, []), write(Salida), nl, consulta.
% tratamiento caso general

trata([]):- write('final'),nl.
% tratamiento final
