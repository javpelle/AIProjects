;--- MODULO PRINCIPAL ---

(defmodule MAIN (export ?ALL))

;--INFORMACION PISO--

(deftemplate MAIN::piso
	(slot contrato
		(type SYMBOL)
		(default venta)
		(allowed-symbols venta alquiler compartir todos))
	
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
			
	(slot banos
		(type INTEGER)
		(default 2))
			
	(slot ascensor
		(type SYMBOL)
		(default si)
		(allowed-symbols si no))
		
	(slot plazas-garaje
		(type Integer)
		(default 0))
		
	(slot comedor
		(type SYMBOL)
		(default si)
		(allowed-symbols si en-cocina no))
			
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
		
	(slot hijos-otros
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
		
	(slot puntuacion
		(type INTEGER)
		(default 0))
)


;--PISOS DISPONIBLES--

(deffacts MAIN::pisos
	(piso (contrato todos) (vivienda una-planta) (planta 3) (habitaciones 2) (banos 1) (ascensor si) (plazas-garaje 1) (comedor si) (superficie 40) (precio 175000) (identificador 1))
	(piso (contrato todos) (vivienda una-planta) (planta 2) (habitaciones 3) (banos 3) (ascensor no) (plazas-garaje 0) (comedor en-cocina) (superficie 40) (precio 190000) (identificador 2))
	(piso (contrato venta) (vivienda una-planta) (planta 7) (habitaciones 4) (banos 3) (ascensor si) (plazas-garaje 2) (comedor si) (superficie 70) (precio 240000) (identificador 3))
	(piso (contrato alquiler) (vivienda una-planta) (planta 4) (habitaciones 5) (banos 3) (ascensor si) (plazas-garaje 0) (comedor si) (superficie 70) (precio 1350) (identificador 4))
	(piso (contrato alquiler) (vivienda duplex) (planta 6) (habitaciones 5) (banos 4) (ascensor no) (plazas-garaje 0) (comedor si) (superficie 75) (precio 1400) (identificador 5))
	(piso (contrato venta) (vivienda duplex) (planta 1) (habitaciones 3) (banos 1) (ascensor si) (plazas-garaje 2) (comedor si) (superficie 50) (precio 215000) (identificador 6))
	(piso (contrato todos) (vivienda bajo) (planta 0) (habitaciones 2) (banos 2) (ascensor si) (plazas-garaje 0) (comedor en-cocina) (superficie 40) (precio 195000)) (identificador 7))
	(piso (contrato alquiler) (vivienda bajo) (planta 0) (habitaciones 4) (banos 3) (ascensor si) (plazas-garaje 1) (comedor si) (superficie 65) (precio 950) (identificador 8))
	(piso (contrato compartir) (vivienda atico) (planta 8) (habitaciones 2) (banos 2) (ascensor si) (plazas-garaje 1) (comedor en-cocina) (superficie 50) (precio 250) (identificador 9))
	(piso (contrato venta) (vivienda atico) (planta 6) (habitaciones 3) (banos 3) (ascensor si) (plazas-garaje 0) (comedor si) (superficie 70) (precio 210000) (identificador 10)))
	(piso (contrato alquiler) (vivienda estudio) (planta 3) (habitaciones 1) (banos 1) (ascensor si) (plazas-garaje 0) (comedor no) (superficie 15) (precio 400) (identificador 11)))
	
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
	(printout t "Vivira tu pareja, si la tienes, contigo? (si no): ")
	(bind ?parej (read))
	(printout t "Además de ti (y tú pareja si es el caso), cuantos hijos u otras personas viviran en la casa?: ")
	(bind ?hij (read))
	(printout t "Alguno de los ocupantes de la casa puede ser considerado una persona mayor? (si no): ")
	(bind ?mayor (testNumPositive (read)))
	(printout t "Alguno de los ocupantes de la casa padece vertigo o existe alguna razon para evitar las plantas altas? (si no):  ")
	(bind ?vertig (testNumPositive (read)))
	(printout t "Introduce el numero de coches que tienes: ")
	(bind ?coch (testDis (read)))
	(printout t "Cual es su presupuesto maximo?: ")
	(bind ?dineros (testNumPositive (read)))
	(assert (cliente (motivo ?motiv) (pareja ?parej) (hijos-otros ?hij) (anciano ?mayor) (vertigo ?vertig) (coches ?coch) (presupuesto ?dineros)))
)


;---MODULO RECOMENDACION---

(defmodule RECOMMEND (import MAIN ?ALL))




