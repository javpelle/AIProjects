(mapclass Inmobiliaria)

(deftemplate Inmobiliaria
   (slot nombre_inmo)
   (slot onLine)
   (slot viviendas_por_inmobiliaria))

(deffacts inicio
   (Inmobiliaria (nombre_inmo "a")(onLine TRUE))
   (Inmobiliaria (nombre_inmo "b")(onLine FALSE)))
   
(defrule cargar (Inmobiliaria (nombre_inmo ?m)(onLine ?mo)) => (make-instance of Inmobiliaria (nombre_inmo ?m)(onLine ?mo)))

(reset)
(run)