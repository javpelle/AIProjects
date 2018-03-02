% Respuestas afirmativas
afirmativa(s).
afirmativa(si).

% Respuestas negativas
negativa(n).
negativa(no).

% Preguntar al usuario si tiene algún sintoma
sintoma(nauseas):- pregunta_si(nauseas).
sintoma(vomito):- pregunta_si(vomito).
sintoma('picor nariz'):- pregunta_si('picor nariz').
sintoma('congestion nasal'):- pregunta_si('congestion nasal').
sintoma('congestion ocular'):- pregunta_si('congestion ocular').
sintoma(fiebre):- pregunta_si(fiebre).
sintoma('dolor de cabeza'):- pregunta_si('dolor de cabeza').
sintoma('rigidez en la nuca'):- pregunta_si('rigidez en la nuca').
sintoma('dolor de garganta'):- pregunta_si('dolor de garganta').
sintoma(malestar):- pregunta_si(malestar).

% Preguntar al usuario si es alérgico a algún componente químico.
alergico(tripolidina):- pregunta_si(tripolidina).
alergico(ebastina):- pregunta_si(ebastina).
alergico(amoxicilina):- pregunta_si(amoxicilina).
alergico(ampicilina):- pregunta_si(ampicilina).
alergico(paracetamol):- pregunta_si(paracetamol).
alergico('acido acetilsalicilico'):- pregunta_si('acido acetilsalicilico').
alergico(metoclopramida):- pregunta_si(metoclopramida).

% Preguntas para preguntar  qué sintomas tiene el usuario
pregunta(nauseas):- write('¿Tiene usted nauseas?').
pregunta(vómitos):- write('¿Tiene usted vómitos?').
pregunta('picor nariz') :- write('¿Tiene usted picor de nariz?').
pregunta('congestion nasal'):- write('¿Tiene usted congestion nasal?').
pregunta('congestion ocular'):- write('¿Tiene usted congestion ocular?').
pregunta(fiebre):- write('¿Tiene usted fiebre?').
pregunta('dolor de cabeza'):- write('¿Tiene usted dolor de cabeza?').
pregunta('rigidez en la nuca'):- write('¿Tiene usted rigdez en la nuca?').
pregunta('dolor de garganta'):- write('¿Tiene usted dolor de garganta?').
pregunta(malestar):- write('¿Te sientes malestar general?').

% Preguntas para preguntar al usuario si es alérgico al algún componente químico
pregunta(tripolidina):- write('¿Eres alergico a tripolidina?').
pregunta(ebastina):- write('¿Eres alergico a ebastina?').
pregunta(amoxicilina):- write('¿Eres alergico al amoxicilina?').
pregunta(ampicilina):- write('¿Eres alergico al ampicilina?').
pregunta(paracetamol):- write('¿Eres alergico al paracetamol?').
pregunta('acido acetilsalicilico'):- write('¿Eres alergico al acido acetilsalicilico?').
pregunta(metoclopramida):- write('¿Eres alergico a metoclopramida?').



% Regla para preguntar: si una pregunta había sido preguntado y tiene respuesta afirmativa, pregunta_si(C) tiene valor true
% C: clave de la pregunta, puede ser algún sintoma o algún componente químico
% R: respuesta del usuario, puede ser si,s (respuestas afirmativas) o no, n (respuestas negativas)

:- dynamic preguntado/2.
pregunta_si(C) :- confirma(C, R), respuesta_positiva(C, R).

% Si una pregunta con clave C había sido preguntado, confirma(C) tiene valor true, si no había preguntado la pregunta, 
% se pregunta al usuario, lee la respuesta, y aserta un hecho preguntado(C,R) para indicar que la pregunta ha sido preguntado
% C: clave de la pregunta, puede ser algún sintoma o algún componente químico
% R: respuesta del usuario, puede ser si,s (respuestas afirmativas) o no, n (respuestas negativas)

confirma(C, R) :- preguntado(C, R).
confirma(C, R) :- \+preguntado(C, _), nl, pregunta(C), read(R), asserta(preguntado(C, R)).

% Control de contestación afirmativa
% Si la respuesta no es afirmativa ni negativa, le pedimos al usuario que introduzca una respuesta en forma correcta, eliminamos 
% el hecho con respuesta en mal formato y asertamos el hecho preguntado con clave C y la nueva respuesta
% repetimos el proceso hasta tener una respusta correcta
% C: clave de la pregunta, puede ser algún sintoma o algún componente químico
% R: respuesta del usuario, puede ser si,s (respuestas afirmativas) o no, n (respuestas negativas)
% R2: la nueva respuesta del usuario 

respuesta_positiva(_, R) :- afirmativa(R).
respuesta_positiva(C, R) :- \+afirmativa(R), \+negativa(R), write('Por favor, conteste si/s o no/n y termine con .: '), read(R2), retract(preguntado(C, R)),
							asserta(preguntado(C, R2)), respuesta_positiva(C, R2).

% tipoComponente(X,Y) <--> X es un componente químico del tipo Y
tipoComponente(tripolidina, antihistaminico).
tipoComponente(ebastina, antihistaminico).
tipoComponente(amoxicilina, antibiotico).
tipoComponente(ampicilina, antibiotico).
tipoComponente(paracetamol, analgesico).
tipoComponente('acido acetilsalicilico', analgesico).
tipoComponente(metoclopramida, antiemetico).

% contiene(X,Y) <--> X es un medicamento que contiene al componente químico Y
contiene(aspirina, 'acido acetilsalicilico').
contiene(iniston, tripolidina).
contiene(clamoxil, amoxicilina).
contiene(gelocatil, paracetamol).
contiene(ebastel, ebastina).
contiene(britapen, ampicilina).
contiene(primperan, metoclopramida).

% tipoEnfermedad(X,Y) <--> X es una enfermedad del tipo Y
tipoEnfermedad(rinitis, alergia).
tipoEnfermedad(faringitis, infeccion).
tipoEnfermedad(meningitis, infeccion).

% sintomaEnfermedad(X) <--> especifica los sintomas de una enfermedad
sintomaEnfermedad(rinitis) :- sintoma('picor nariz'), sintoma('congestion nasal'), sintoma('congestion ocular').
sintomaEnfermedad(faringitis) :- sintoma('dolor de garganta'), sintoma(fiebre), sintoma(malestar).
sintomaEnfermedad(meningitis) :- sintoma(fiebre), sintoma('dolor de cabeza'), sintoma('rigidez en la nuca'), sintoma(nauseas).
sintomaEnfermedad(meningitis) :- sintoma(fiebre), sintoma('dolor de cabeza'), sintoma('rigidez en la nuca'), sintoma(vomito).

% para saber qué tipo de componente quimico hay que usar para un tipo de enfermedad.
% si la enfermedad es de tipo alérgico, hay que usar medicamentos que contiene al componente químico antihistaminico
% si la enfermedad es de tipo infecciosa bacteria, hay que usar medicamentos que contiene al componente químico antibiotico
componenteEnfermedad(Enfermedad,antihistaminico):- tipoEnfermedad(Enfermedad, alergia).
componenteEnfermedad(Enfermedad,antibiotico):- tipoEnfermedad(Enfermedad, infeccion).

% sintomaComponente(X) <--> especifica que para aliviar un sintoma concreto hay que tomar medicamentos que contienen el componente químico del tipo X
sintomaComponente(analgesico):- sintoma(fiebre).
sintomaComponente(analgesico):- sintoma('dolor de cabeza').
sintomaComponente(analgesico):- sintoma('dolor de garganta').
sintomaComponente(antihistaminico):- sintoma('congestion nasal').
sintomaComponente(antihistaminico):- sintoma('congestion ocular').

% predicado para recetar una enfermedad concreta
% primero identificamos qué tipo de componente químico sirven para la enfermedad, y buscamos los componentes químicos concretos, 
% preguntamos al usuario si es alergico a ese conponente quimico, si no, le recetamos un medicamento que contiene ese componente químico
% Si el usuario es alergico a todos los componentes químicos encontrados, le recomendamos que acuda a un medico de verdad

recetar(Enfermedad):- componenteEnfermedad(Enfermedad,A),tipoComponente(Z,A), \+alergico(Z),contiene(Medicamento,Z),!,
					write('Su enfermedad es: '),write(Enfermedad),nl,write('Te recetamos el medicamento: '), nl, write(Medicamento).
recetar(Enfermedad):- write('Lo sentimos, no podemos recertarle ningún medicamento. Le recomendamos que acuda a un médico.'),nl.

% predicado que sirve para recetar medicamentos para aliviar los sintomas del usuario en caso de no hemos podido diagnosticar la enfermedad
% su funcionamiento es analogico al del predicado recetar
aliviar():- write('Para aliviar sus sintomas, puedes tomar: '), sintomaComponente(X), tipoComponente(Z, X), \+alergico(Z), contiene(Medicamento, Z), write(Medicamento), nl.
aliviar():- write('Lo sentimos, no podemos recertarle ningún medicamento. Le recomendamos que acuda a un médico.'),nl.

% predicado principal, sirve para especificar la enfermedad del usuario y le receta un medicamento, en caso de que no ha podido diagnosticar su enfermedad, 
% le recetamos medicamentos para aliviar sus sintomas 
diagnosticar():- sintomaEnfermedad(X),recetar(X), retractall(preguntado(_,_)).
diagnosticar():- write('Lo sentimos, no hemos podido identificar la enfermadad.'), aliviar().
