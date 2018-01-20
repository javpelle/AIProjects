(deffacts inicio
    (dd juan maria rosa m)
    (dd juan maria luis h)
    (dd jose laura pilar m)
    (dd luis pilar miguel h)
    (dd miguel isabel jaime h)
	(dd pedro rosa pablo h)
	(dd pedro rosa ana m))

(defrule padre
    (dd ?x ? ?y ?)
    =>
    (assert (padre ?x ?y)))
	
; Aqui empieza nuestro codigo

(defrule madre
    (dd ? ?x ?y ?)
    =>
    (assert (madre ?x ?y)))
	
(defrule hijo
    (dd ?x ?y ?z h)
    =>
    (assert (hijo ?z ?x))
	(assert (hijo ?z ?y)))
	
(defrule hija
    (dd ?x ?y ?z m)	
    =>
    (assert (hija ?z ?x))
	(assert (hija ?z ?y)))
	
(defrule hermano
    (dd ?x ?y ?z h)
	(dd ?x ?y ?u ?)
	(test (neq ?z ?u))
    =>
    (assert (hermano ?z ?u)))
	
(defrule hermana
    (dd ?x ?y ?z m)
	(dd ?x ?y ?u ?)
	(test (neq ?z ?u))
    =>
    (assert (hermana ?z ?u)))
	
(defrule abuelop
    (padre ?x ?y)
	(padre ?y ?z)
    =>
    (assert (abuelo ?x ?z)))
	
(defrule abuelom
    (padre ?x ?y)
	(madre ?y ?z)
    =>
    (assert (abuelo ?x ?z)))
	
(defrule abuelap
    (madre ?x ?y)
	(padre ?y ?z)
    =>
    (assert (abuela ?x ?z)))
	
(defrule abuelam
    (madre ?x ?y)
	(madre ?y ?z)
    =>
    (assert (abuela ?x ?z)))

; x primo de y si y es hij@ de su tio de sangre
(defrule primop
    (hijo ?x ?y)
	(hermano ?z ?y)
	(padre ?z ?u)
    =>
    (assert (primo ?x ?u)))

; x primo de y si y es hij@ de su tia de sangre	
(defrule primom
    (hijo ?x ?y)
	(hermana ?z ?y)
	(madre ?z ?u)
    =>
    (assert (primo ?x ?u)))

; x prima de y si y es hij@ de su tio de sangre
(defrule primap
    (hija ?x ?y)
	(hermano ?z ?y)
	(padre ?z ?u)
    =>
    (assert (prima ?x ?u)))

; x prima de y si y es hij@ de su tia de sangre
(defrule primam
    (hija ?x ?y)
	(hermana ?z ?y)
	(madre ?z ?u)
    =>
    (assert (primo ?x ?u)))
	
(defrule ascendientepadre
    (padre ?x ?y)
    =>
    (assert (ascendiente ?x ?y)))
	
(defrule ascendientemadre
    (madre ?x ?y)
    =>
    (assert (ascendiente ?x ?y)))
	
(defrule ascendientehombre
    (padre ?x ?y)
	(ascendiente ?y ?z)
    =>
    (assert (ascendiente ?x ?z)))
	
(defrule ascendientemujer
    (madre ?x ?y)
    (ascendiente ?y ?z)
    =>
    (assert (ascendiente ?x ?z)))