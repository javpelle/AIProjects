afirmativa(s).
afirmativa(si).

negativa(n).
negativa(no).


tipoComponente(tripolidina, antihestaminico).
tipoComponente(ebastina, antihestaminico).
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

sintomaEnfermedad(rinitis) :- sintoma('picor nariz'), sintoma('congestion nasal'), sintoma('congestion ocular').
sintomaEnfermedad(faringitis) :- sintoma('dolor de garganta'), sintoma(fiebre), sintoma(malestar).
sintomaEnfermedad(meningitis) :- sintoma(fiebre), sintoma('dolor de cabeza'), sintoma('rigdez en la nuca'), sintoma(nauseas).
sintomaEnfermedad(meningitis) :- sintoma(fiebre), sintoma('dolor de cabeza'), sintoma('rigdez en la nuca'), sintoma(vomitos).

componenteEnfermedad(alergia, antihistaminico) :- sintomaEnfermedad(X), tipoEnfermedad(X,alergia). /*sintomaEnfermedad(rinitis).*/
componenteEnfermedad(infeccion, antibiotico) :- sintomaEnfermedad(X), tipoEnfermedad(X,infeccion).

sintomaComponente(analgesico):- sintoma(fiebre).
sintomaComponente(analgesico):- sintoma('dolor de cabeza').
sintomaComponente(analgesico):- sintoma('dolor de garganta').
sintomaComponente(antihistaminico):- sintoma('congestion nasal').
sintomaComponente(antihistaminico):- sintoma('congestion ocular').

recetar(enfermedad, medicamento):- tipoEnfermedad(enfermedad,X), componenteEnfermedad(X,Y), tipoComponente(Z,Y), contiene(medicamento,Z).

diagnosticar():- sintomaEnfermedad(X),recetar(X,Y),write('recetamos el medicamento: '), nl, write(Y).
