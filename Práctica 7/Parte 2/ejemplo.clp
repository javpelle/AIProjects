// he añadido un campo nuevo: tipo_vivienda a la clase cliente
(mapclass Inmobiliaria)

(deftemplate Inmobiliaria
   (slot nombre_inmo)
   (slot onLine)
   (slot viviendas_por_inmobiliaria))

(mapclass Cliente)

(deftemplate Cliente
   (slot necesario_accesibilidad)
   (slot nombre_cliente)
   (slot num_coches)
   (slot num_habitaciones)
   (slot presupuesto_maximo)
   (slot presupuesto_minimo)
   (slot tipo_vivienda)
   (slot viviendas_recomendadas)
)

(mapclass Registro)

(deftemplate Registro
   (slot distrito)
   (slot habitaciones)
   (slot inmobiliaria)
   (slot pl_garaje)
   (slot precio)
   (slot superficie)
)

(mapclass Distrito)

(deftemplate Distrito
	(slot contaminacion)
	(slot criminalidad)
	(slot nomb_distr)
	(slot viviendas_por_distritos)
)

(mapclass Chalet)

(deftemplate Chalet
	(slot chimenea)
	(slot jardin)
	(slot tipo)
)	


(mapclass Estudios)

(deftemplate Estudios
	(slot ascensor)
	(slot cocina_indep)
	(slot planta)
	(slot tipo)
)

(mapclass Pisos)

(deftemplate Pisos
	(slot ascensor)
	(slot planta)
	(slot tipo)
)
	
//problema con la función member, si añado (test...(member...)), la funcion slot insert no inserta nada
//si no usas member, un mismo piso se inserta infinitas veces en el slot viviendas_recomendadas		

// esta regla busca las viviendas que satisfacen a las restricciones de cliente sin 
//ajustar a su perfil

(defrule buscarViviendaMinima
	?r0<-(object(is-a Cliente) (tipo_vivienda ?piso) (nombre_cliente ?nom) (num_habitaciones ?num_hab) (viviendas_recomendadas ?rec) (presupuesto_maximo ?max) (num_coches ?coche))
	?r1<-(object(is-a ?piso) (precio ?pre) (habitaciones ?num_habita) (pl_garaje ?coche))
	(test(<= ?num_hab ?num_habita))
	(test(<= ?pre ?max))
	(test(eq (member$ ?r1 ?rec) FALSE))
=>
	(slot-insert$ ?r0 viviendas_recomendadas 1 ?r1)
)
(reset)
(run)
