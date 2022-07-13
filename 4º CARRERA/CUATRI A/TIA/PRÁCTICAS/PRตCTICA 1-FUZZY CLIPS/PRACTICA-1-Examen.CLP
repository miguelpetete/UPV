(deftemplate vehiculo
	(slot id (type SYMBOL))
	(slot edad (type INTEGER))
	(slot distancia-crisp (type INTEGER))
	(slot velocidad-crisp (type INTEGER))
	(slot distancia-fuzzy (type INTEGER))
	(slot velocidad-fuzzy (type INTEGER))
	(slot fuerza-aceleracion-mom (type FLOAT))
	(slot fuerza-aceleracion-max (type FLOAT))
	(slot presion-freno-mom (type FLOAT))
	(slot presion-freno-max (type FLOAT)))

(deffunction fuzzify (?fztemplate ?value ?delta)
	(bind ?low (get-u-from ?fztemplate))
	(bind ?hi  (get-u-to   ?fztemplate))
		(if (<= ?value ?low)
			then
				(assert-string
					(format nil "(%s (%g 1.0) (%g 0.0))" ?fztemplate ?low ?delta))
			else
				(if (>= ?value ?hi)
					then
						(assert-string
							(format nil "(%s (%g 0.0) (%g 1.0))"
	                               ?fztemplate (- ?hi ?delta) ?hi))
					else
						(assert-string
							(format nil "(%s (%g 0.0) (%g 1.0) (%g 0.0))"
									?fztemplate (max ?low (- ?value ?delta))
									?value (min ?hi (+ ?value ?delta)) ))))
)

(defrule leerconsola
	(initial-fact)
	=>
	(printout t "Introduzca la matricula del vehiculo: " crlf)
	(bind ?id (read))
	(printout t "Introduzca la velocidad CRISP del vehiculo: " crlf)
	(bind ?velocidad-crisp (read))
	(fuzzify velocidad-fuzzy ?velocidad-crisp 0)
	(printout t "Introduzca la distancia CRISP con el vehiculo de alante: " crlf)
	(bind ?distancia-crisp (read))
	(fuzzify distancia-fuzzy ?distancia-crisp 0)
	(printout t "Introduzca la inclinación CRISP del vehiculo: " crlf)
	(bind ?inclinacion-crisp (read))
	(fuzzify inclinacion-fuzzy ?inclinacion-crisp 0)
	(printout t "Introduzca la edad CRISP del vehiculo: " crlf)
	(bind ?edad-crisp (read))
	;(distancia-fuzzy ?distancia-fuzzy)
	;(velocidad-fuzzy ?velocidad-fuzzy)
	(assert (vehiculo (id ?id) (distancia-crisp ?distancia-crisp) (velocidad-crisp ?velocidad-crisp)(edad-crisp ?edad-crisp)))
)

(deftemplate dis
	0 50 metros
	((cerca (5 1)(15 0))
	(media (10 0)(20 1)(30 1)(35 0))
	(lejos (30 0)(35 1))))

(deftemplate vel
	-30 30 km-h
	((alejando (-30 0)(0 0))
	(constante (-10 0)(0 1)(15 0))
	(acercando (0 0) (30 1))))

(deftemplate fuerza-acel
	0 1 porciento
	((baja (0.05 1)(0.20 0))
	(muybaja very baja)
	(media (0.1 0)(0.4 1)(0.6 1)(0.7 0))
	(alta (0.6 0)(1 1))
	(morelessalta more-or-less alta)
	(muyalta very alta)))

(deftemplate pres-freno
	0 1 porciento
	((baja (0.05 1)(0.2 0))
	(muybaja very baja)
	(media (0.1 0)(0.4 1)(0.6 1)(0.7 0))
	(alta (0.6 0)(1 1))
	(morelessmedia more-or-less media)
	(morelessalta more-or-less alta)
	(muyalta very alta)))

(deftemplate inclinacion
	-45 45 grados
	((bajada (-20 1)(-5 0))
	(llano (-10 0)(-5 1)(5 1)(10 0))
	(subida (5 0)(15 1))))

(defrule vel-ace_inc-bajada
	(velocidad alejando)
	(inclinacion bajada)
	=>
	(assert (fuerza-aceleracion muyalta))
)

(defrule dis-cer_inc-subida
	(distancia cerca)
	(inclinacion subida)
	=>
	(assert (presion-freno baja))
)

(defrule dis-cer_vel-ale
	(distancia cerca)
	(velocidad alejando)
	=>
	(assert (fuerza-aceleracion media))
	(assert (presion-freno nula)))

(defrule dis-cer_vel-cte
	(distancia cerca)
	(velocidad constante)
	=>
	(assert (fuerza-aceleracion nula))
	(assert (presion-freno muybaja)))

(defrule dis-cer_vel-ace
	(distancia cerca)
	(velocidad acercando)
	=>
	(assert (fuerza-aceleracion nula))
	(assert (presion-freno alta)))

(defrule dis-med_vel-ale
	(distancia medio)
	(velocidad alejando)
	=>
	(assert (fuerza-aceleracion morelessalta))
	(assert (presion-freno nula)))

(defrule dis-med_vel-cte
	(distancia media)
	(velocidad constante)
	=>
	(assert (fuerza-aceleracion media))
	(assert (presion-freno nula)))

(defrule dis-med_vel-ace
	(distancia media)
	(velocidad acercando)
	=>
	(assert (fuerza-aceleracion nula))
	(assert (presion-freno morelessmedia)))

(defrule dis-lej_vel-ale
	(distancia lejos)
	(velocidad alejando)
	=>
	(assert (fuerza-aceleracion muyalta))
	(assert (presion-freno nula)))

(defrule dis-lej_vel-cte
	(distancia lejos)
	(velocidad constante)
	=>
	(assert (fuerza-aceleracion alta))
	(assert (presion-freno nula)))

(defrule dis-lej_vel-ace
	(distancia lejos)
	(velocidad acercando)
	=>
	(assert (fuerza-aceleracion muybaja))
	(assert (presion-freno muybaja)))

(defrule defuzzy
	(fuerza-aceleracion ?fa)
	(presion-freno ?pf)
	=>
	(bind ?fadefmd (maximum-defuzzify ?fa))
	(bind ?fadefmo (moment-defuzzify ?fa))
	(bind ?pfdefmd (maximum-defuzzify ?pf))
	(bind ?pfdefmo (moment-defuzzify ?pf))
	(printout t "Maximum fuerza-aceleracion: " ?fadefmd crlf)
	(printout t "Momentum fuerza-aceleracion: " ?fadefmo crlf)
	(printout t "Maximum presion-freno: " ?pfdefmd crlf)
	(printout t "Momentum presion-freno: " ?pfdefmo crlf)
)
(defrule aviso
	?f<-(vehiculo $?x (edad-crisp ?edad) $?y)
	(test (> ?edad 15))
	(presion-freno ?pf)
	(bind ?pf-def-max (maximum-defuzzify ?pf))
	(bind ?pf-def-mom (moment-defuzzify ?pf))
	(test (or (> ?pf-def-max 0.8)(> ?pf-def-mom 0.8)))
	=>
	(printout t "SITUACION CRITICA. " crlf)
)
