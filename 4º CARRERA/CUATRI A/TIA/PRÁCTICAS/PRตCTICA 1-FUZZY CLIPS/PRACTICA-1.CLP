(deftemplate vehiculo
	(slot id (type SYMBOL))
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
	(morelessalta more-or-less alta)))

(deftemplate pres-freno
	0 1 porciento
	((baja (0.05 1)(0.2 0))
	(muybaja very baja)
	(media (0.1 0)(0.4 1)(0.6 1)(0.7 0))
	(alta (0.6 0)(1 1))
	(morelessmedia more-or-less media)
	(morelessalta more-or-less alta)
	(muyalta very alta)))

(defrule leerconsola
	(initial-fact)
	=>
	(printout t "Introduzca la matricula del vehiculo: " crlf)
	(bind ?id (read))
	(printout t "Introduzca la velocidad CRISP del vehiculo: " crlf)
	(bind ?velocidad-crisp (read))
	(printout t "Introduzca la distancia CRISP con el vehiculo de alante: " crlf)
	(bind ?distancia-crisp (read))
	(assert (vehiculo (id ?id) (distancia-crisp ?distancia-crisp) (velocidad-crisp ?velocidad-crisp) ))
	(fuzzify dis ?distancia-crisp 0)
	(fuzzify vel ?velocidad-crisp 0)
)



(defrule dis-cer_vel-ale
	(dis cerca)
	(vel alejando)
	=>
	(assert (fuerza-acel media))
	(assert (pres-freno nula)))

(defrule dis-cer_vel-cte
	(dis cerca)
	(vel constante)
	=>
	(assert (fuerza-acel nula))
	(assert (pres-freno muybaja)))

(defrule dis-cer_vel-ace
	(dis cerca)
	(vel acercando)
	=>
	(assert (fuerza-acel nula))
	(assert (pres-freno alta)))

(defrule dis-med_vel-ale
	(dis medio)
	(vel alejando)
	=>
	(assert (fuerza-acel morelessalta))
	(assert (pres-freno nula)))

(defrule dis-med_vel-cte
	(dis media)
	(vel constante)
	=>
	(assert (fuerza-acel media))
	(assert (pres-freno nula)))

(defrule dis-med_vel-ace
	(dis media)
	(vel acercando)
	=>
	(assert (fuerza-acel nula))
	(assert (pres-freno morelessmedia)))

(defrule dis-lej_vel-ale
	(dis lejos)
	(vel alejando)
	=>
	(assert (fuerza-acel muyalta))
	(assert (pres-freno nula)))

(defrule dis-lej_vel-cte
	(dis lejos)
	(vel constante)
	=>
	(assert (fuerza-acel alta))
	(assert (pres-freno nula)))

(defrule dis-lej_vel-ace
	(dis lejos)
	(vel acercando)
	=>
	(assert (fuerza-acel muybaja))
	(assert (pres-freno muybaja)))

(defrule defuzzy
	(fuerza-acel ?fa)
	(pres-freno ?pf)
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
