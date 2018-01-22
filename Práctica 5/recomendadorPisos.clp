;--- MODULO PRINCIPAL ---

(defmodule MAIN (export ?ALL))

;--INFORMACION PISO--

(deftemplate MAIN::piso
	(slot contrato
		(type SYMBOL)
		(default venta)
		(allowed-symbols venta alquiler))
	
	(slot vivienda
		(type SYMBOL)
		(default una-planta)
		(allowed-symbols una-planta bajo atico duplex estudio))
			
	(slot planta
		(type INTEGER)
		(default 0))			
			
	(slot habitaciones
		(type INTEGER)
		(default 3))
			
	(slot ascensor
		(type SYMBOL)
		(default si)
		(allowed-symbols si no))
		
	(slot plazas-garaje
		(type INTEGER)
		(default 0))
			
	(slot superficie
		(type INTEGER)
		(default 40))
			
	(slot precio	
		(type INTEGER)
		(default 140000))
		
    (slot identificador
        (type INTEGER)
        (default 0))
)


;--INFORMACION USUARIO--

(deftemplate MAIN::usuario
	(slot motivo
		(type SYMBOL)
		(default trabajo)
		(allowed-symbols trabajo estudios turismo))
		
	(slot pareja
		(type SYMBOL)
		(default no)
		(allowed-symbols si no))
		
	(slot huespedes
		(type INTEGER)
		(default 0))
		
	(slot anciano
		(type SYMBOL)
		(default no)
		(allowed-symbols si no))
		
	(slot vertigo
		(type SYMBOL)
		(default no)
		(allowed-symbols si no))
	
	(slot coches
		(type INTEGER)
		(default 0))
		
	(slot presupuesto
		(type INTEGER)
		(default 100000))
)


;--INFORMACION PUNTUACION--

(deftemplate MAIN::puntuacion
	(slot identificador
		(type INTEGER)
		(default 0))
		
	(slot score
		(type INTEGER)
		(default -1))
)


;--PISOS DISPONIBLES--

(deffacts MAIN::pisos
	(piso (contrato venta) (vivienda una-planta) (planta 3) (habitaciones 2)  (ascensor si) (plazas-garaje 1) (superficie 40) (precio 175000) (identificador 1))
	(piso (contrato venta) (vivienda una-planta) (planta 2) (habitaciones 3) (ascensor no) (plazas-garaje 0) (superficie 40) (precio 190000) (identificador 2))
	(piso (contrato venta) (vivienda una-planta) (planta 7) (habitaciones 4) (ascensor si) (plazas-garaje 2) (superficie 70) (precio 240000) (identificador 3))
	(piso (contrato alquiler) (vivienda una-planta) (planta 4) (habitaciones 5) (ascensor si) (plazas-garaje 0) (superficie 70) (precio 1350) (identificador 4))
	(piso (contrato alquiler) (vivienda duplex) (planta 6) (habitaciones 5) (ascensor no) (plazas-garaje 0) (superficie 75) (precio 1400) (identificador 5))
	(piso (contrato venta) (vivienda duplex) (planta 1) (habitaciones 3) (ascensor si) (plazas-garaje 2) (superficie 50) (precio 215000) (identificador 6))
	(piso (contrato alquiler) (vivienda bajo) (planta 0) (habitaciones 2) (ascensor si) (plazas-garaje 0) (superficie 40) (precio 195000) (identificador 7))
	(piso (contrato alquiler) (vivienda bajo) (planta 0) (habitaciones 4) (ascensor si) (plazas-garaje 1) (superficie 65) (precio 950) (identificador 8))
	(piso (contrato alquiler) (vivienda atico) (planta 8) (habitaciones 2) (ascensor si) (plazas-garaje 1) (superficie 50) (precio 250) (identificador 9))
	(piso (contrato venta) (vivienda atico) (planta 6) (habitaciones 3) (ascensor si) (plazas-garaje 0) (superficie 70) (precio 210000) (identificador 10))
	(piso (contrato alquiler) (vivienda estudio) (planta 3) (habitaciones 1) (ascensor si) (plazas-garaje 0) (superficie 15) (precio 400) (identificador 11))
)
	
;--FUNCION MAIN--

(defrule MAIN::start
	(declare (salience 10000))
	=>
	(printout t "Escribe tu nombre y presiona Enter> ")
	(bind ?name (read))
	(printout t crlf "**********************************" crlf)
	(printout t " Hola, " ?name "." crlf)
	(printout t " Bienvenido a tu recomendador de compra y alquiler de pisos." crlf)
	(printout t " Por favor, responde las preguntas y" crlf)
	(printout t " te dire que pisos" crlf)
	(printout t " son los adecuados para tu vida." crlf)
	(printout t "**********************************" crlf crlf)
	(focus INTERVIEW RECOMMEND REPORT)
)


;---MODULO ENTREVISTA---

(defmodule INTERVIEW (import MAIN ?ALL)(export ?ALL))

(defrule INTERVIEW::entrevista
	=>
	(printout t "Responde a cada pregunta con una de las respuestas proporcionadas." crlf)
	(printout t "Que te motiva a buscar una nueva vivienda? (trabajo turismo estudios): ")
	(bind ?motiv (read))
	(printout t "cuantas personas viviran en la casa (incluyendote a ti mismo)?: ")
	(bind ?hij (read))
	(printout t "Vivira tu pareja, si la tienes, contigo? (si no): ")
	(bind ?parej (read))
	(printout t "Alguno de los ocupantes de la casa puede ser considerado una persona mayor? (si no): ")
	(bind ?mayor(read))
	(printout t "Alguno de los ocupantes de la casa padece vertigo o existe alguna razon para evitar las plantas altas? (si no):  ")
	(bind ?vertig (read))
	(printout t "Introduce el numero de coches que tienes: ")
	(bind ?coch (read))
	(printout t "Cual es su presupuesto maximo?: ")
	(bind ?dineros(read))
	(assert (usuario (motivo ?motiv) (pareja ?parej) (huespedes ?hij) (anciano ?mayor) (vertigo ?vertig) (coches ?coch) (presupuesto ?dineros)))
)


;---MODULO RECOMENDACION---

(defmodule RECOMMEND (import MAIN ?ALL))

;--- Notas---
; Si hay un anciano, no se recomendará ningún piso sin ascensor.
; Si hay un anciano, o alguien padece vertigo (o similar) se asignará maximo una planta 3 (aunque tenga ascensor)
; Si se requieren plazas de garaje y no las tiene, supondrá una menor puntuación, pero no un descarte inmediato
; Los mejores precios por metro cuadrado tendrán mayor puntuación.
; pisos con 2 habitaciones más de las necesarias o con 1 menos no son recomendadas.
; Se entiende que la pareja duerme con el usuario y por lo tanto solo es necesaria una habitación para ambos
; Se habla de presupuesto 'máximo' así que se entiende que en ningún caso se puede superar
; Para estudiantes solo se recomendará alquiler, para turismo alquiler y para trabajo venta o alquiler

(deffunction  RECOMMEND::calculaHabitaciones (?pareja ?huespedes)
	(if (eq ?pareja si) then
		(- ?huespedes 1)
	else
		(* ?huespedes 1))
)

(deffunction  RECOMMEND::asignaPuntuacion (?s ?prec ?gar ?coc ?extra)
	(if (and (> ?coc 0) (>= ?gar ?coc) ) then
		(+ (+ (* ?coc 3000) (div ?s ?prec)) ?extra)
	else
		(div ?s ?prec))
)

(deffunction  RECOMMEND::ancianoAscensor (?mayor ?ascen)
	(if (and (eq ?mayor si) (eq ?ascen no)) then (+ 0 0) else (+ 1 0)))

(deffunction  RECOMMEND::vertigos (?vert ?plant)
	(if (and (eq ?vert si) (> ?plant 3)) then (+ 0 0) else (+ 1 0)))

;---Estudiante
(defrule RECOMMEND::estudiante-estudio
	(usuario (motivo estudios) (pareja ?par) (huespedes ?hue) (anciano ?mayor) (vertigo ?vertig) (coches ?coch)) (presupuesto ?limite)
	(piso (contrato alquiler) (vivienda estudio) (planta ?plant) (habitaciones ?hab) (ascensor ?as) (plazas-garaje ?g) (superficie ?s) (precio ?prec) (identificador ?idPiso))
	(test(eq (ancianoAscensor ?mayor ?as) 1))
	(test(eq (vertigos ?vertig ?plant) 1))
	(test (<= ?prec ?limite))
	(test(<= (calculaHabitaciones ?par ?hue) ?hab))
	(test(>= (+ (calculaHabitaciones ?par ?hue) 1) ?hab))
        =>
	(assert (puntuacion (identificador ?idPiso) (score (asignaPuntuacion ?s ?prec ?coch ?g 10000))))
)

(defrule RECOMMEND::estudiante-otro
	(usuario (motivo estudios) (pareja ?par) (huespedes ?hue) (anciano ?mayor) (vertigo ?vertig) (coches ?coch)) (presupuesto ?limite)
	(piso (contrato alquiler) (vivienda ?c) (planta ?plant) (habitaciones ?hab) (ascensor ?as) (plazas-garaje ?g) (superficie ?s) (precio ?prec) (identificador ?idPiso))
	(test(eq (ancianoAscensor ?mayor ?as) 1))
	(test(eq (vertigos ?vertig ?plant) 1))
	(test (<= ?prec ?limite))
	(test(not(eq ?c estudio)))
	(test(<= (calculaHabitaciones ?par ?hue) ?hab))
	(test(>= (+ (calculaHabitaciones ?par ?hue) 1) ?hab))
        =>
	(assert (puntuacion (identificador ?idPiso) (score (asignaPuntuacion ?s ?prec ?coch ?g 0))))
)

;--- Turista
(defrule RECOMMEND::turista
	(usuario (motivo turismo) (pareja ?par) (huespedes ?hue) (anciano ?mayor) (vertigo ?vertig) (coches ?coch)) (presupuesto ?limite)
	(piso (contrato alquiler) (planta ?plant) (habitaciones ?hab) (ascensor ?as) (plazas-garaje ?g) (superficie ?s) (precio ?prec) (identificador ?idPiso))
	(test(eq (ancianoAscensor ?mayor ?as) 1))
	(test(eq (vertigos ?vertig ?plant) 1))
	(test (<= ?prec ?limite))
	(test(<= (calculaHabitaciones ?par ?hue) ?hab))
	(test(>= (+ (calculaHabitaciones ?par ?hue) 1) ?hab))
        =>
	(assert (puntuacion (identificador ?idPiso) (score (asignaPuntuacion ?s ?prec ?coch ?g 0))))
)

;---Trabajo
(defrule RECOMMEND::trabajador
	(usuario (motivo trabajo) (pareja ?par) (huespedes ?hue) (anciano ?mayor) (vertigo ?vertig) (coches ?coch)) (presupuesto ?limite)
	(piso (planta ?plant) (habitaciones ?hab) (ascensor ?as) (plazas-garaje ?g) (superficie ?s) (precio ?prec) (identificador ?idPiso))
	(test(eq (ancianoAscensor ?mayor ?as) 1))
	(test(eq (vertigos ?vertig ?plant) 1))
	(test (<= ?prec ?limite))
	(test(<= (calculaHabitaciones ?par ?hue) ?hab))
	(test(>= (+ (calculaHabitaciones ?par ?hue) 1) ?hab))
        =>
	(assert (puntuacion (identificador ?idPiso) (score (asignaPuntuacion ?s ?prec ?coch ?g 0))))
)




;-----MODULO REPORT-----

(defmodule REPORT (import MAIN ?ALL))