;--- Javier Pellejero Ortega & Zhaoyan Ni---

(mapclass Cliente)

(deftemplate Cliente
   (slot nombre_cliente)
   (slot num_coches)
   (slot num_habitaciones)
   (slot presupuesto_maximo)
   (slot tipo_vivienda)
   (multislot viv_rec_min)
   (multislot viviendas_recomendadas)
)


(mapclass Registro)

(deftemplate Registro
   (slot distrito)
   (slot habitaciones)
   (slot inmobiliaria)
   (slot pl_garaje)
   (slot precio)
   (slot superficie)
   (slot tipo)
)

;---- Lo usamos para asignar perfiles a clientes
(deftemplate perfilCliente
	(slot perfil
		(type SYMBOL))
		
	(slot cliente
		(type STRING))
)


;---- Lo usamos para saber que viviendas con requisitos minimos hemos ya recomendado al cliente
;---- No hemos conseguido que la función member$ tenga un correcto funcionamiento, así que hemos
;---- optado por esta opción. Tiene un problema y es que cada vez que ejecutemos las reglas JESS
;---- desde PROTÉGÉ se incluirán las viviendas a recomendar  aunque ya se haya hecho en otra ejecución
;---- quedando así duplicadas.
(deftemplate yaAsignados
	(slot registro
		(type OBJECT))
		
	(slot cliente
		(type STRING))
)

;---- Misma función que la anterior pero para Viviendas Recomendadas que se ajustan "BIEN" al Cliente
(deftemplate yaAsignadosRecomendados
	(slot registro
		(type OBJECT))
		
	(slot cliente
		(type STRING))
)

 ;---- Asignamos a los clientes el perfil TRABAJO si buscan una vivienda para trabajo
(defrule clientesTrabajo
	(declare (salience 10000))
	(object (is-a Cliente) (OBJECT ?r0) (tipo_vivienda trabajo)(nombre_cliente ?name))
=> 
	(assert (perfilCliente (perfil trabajo) (cliente ?name)))
 )
 
 ;---- Asignamos a los clientes el perfil ESTUDIO si buscan una vivienda para estudios
(defrule clientesEstudio
	(declare (salience 10000))
	(object (is-a Cliente) (OBJECT ?r0) (tipo_vivienda estudios)(nombre_cliente ?name))
=> 
	(assert (perfilCliente (perfil estudios) (cliente ?name)))
 )
 
  ;---- Asignamos a los clientes el perfil FAMILIAR si precisan entre 1 y 3 habitaciones
(defrule clientesFamiliar
	(declare (salience 10000))
	(object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(num_habitaciones ?n))
	(test (> ?n 1))
	(test (< ?n 4))
=> 
	(assert (perfilCliente (perfil familiar) (cliente ?name)))
 )
 
 ;---- Asignamos a los clientes el perfil FAMILIA NUMEROSA si precisan 4 o más habitaciones
(defrule clientesFamiliaNumerosa
	(declare (salience 10000))
	(object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(num_habitaciones ?n))
	(test (>= ?n 4))
=> 
	(assert (perfilCliente (perfil familiaNumerosa) (cliente ?name)))
 )
 
  ;---- Asignamos a los clientes de perfil TRABAJO las viviendas de tipo PISO con 2 o menos habitaciones
 (defrule viviendaTrabajo
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name))
   (object (is-a Registro) (OBJECT ?r1) (habitaciones ?h) (tipo Piso))
   (not(yaAsignados (registro ?r1) (cliente ?name)))
   (perfilCliente (perfil trabajo) (cliente ?name))
   (test (<= ?h 2))
   => 
   (slot-insert$ ?r0 viv_rec_min 1 ?r1)
   (assert (yaAsignados (registro ?r1) (cliente ?name)))
 )

 ;---- Asignamos a los clientes de perfil ESTUDIOS las viviendas de tipo ESTUDIO
  (defrule viviendaEstudio
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name))
   (object (is-a Registro) (OBJECT ?r1) (tipo Estudio))
   (not(yaAsignados (registro ?r1) (cliente ?name)))
   (perfilCliente (perfil estudios) (cliente ?name))
   => 
   (slot-insert$ ?r0 viv_rec_min 1 ?r1)
   (assert (yaAsignados (registro ?r1) (cliente ?name)))
 )
 
 ;---- Asignamos a los clientes de perfil FAMILIAR las casas de CUALQUIER tipo con 2 o más habitaciones
 (defrule viviendaFamiliar
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name))
   (object (is-a Registro) (OBJECT ?r1) (habitaciones ?h) )
   (not(yaAsignados (registro ?r1) (cliente ?name)))
   (perfilCliente (perfil familiar) (cliente ?name))
   (test (>= ?h 2))
   => 
   (slot-insert$ ?r0 viv_rec_min 1 ?r1)
   (assert (yaAsignados (registro ?r1) (cliente ?name)))
 )
 
 ;---- Asignamos a los clientes de perfil FAMILIA NUMEROSA las casas de tipo CHALET con 4 o más habitaciones
 (defrule viviendaFamiliarNumerosa
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name))
   (object (is-a Registro) (OBJECT ?r1) (habitaciones ?h)(tipo Chalet) )
   (not(yaAsignados (registro ?r1) (cliente ?name)))
   (perfilCliente (perfil familiaNumerosa) (cliente ?name))
   (test (>= ?h 4))
   =>
   (slot-insert$ ?r0 viv_rec_min 1 ?r1)
   (assert (yaAsignados (registro ?r1) (cliente ?name)))
 )
 
 ;---- De entre las viviendas que cumplen con el perfil del cliente recomendamos las que se ajustan al presupuesto, a las plazas de garaje y que tengas las mismas habitaciones que el cliente solicita
 (defrule viviendaPro
   (yaAsignados (registro ?r1) (cliente ?name))
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(num_habitaciones ?h) (presupuesto_maximo ?pc) (num_coches ?cc))
   (object (is-a Registro) (OBJECT ?r1) (habitaciones ?h) (precio ?pr)(pl_garaje ?cr))
   (not(yaAsignadosRecomendados (registro ?r1) (cliente ?name)))
   (test(<= ?pr ?pc))
   (test(<= ?cc ?cr))
   =>
   (slot-insert$ ?r0 viviendas_recomendadas 1 ?r1)
   (assert (yaAsignadosRecomendados (registro ?r1) (cliente ?name)))
 )
 
 

(reset)
(run)
