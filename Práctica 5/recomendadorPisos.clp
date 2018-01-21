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
			
	(slot metros
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