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




//problema con la función member, si a?ado (test...(member...)), la funcion slot insert no inserta nada
//si no usas member, un mismo piso se inserta infinitas veces en el slot viviendas_recomendadas		

// esta regla busca las viviendas que satisfacen a las restricciones de cliente sin 
//ajustar a su perfil

(defrule buscarViviendaMinima
	?r0<-(object(is-a Cliente) (tipo_vivienda ?piso) (num_habitaciones ?num_hab) (presupuesto_maximo ?max) (viviendas_recomendadas ?rec) (num_coches ?coche))
	?r1<-(object(is-a Registro) (tipo ?piso) (precio ?pre) (habitaciones ?num_habita) (pl_garaje ?coche))
	(test(<= ?num_hab ?num_habita))
	(test(<= ?pre ?max))
	(test(not(member$ ?r1 ?rec)))
=>
	(printout t ?r1)
)

(reset)
(run)
