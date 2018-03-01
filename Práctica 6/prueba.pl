sintoma(nauseas).
sintoma(vomito).
sintoma('picor nariz').
sintoma('congestion nasal').
sintoma(fiebre).
sintoma('dolor de cabeza').
sintoma('rigidez en la nuca').
sintoma(malestar).

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
componenteEnfermedad(enfermedad,antihistaminico):- tipoEnfermedad(enfermedad, alergia).
componenteEnfermedad(enfermedad,antibiotico):- tipoEnfermedad(enfermedad, infeccion).

sintomaComponente(analgesico):- sintoma(fiebre).
sintomaComponente(analgesico):- sintoma('dolor de cabeza').
sintomaComponente(analgesico):- sintoma('dolor de garganta').
sintomaComponente(antihistaminico):- sintoma('congestion nasal').
sintomaComponente(antihistaminico):- sintoma('congestion ocular').

diagnosticar():- sintomaEnfermedad(X),!,write(X),componenteEnfermedad(X,A), write(A),tipoComponente(Z,A), write(Z), contiene(Y,Z),write('Te recetamos el medicamento: '), nl, write(Y).
diagnosticar():- write('caso de fallos.').
