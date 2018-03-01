afirmativa(s).
afirmativa(si).

negativa(n).
negativa(no).

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

:- dynamic preguntado/2.
pregunta_si(C) :- confirma(C, R), respuesta_positiva(C, R).

confirma(C, R) :- preguntado(C, R).
confirma(C, R) :- \+preguntado(C, _), nl, pregunta(C), read(R), asserta(preguntado(C, R)).

% Control de contestación afirmativa
respuesta_positiva(_, R) :- afirmativa(R).
respuesta_positiva(C, R) :- \+afirmativa(R), \+negativa(R), write('Por favor, conteste si/s o no/n y termine con .: '), read(R2), retract(preguntado(C, R)),
							asserta(preguntado(C, R2)), respuesta_positiva(C, R2).
% alergico(ampicilina).
alergico(paracetamol).

tipoComponente(tripolidina, antihistaminico).
tipoComponente(ebastina, antihistaminico).
tipoComponente(amoxicilina, antibiotico).
tipoComponente(ampicilina, antibiotico).
tipoComponente(paracetamol, analgesico).
tipoComponente('acido acetilsalicilico', analgesico).
tipoComponente(metoclopramida, antiemetico).

contiene(aspirina, 'acido acetilsalicilico').
contiene(iniston, tripolidina).
contiene(clamoxil, amoxicilina).
contiene(gelocatil, paracetamol).
contiene(ebastel, ebastina).
contiene(britapen, ampicilina).
contiene(primperan, metoclopramida).

tipoEnfermedad(rinitis, alergia).
tipoEnfermedad(faringitis, infeccion).
tipoEnfermedad(meningitis, infeccion).

sintomaEnfermedad(rinitis) :- sintoma('picor nariz'), sintoma('congestion nasal'), sintoma('congestion ocular').
sintomaEnfermedad(faringitis) :- sintoma('dolor de garganta'), sintoma(fiebre), sintoma(malestar).
sintomaEnfermedad(meningitis) :- sintoma(fiebre), sintoma('dolor de cabeza'), sintoma('rigidez en la nuca'), sintoma(nauseas).
sintomaEnfermedad(meningitis) :- sintoma(fiebre), sintoma('dolor de cabeza'), sintoma('rigidez en la nuca'), sintoma(vomito).

% para saber qué tipo de componente quimico hay que usar para un tipo de enfermedad.
componenteEnfermedad(Enfermedad,antihistaminico):- tipoEnfermedad(Enfermedad, alergia).
componenteEnfermedad(Enfermedad,antibiotico):- tipoEnfermedad(Enfermedad, infeccion).

sintomaComponente(analgesico):- sintoma(fiebre).
sintomaComponente(analgesico):- sintoma('dolor de cabeza').
sintomaComponente(analgesico):- sintoma('dolor de garganta').
sintomaComponente(antihistaminico):- sintoma('congestion nasal').
sintomaComponente(antihistaminico):- sintoma('congestion ocular').

recetar(Enfermedad):- componenteEnfermedad(Enfermedad,A),tipoComponente(Z,A), \+alergico(Z),contiene(Medicamento,Z),!,
					write('Su enfermedad es: '),write(Enfermedad),nl,write('Te recetamos el medicamento: '), nl, write(Medicamento).
recetar(Enfermedad):- write('Lo sentimos, no hemos podido recertarle algún medicamento. Le recomendamos que acuda a un médico.'),nl.

aliviar():- write('Para aliviar sus sintomas, puedes tomar: '), sintomaComponente(X), tipoComponente(Z, X), \+alergico(Z), contiene(Medicamento, Z), write(Medicamento), nl.
aliviar():- write('Lo sentimos, no hemos podido recertarle algún medicamento. Le recomendamos que acuda a un médico.'),nl.

diagnosticar():- sintomaEnfermedad(X),recetar(X).
diagnosticar():- write('Lo sentimos, no hemos podido identificar la enfermadad.'), aliviar().
