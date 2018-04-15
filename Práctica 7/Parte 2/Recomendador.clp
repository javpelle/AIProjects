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

(deftemplate perfilCliente
	(slot perfil
		(type SYMBOL))
		
	(slot cliente
		(type STRING))
)

(defrule MAIN::clientesTrabajo
   (object (is-a Cliente) (OBJECT ?r0) (tipo_vivienda trabajo)(nombre_cliente ?name))
   => 
   (assert (perfilCliente (perfil trabajo) (cliente ?name)))
 )
 
(defrule MAIN::clientesEstudio
   (object (is-a Cliente) (OBJECT ?r0) (tipo_vivienda estudios)(nombre_cliente ?name))
   => 
   (assert (perfilCliente (perfil estudios) (cliente ?name)))
 )
 
(defrule MAIN::clientesFamiliar
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(num_habitaciones ?n))
   (test (> ?n 1))
   (test (< ?n 4))
   => 
   (assert (perfilCliente (perfil familiar) (cliente ?name)))
 )
 
(defrule MAIN::clientesFamiliaNumerosa
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(num_habitaciones ?n))
   (test (>= ?n 4))
   => 
   (assert (perfilCliente (perfil familiaNumerosa) (cliente ?name)))
 )
 
 (defrule MAIN::viviendaTrabajo
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(viv_rec_min $?list))
   (object (is-a Registro) (OBJECT ?r1) (habitaciones ?h) (tipo Piso))
   (test(not(member$ ?r1 ?list)))
   (perfilCliente (perfil trabajo) (cliente ?name))
   (test (<= ?h 2))
   => 
   (slot-insert$ ?r0 viv_rec_min 1 ?r1)
 )
 
  (defrule MAIN::viviendaEstudio
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(viv_rec_min $?list))
   (object (is-a Registro) (OBJECT ?r1) (tipo Estudio))
   (test(not(member$ ?r1 $?list)))
   (perfilCliente (perfil estudios) (cliente ?name))
   => 
   (printout t "regla")
   (slot-insert$ ?r0 viv_rec_min 1 ?r1)
 )
 
 (defrule MAIN::viviendaFamiliar
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(viv_rec_min ?list))
   (object (is-a Registro) (OBJECT ?r1) (habitaciones ?h) )
   (test(not(member$ ?r1 $?list)))
   (perfilCliente (perfil familiar) (cliente ?name))
   (test (>= ?h 3))
   => 
   (slot-insert$ ?r0 viv_rec_min 1 ?r1)
 )
 
 (defrule MAIN::viviendaFamiliarNumerosa
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(viv_rec_min $?list))
   (object (is-a Registro) (OBJECT ?r1) (habitaciones ?h)(tipo Chalet) )
   (test(not(member$ ?r1 ?list)))
   (perfilCliente (perfil familiar) (cliente ?name))
   (test (>= ?h 4))
   => 
   (slot-insert$ ?r0 viv_rec_min 1 ?r1)
 )
 
 (defrule MAIN::viviendaPro
   (object (is-a Cliente) (OBJECT ?r0) (nombre_cliente ?name)(viv_rec_min $?list) (num_habitaciones ?h) (presupuesto_maximo ?pc) (num_coches ?c)(viviendas_recomendadas $?listRec))
   (object (is-a Registro) (OBJECT ?r1) (habitaciones ?h) (tipo Piso) (precio ?pr)(pl_garaje ?c))
   (test(member$ ?r1 ?list))
   (test(<= ?pr ?pc))
   (test(not(member$ ?r1 ?listRec)))
   => 
   (slot-insert$ ?r0 viviendas_recomendadas 1 ?r1)
 )
 
 

(reset)
(run)
