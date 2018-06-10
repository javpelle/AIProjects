% Javier Pellejero Ortega. Zhaoyan Ni
% Debido a la falta de tiempo porque estamos en el periodo de examenes, no hemos hecho la parte 2, 
% y en la primera parte solo hemos el reconocimiento de frases en directo o en indirecto.

% A priori, lo que falta es la tranformación de la frase subordinada. La gramática está completa y compila.


% el programa recibe una frase en directo o en indirecto, lo reconocemos y hacemos el cambio directo-indirecto o 
% indirecto-directo.

frase(Salida) --> directo(Salida).
frase(Salida) --> indirecto(Salida).

% tansformar una frase en directo a indirecto
directo(Salida) -->	
	principioOracion(OracionPpio, Sujeto, CIndirecto), 
	[":"], ["\""],
	interrogacion(Int),
	oracionFinal(Directa), interrogacion(Int), ["\""],
	{
		%transformarAIndirecta(Sujeto, CIndirecto, Pregunta, Directa, Indirecta),
		%fraseFinal(Oracion Ppio, Indirecta, Salida).
	}.

% transformar una frase indirecto a directo
indirecto(Salida) -->
	principioOracion(OracionPpio, Sujeto, CIndirecto), 
	[que],
	pregunta(Pregunta),
	oracionFinal(Indirecta),
	{
		%transformarADirecta(Sujeto, CIndirecto, Pregunta, Indirecta, Directa),
		%fraseFinal(Oracion Ppio, Directa, Salida).
	}.

pregunta(si) --> [si].
pregunta(no) --> [].
interrogacion(si) --> ["¿"].
interrogacion(no) --> [].
interrogacion(si) --> ["?"].

% transforma la oración principal.
principioOracion(OracionPpio, sujeto(Persona, Num), cIndirecto(PersonaCI, NumCI)) -->
	sujeto(Sujeto, Persona, Num, _),
	[CI], {pronAtono(CI, PersonaCI, NumCI)}, 
	[Verbo], {verboDecir(Verbo, Persona, Num)},
	{append([Sujeto, [Pronombre, Verbo]], OracionPpio)}.
	

sujeto([Pronombre], Persona, Numero, Genero) --> [Pronombre], {pronPersonal(Pronombre,Persona, Numero, _)}.
sujeto([Nombre], 3, singular, Genero) --> [Nombre], {nombrePropio(Nombre, _)}.

% transforma la oración con verbos nominales, es decir, ser, estar, parecer.
oracionFinal(OracionFinal) --> 
	(sujeto(Sujeto, Persona, Numero, Genero) ; {Sujeto = []}),
	[Verbo], {verboCop(Verbo, _, _, Persona, Numero)}, 
	atributo(Atributo, Genero, Numero),
	(sPreposicional(SP) ; {SP = []}),
	{append([Sujeto, [Verbo], Atributo, SP], OracionSubordinada)}.

% transforma las oraciones con complemento directo
oracionFinal(OracionFinal)-->
	(sujeto(Sujeto, Persona, Numero) ; {Sujeto = []}), 
	[Verbo], {verboPred(Verbo, _, _, Persona, Numero)}, 
	cDirecto(CD), 
	(sPreposicional(SP) ; {SP = []}),
	{append([Sujeto, [Verbo], CD, CC], OracionSubordinada)}.

atributo(Atributo, Genero, Numero) --> sAdjetival(Atributo, Genero, Numero).
atributo(Atributo, _, _) --> sNominal(Atributo).

% sintagma adjetival
sAdjetival(Adjetival, Genero, Numero) --> 
	[Adjetivo], {adjetivo(Adjetivo, Numero, Genero)},
	(sPreposicional(SP) ; {SP = []}),
	{append([[Adj], SP], Adjetival)}.

% sintagma preposicional con sintagma nomial
sPreposicional(SP) --> 
	[Prep], {preposicion(Prep)},
	sNominal(SN),
	{append([[Prep], SN], SP)}.
	
% sintagma preposicional con sintagma verbal
sPreposicional(SP) --> 
	[Prep], {preposicion(Prep)},
	sVerbal(SV),
	{append([[Prep], SN], SP)}.
	
% sintagma nominal
sNominal(SN) --> 
	[Det], {determinante(Det, Numero, Genero)}, 
	[Sust],{sustantivo(Sust, Genero, Numero)}.
	{append([[Det], Sust], SN)}.

sNominal([Nombre]) --> [Nombre], {nombrePropio(Nombre, _)}.

% sintagma verbal. Podría ser más complejo, como otra subordinada, pero lo hemos reducido a infinitivos (mas, opcionalmente, un sufijo).
sVerbal([SV]) --> infinitivo(SV).

% complemento directo, que puede ser un sintagma nominal o un sintagma preposicional 
cDirecto(CD) --> sNominal(CD).
cDirecto(CD) --> sPreposicional(CD).


%%%%%%%%%%%%%%%%
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

nombrePropio(María, femenino).
nombrePropio(Juan, masculino).
nombrePropio(Miguel, masculino).
nombrePropio(Lucía, femenino).
nombrePropio(Luis, masculino).

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

verboPred(necesitaba, estar, pasado, 1, singular).
verboPred(necesitabas, estar, pasado, 2, singular).
verboPred(necesitaba, estar, pasado, 3, singular).
verboPred(necesitábamos, estar, pasado, 1, plural).
verboPred(necesitábais, estar, pasado, 2, plural).
verboPred(necesitaban, estar, pasado, 3, plural).

verboPred(necesito, estar, presente, 1, singular).
verboPred(necesitas, estar, presente, 2, singular).
verboPred(necesita, estar, presente, 3, singular).
verboPred(necesitamos, estar, presente, 1, plural).
verboPred(necesitais, estar, presente, 2, plural).
verboPred(necesitan, estar, presente, 3, plural).

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

sustantivo(cambio, masculino, sigular).
sustantivo(amigo, masculino, sigular).
sustantivo(vida, femenino, sigular).
sustantivo(noche, femenino, sigular).

infinitivo(ver).
infinitivo(verme).
infinitivo(verte).

prep(a).
prep(de).
prep(en).


%programa principal
consulta:- write('Escribe frase entre corchetes separando palabras con comas '), nl,
write('o lista vacía para parar '), nl,
read(F),
trata(F).


trata(F):- frase(Salida, F, []), write(Salida), consulta.
% tratamiento caso general

trata([]):- write('final').
% tratamiento final

% transformarADirecta(Sujeto, CIndirecto, OracionSubordinadaDirecta, OracionSubordinadaIndirecta)
% transforma de palabra a palabra en forma directa, por ejemplo
cambiarPalabra(Var, Var):- nombrePropio(Var, _).
cambiarPalabra(Var, Var):- verboDecir(Var, _ ,_ ).
cambiarPalabra(Var, Var):- adjetivo(Var, _ ,_ ).
cambiarPalabra(Var, Var):- sustantivo(Var,_,_).
% es decir, mantenos los nombres propio, conjugaciones de verbo decir, adjetivos y los sustantivos.

% componerFraseIndirecta(Modo, FrasePrincipal, OracionSubordinadaIndirecta, Salida)
% para componer la frase, usamos el método append de prolog
