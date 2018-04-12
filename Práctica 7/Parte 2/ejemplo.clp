(mapclass Inmobiliaria)

(deftemplate Inmobiliaria
   (slot nombre_inmo)
   (slot onLine)
   (slot viviendas_por_inmobiliaria))

(deffacts inicio
   (Inmobiliaria (nombre_inmo "a")(onLine TRUE))
   (Inmobiliaria (nombre_inmo "b")(onLine FALSE)))
   
(defrule cargar (Inmobiliaria (nombre_inmo ?m)(onLine ?mo)) => (make-instance of Inmobiliaria (nombre_inmo ?m)(onLine ?mo)))


(mapclass Cliente)

(deftemplate Cliente
   (slot necesario_accesibilidad)
   (slot nombre_cliente)
   (slot num_coches)
   (slot num_habitaciones)
   (slot presupuesto_maximo)
   (slot presupuesto_minimo)
   (slot tipo_vivienda)
   (slot viviendas_recomendadas))

(mapclass Registro)

(deftemplate Registro
   (slot distrito)
   (slot habitaciones)
   (slot inmobiliaria)
   (slot pl_garaje)
   (slot precio)
   (slot superficie)
)

(deffunction necesarioAscensor (?tipo ?necesario ?ascen ?planta)
	(if (and(and(and (eq ?necesario TRUE) (neq ?tipo chalet)) (neq ?planta bajo)) (eq ?ascen FALSE)) then (+ 0 0) else (+ 1 0)))



(defrule buscarVivienda 
	?r0<-(Cliente (nombre_cliente ?nombre) (necesario_accesibilidad ?necesario) (num_coches ?coche) (num_habitaciones ?num_hab) (presupuesto_maximo ?max) (tipo_vivienda ?tipo))
	?r1<-(Registro (habitaciones ?num_habita) (pl_garaje ?coche) (precio ?precio))
	(test(<= ?num_habita ?num_hab))
=>
	
	(slot-insert& ?r0 viviendas_recomendadas 1 ?r1)

)
(reset)
(run)
