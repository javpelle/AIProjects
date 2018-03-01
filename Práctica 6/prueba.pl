sintoma(nauseas).
sintoma(vomito).
sintoma('picor nariz').
sintoma('congestion nasal').
sintoma(fiebre).
sintoma('dolor de cabeza').
sintoma('rigidez en la nuca').
sintoma(malestar).

alergico(ampicilina).
alergico(amoxicilina).

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

recetar(Enfermedad, Medicamento):- componenteEnfermedad(Enfermedad,A),tipoComponente(Z,A), \+alergico(Z), contiene(Medicamento,Z).

medicamento():- sintomaEnfermedad(X),!,recetar(X,Y),write('Te recetamos el medicamento: '), nl, write(Y).
medicamento():- write('Lo sentimos, no se ha podido diagnosticar. Te recomendamos que vaya al hospital.').

aliviar():- write('Para aliviar sus sintomas, puedes tomar: '), sintomaComponente(X), tipoComponente(Z, X), contiene(Medicamento, Z), write(Medicamento), nl.

diagnosticar():- medicamento(), nl, aliviar().
