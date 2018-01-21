;------------------------------------
;----Reconmendador de Pisos----------
;------------------------------------


;-----Modulo MAIN-----

(defmodule MAIN (export ?ALL))

;--------------------
;-----PLANTILLAS-----
;--------------------

;-----Plantilla para pisos-----
(deftemplate MAIN::piso
	(slot transaccion
			(type SYMBOL)
			(default venta)
			(allowed-symbols venta alquiler cualquiera))
	(slot tipo
			(type SYMBOL)
			(default piso)
			(allowed-symbols piso chalet habitacion))
	(slot zona
			(type SYMBOL)
			(default extrarradio)
			(allowed-symbols centro rural costa extrarradio))
	(slot habitaciones
			(type INTEGER)
			(default 2))
	(slot metros	
			(type INTEGER)
			(default 60))
	(slot precio	
			(type INTEGER)
			(default 60000))
	(slot escaleras	
		(type SYMBOL)
		(default no)
		(allowed-symbols si no ascensor)) ;Suponemos que si tienen ascensor, hay escaleras también
	(slot garaje
		(type SYMBOL)
		(default no)
		(allowed-symbols si no))
	(slot habitaciones-dobles	;De entre el total de habitaciones
		(type INTEGER)
		(default 0))
	(slot jardin
		(type SYMBOL)
		(default no)
		(allowed-symbols si no))
        (slot id
                (type INTEGER)
                (default 0)))

;-----Plantilla para el cliente (aunque solo hay uno)-----
(deftemplate MAIN::cliente
	(slot ocupacion
		(type SYMBOL)
		(default trabajador)
		(allowed-symbols trabajador estudiante turista))
	(slot ocupantes
		(type INTEGER)
		(default 1))
	(slot parejas
		(type INTEGER)
		(default 0))
	(slot familiares
		(type INTEGER)
		(default 0))
	(slot amigos 
		(type INTEGER)
		(default 0))
	(slot mascotas
		(type INTEGER)
		(default 0))
	(slot discapacidad
		(type SYMBOL)
		(default no)
		(allowed-symbols si no))
	(slot precio-maximo
			(type INTEGER)
			(default 100000)))
			
;-----Plantilla para recomendaciones-----
;Contiene el id del piso recomendado junto con una puntuación que se usará más adelante para el ranking
(deftemplate MAIN::recomendar
	(slot id
                (type INTEGER)
                (default 0))
        (slot puntuacion
                (type INTEGER)
                (default 0)))

;------------------------------
;-----CONOCIMIENTO FACTUAL-----
;------------------------------

;-----Conocimiento sobre pisos-----
(deffacts MAIN::pisos
	(piso (transaccion venta) (tipo piso) (zona centro) (habitaciones 2) (precio 240000) (escaleras ascensor) (garaje si) (habitaciones-dobles 1) (id 1))
	(piso (transaccion venta) (tipo piso) (zona costa) (habitaciones 3) (metros 100) (precio 300000) (escaleras si) (habitaciones-dobles 1) (jardin si) (id 2))
	(piso (transaccion venta) (tipo chalet) (zona extrarradio) (habitaciones 4) (metros 200) (precio 400000) (escaleras si) (garaje si) (habitaciones-dobles 2) (jardin si) (id 3))
	(piso (transaccion venta) (tipo chalet) (zona rural) (habitaciones 5) (metros 500) (precio 750000) (garaje si) (habitaciones-dobles 2) (jardin si) (id 4))
	(piso (transaccion alquiler) (tipo habitacion) (zona costa) (habitaciones 1) (metros 15) (precio 375) (escaleras si) (id 5))
	(piso (transaccion alquiler) (tipo piso) (zona centro) (habitaciones 3) (metros 80) (precio 1200) (escaleras ascensor) (garaje si) (habitaciones-dobles 1) (jardin si) (id 6))
	(piso (transaccion alquiler) (tipo piso) (zona costa) (habitaciones 2) (metros 70) (precio 1400) (escaleras ascensor) (habitaciones-dobles 1) (id 7))
	(piso (transaccion alquiler) (tipo chalet) (zona rural) (habitaciones 4) (metros 250) (precio 2500) (escaleras si) (garaje si) (habitaciones-dobles 2) (id 8))
	(piso (transaccion alquiler)(zona centro) (habitaciones 2) (precio 900) (escaleras si) (garaje si) (id 9))
	(piso (transaccion venta) (zona centro) (habitaciones 3) (metros 80) (precio 320000) (escaleras ascensor) (habitaciones-dobles 1) (jardin si) (id 10)))


(defrule MAIN::inicio
	(declare (salience 10000))
	=>
	(printout t "Escribe tu nombre y pulsa Enter> ")
	(bind ?nombre (read))
	(printout t crlf "Bienvenido a este maginifico recomendador de Pisos, " ?nombre "." crlf)
	(printout t "Le ayudaremos a escoger su piso, sea para unas vacaciones, una mudanza, o una residencia temporal." crlf)
	(printout t "Le pediremos paciencia y un poco de información personal para poder darle, no solo lo que quiere, sino también lo que necesita." crlf)
	(printout t "Dicho esto, comencemos: " crlf)
	(focus INTERVIEW RECOMMEND REPORT))

;-----Modulo INTERVIEW-----

(defmodule INTERVIEW (import MAIN ?ALL))

(deffunction INTERVIEW::testOc (?oc)
	(if (not (or (or (eq ?oc trabajador) (eq ?oc turista)) (eq ?oc estudiante))) then (bind ?oc trabajador))
	?oc)

(deffunction INTERVIEW::testNumPositive (?num)
	;(if (not (eq ?num NUMBER)) then (bind ?num 0))
	?num)
	
(deffunction INTERVIEW::testDis (?dis)
	(if (not (or (eq ?dis si) (eq ?dis no))) then (bind ?dis no))
	?dis)
	
(defrule INTERVIEW::entrevista
	=>
	(printout t "La respuesta de las preguntas, debe ser una de las opciones propuestas, a no ser que se diga lo contrario." crlf)
	(printout t "Escribe tu ocupacion (opciones: trabajador estudiante turista): ")
	(bind ?oc (testOc (read)))
	(printout t "Escribe la cantidad de ocupantes de la vivienda: ")
	(bind ?ocup (testNumPositive (read)))
	(printout t "Escribe la cantidad de parejas (persona con una relacion sentimal, se les asignara una habitacion con cama doble): ")
	(bind ?par (testNumPositive (read)))
	(printout t "Escribe la cantidad de familiares (personas fuera de la inclusion anterior, y con relacion familiar): ")
	(bind ?fami (testNumPositive (read)))
	(printout t "Escribe la cantidad de amigos (personas fuera de las inclusion anteriores): ")
	(bind ?ami (testNumPositive (read)))
	(printout t "Escribe la cantidad de mascotas que tienes, sean mamiferos, aves o peces: ")
	(bind ?mas (testNumPositive (read)))
	(printout t "Indica si usted o alguien padece cualquier discapacidad, sea mental o fisica (opciones: si no): ")
	(bind ?dis (testDis (read)))
	(printout t "Indique su presupuesto: ")
	(bind ?pr (testNumPositive (read)))
	(assert (cliente (ocupacion ?oc) (ocupantes ?ocup) (parejas ?par) (familiares ?fami) (amigos ?ami) (mascotas ?mas) (discapacidad ?dis) (precio-maximo ?pr)))
	)
	
;-----Modulo RECOMMEND-----

(defmodule RECOMMEND (import MAIN ?ALL))

;----------------------------------
;-----Reglas de Recomendacion------
;----------------------------------

;Las puntuaciones están inspiradas en el clásico $/m2
;Puede que hubiera sido bueno hacer una deffunction específica para las puntuaciones,
;no obstante, por flexibilidad no la definimos, ya que un podría querer potenciar unas
;cosas en el caso de los alquileres y otras en el caso de las ventas (por ejemplo).

;Si está solo, es turista, el piso es para alquilar con 1 o 2 habitaciones y se ajusta el precio, se recomienda.
(defrule RECOMMEND::recom-Piso1
	(cliente (ocupacion turista) (ocupantes 1) (precio-maximo ?prMax))
	(piso (transaccion alquiler) (habitaciones ?hab) (precio ?pr) (id ?idPiso))
	(test (< ?hab 3))
	(test (< ?pr ?prMax))
        =>
	(assert (recomendar (id ?idPiso) (puntuacion (div ?pr ?hab)))))

;Si es trabajador, solo y el piso es para comprar, se recomienda.
(defrule RECOMMEND::recom-Piso2
        (cliente (ocupacion trabajador) (ocupantes 1) (precio-maximo ?prMax))
        (piso (transaccion venta) (habitaciones ?hab) (precio ?pr) (id ?idPiso))
        (test (< ?hab 3)) ;El y una habitacion extra
        (test (< ?pr ?prMax))
        =>
        (assert (recomendar (id ?idPiso) (puntuacion (div ?pr ?hab)))))

;Si es familiar, turista, el piso tiene varias habitaciones y es para alquilar, se recomienda.
(defrule RECOMMEND::recom-Piso3
        (cliente (ocupacion turista) (ocupantes ?ocup) (parejas ?par) (precio-maximo ?prMax))
        (piso (transaccion alquiler) (habitaciones ?hab) (habitaciones-dobles ?dob) (precio ?pr) (id ?idPiso))
        (test (< 0 ?par))
        (test (< ?par ?dob))
        (test (< (- ?ocup ?par) (- ?hab ?dob)))
        (test (< ?pr ?prMax))
        =>
        (assert (recomendar (id ?idPiso) (puntuacion (div ?pr ?hab)))))

;Si es trabajador y el piso está en venta, se recomienda
(defrule RECOMMEND::recom-Piso4
        (cliente (ocupacion trabajador) (precio-maximo ?prMax) (ocupantes ?ocup) (parejas ?par))
        (piso (transaccion venta) (habitaciones ?hab) (habitaciones-dobles ?dob) (precio ?pr) (id ?idPiso))
        (test (< 0 ?par))
        (test (< ?par ?dob))
        (test (< (- ?ocup ?par) (- ?hab ?dob)))
        (test (< ?pr ?prMax))
        =>
        (assert (recomendar (id ?idPiso) (puntuacion (div ?pr ?hab)))))		

(defrule RECOMMEND::recom-Piso5
        (cliente (ocupacion trabajador) (precio-maximo ?prMax) (ocupantes ?ocup) (parejas 0))
        (piso (transaccion venta) (habitaciones ?hab) (precio ?pr) (id ?idPiso))
        (test (< ?ocup ?hab))
        (test (< ?pr ?prMax))
        =>
        (assert (recomendar (id ?idPiso) (puntuacion (div ?pr ?hab)))))
		
;Familiar, trabajador chalet con varias habitciones, extrradio venta, se recomienda (cambio de vivienda a zona mas tranquila)
(defrule RECOMMEND::recom-Piso6
        (cliente (ocupacion trabajador) (precio-maximo ?prMax) (ocupantes ?ocup) (parejas 1))
        (piso (transaccion venta) (tipo chalet) (zona extrarradio)(habitaciones ?hab) (habitaciones-dobles ?dob) (precio ?pr) (id ?idPiso))
        (test (< 0 ?dob))
        (test (< (- ?ocup 1) (- ?hab 1)))
        (test (< ?pr ?prMax))
        =>
        (assert (recomendar (id ?idPiso) (puntuacion (div ?pr ?hab)))))

;Alquiler, habitacion, centrico,  turista, solo o pareja, se recomienda.
(defrule RECOMMEND::recom-Piso7
        (cliente (ocupacion turista) (ocupantes 1) (precio-maximo ?prMax))
        (piso (transaccion alquiler) (tipo habitacion) (zona centro)(precio ?pr) (id ?idPiso))
        (test (< ?pr ?prMax))
        =>
        (assert (recomendar (id ?idPiso) (puntuacion ?pr))))

(defrule RECOMMEND::recom-Piso8
        (cliente (ocupacion turista) (ocupantes 2) (precio-maximo ?prMax) (parejas 1))
        (piso (transaccion alquiler) (tipo habitacion) (zona centro)(precio ?pr) (id ?idPiso))
        (test (< ?pr ?prMax))
        =>
        (assert (recomendar (id ?idPiso) (puntuacion ?pr))))
		
;-----Modulo REPORT-----

(defmodule REPORT (import MAIN ?ALL))

;funcion de comparacion de hechos de recomendación (para poder usar sort)

(defrule REPORT::muestreo-recomendaciones-segun-afinidad
  ?r1 <- (recomendar (id ?id1) (puntuacion ?p1))
  (not (recomendar (id ?id2) (puntuacion ?p2&:(> ?p1 ?p2))))
  (piso (transaccion ?trans) (tipo ?ti) (zona ?zo) (habitaciones ?hab) (metros ?mr)(precio ?pr) (escaleras ?esc) (garaje ?gar) (habitaciones-dobles ?habdob) (jardin ?jar) (id ?id1))
  =>
  (printout t crlf)
  (printout t "Piso a recomendar es el: " ?id1 "." crlf)
  (printout t "Con una puntuacion de: "  ?p1  " y un precio de " ?pr "euros." crlf)
  (printout t "Se trata de la/el " ?trans " de un/a " ?ti "." crlf)
  (printout t "Esta en el/la " ?zo "." crlf)
  (printout t "Tiene " ?mr " metros cuadrados, con " ?hab " habitacion/es de las cuales " ?habdob " son habitaciones dobles." crlf)
  (printout t "Y para terminar, " ?esc " tiene escaleras, " ?gar " tiene garaje y " ?jar " tiene jardin" crlf)
  (retract ?r1))

		
		