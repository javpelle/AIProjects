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

sintomaEnfermedad(sintomas,rinitis) :- member ('picor nariz', sintomas), member ('congestion nasal', sintomas), member ('congestion ocular', sintomas)

recetar(enfermedad, medicamento):- tipoEnfermedad(enfermedad,X),
