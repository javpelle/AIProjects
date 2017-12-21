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