;; Module MAIN

(defmodule MAIN (export ?ALL))

(deftemplate MAIN::cliente
  (slot accion (type string) (allowed-strings comprar alquilar))
  (slot municipio (type string))
  (slot tipo-piso (type string) (allowed-strings vivienda "obra nueva" local garaje oficina trastero terreno) (default vivienda))
  (slot precio-minimo (type NUMBER) (default 0))
  (slot precio-maximo (type NUMBER) (default 4000000))
  (slot num-hab (type INTEGER) (default 0))
  (slot superficie (type NUMBER) (default 0)))

(deftemplate MAIN::piso
  (slot accion (type string) (allowed-strings vender alquilar))
  (slot municipio (type string))
  (slot direccion (type string))
  (slot tipo-piso (type string))
  (slot precio (type NUMBER))
  (slot num-hab (type INTEGER))
  (slot superficie (type NUMBER)))
  
(deftemplate MAIN::question
  (slot text)
  (slot type)
  (slot ident))

(deftemplate MAIN::ask
  (slot ident))

(deftemplate MAIN::answer
  (slot ident)
  (slot text))

(deftemplate MAIN::recommendation
  (slot form)
  (slot explanation))
  
(deffacts MAIN::question-data
  "The questions the system can ask."
  (question (ident accion) (type string)
            (text "¿Quieres comprar o alquilar pisos?"))
  (question (ident tipo-piso) (type string)
            (text "¿Qué tipo de pisos estás buscando? Elige entre: obra nueva,local,garaje,oficina,trastero y terreno "))
  (question (ident municipio) (type string)
            (text "¿En cuál municipio lo estás buscando?"))
  (question (ident precio-minimo) (type NUMBER)
            (text "¿Cuál es el precio mínimo aceptable?"))
  (question (ident precio-maximo) (type NUMBER)
            (text "¿Cuál es el precio máximo aceptable?"))
  (question (ident num-hab) (type INTEGER)
            (text "¿Cuántas habitaciones aceptas como mínimo?"))
  (question (ident superficie)(type NUMBER)
            (text "¿Cuál es la superficie mínima aceptable?"))
  )
  
(defrule MAIN::start
  (declare (salience 10000))
  =>

  (printout t "Introduce su nombre: ")
  (bind ?name (read))
  (printout t crlf "**********************************" crlf)
  (printout t " Hola, " ?name "." crlf)
  (printout t " Bienvenido al recomendador de pisos. " crlf)
  (printout t "**********************************" crlf crlf)
  (focus INTERVIEW RECOMMEND REPORT))
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module ask

;(defmodule ask)
(defmodule QUESTIONS (import MAIN ?ALL))

(deffunction QUESTIONS::is-of-type (?answer ?type)
  "comprueba si la respuesta tiene el tipo correcto"
  (if (eq ?type string) then
         (stringp ?answer)
   elif (eq ?type NUMBER) then 
         (numberp ?answer)
   else (integerp ?answer))))

(deffunction QUESTIONS::is-of-range (?answer ?type)
 "comprueba si el valor de la respuesta está dentro del rango"
 (if (eq ?type NUMBER) then
		(test (>= ?answer 0))
  else(if (eq ?type INTEGER) then
        (test (>= ?answer 0))
        else (> (str-length ?answer) 0)	)))

(deffunction QUESTIONS::ask-user (?question ?type)
  "Ask a question, and return the answer"
  (printout t ?question " ")
  (bind ?answer (read))
  (while (not (is-of-type ?answer ?type)) do
         (printout t ?question " ")
         (bind ?answer (read)))
  ?answer)


   
(defrule QUESTIONS::ask-question-by-id
  "Given the identifier of a question, ask it and assert the answer"
  
  (declare (auto-focus TRUE))
  (question (ident ?id) (text ?text) (type ?type))
  (not (answer (ident ?id)))
  ?ask <- (ask (ident ?id))
  =>
  (bind ?answer (ask-user ?text ?type))
  (assert (answer (ident ?id) (text ?answer)))
  (retract ?ask))

  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module interview
;(defmodule interview)

(defmodule INTERVIEW (import MAIN ?ALL)(export ?ALL))

(defrule INTERVIEW::request-accion
  (declare (salience 100))
  =>
  (assert (ask (ident accion))))

(defrule INTERVIEW::request-municipio
   (declare (salience 100))
  =>
  (assert (ask (ident municipio))))
  
(defrule INTERVIEW::request-tipo-piso
    (declare (salience 100))
  =>
    (assert (ask (iden tipo-piso))))
	
(defrule INTERVIEW::request-precio-minimo
    (declare (salience 100))
  =>
    (assert (ask (iden precio-minimo))))
	
(defrule INTERVIEW::request-precio-maximo
    (declare (salience 100))
  =>
    (assert (ask (iden precio-maximo))))
	
(defrule INTERVIEW::request-num-hab
    (declare (salience 100))
  =>
    (assert (ask (iden num-hab))))
	
(defrule INTERVIEW::request-superficie
    (declare (salience 100))
  =>
    (assert (ask (iden superficie))))

(defrule INTERVIEW::assert-user-fact
  (answer (ident accion) (text ?a))
  (answer (ident municipio) (text ?b))
  (answer (ident tipo-piso) (text ?c))
  (answer (ident precio-minimo) (text ?d))
  (answer (ident precio-maximo) (text ?e))
  (answer (ident num-hab) (text ?f))
  (answer (ident superficie) (text ?g))
  =>
  (assert (user (accion ?a) (municipio ?b) (tipo-piso ?c) (precio-minimo ?d)
                 (precio-maximo ?e) (num-hab ?f) (superficie ?g))))

				 
				 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module recommend
;(defmodule recommend)

(defmodule RECOMMEND (import MAIN ?ALL))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module report

;(defmodule report)

(defmodule REPORT (import MAIN ?ALL))


