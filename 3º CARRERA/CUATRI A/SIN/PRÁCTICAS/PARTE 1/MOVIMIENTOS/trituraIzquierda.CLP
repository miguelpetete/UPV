(deffacts hechos 
	(grid 8 5)
	(agujero 5 3)
	(agujero 3 1)
	(agujero 1 3)
	(agujero 3 5)
	(robot 3 3 lata 4 3 lata 3 2 lata 3 4 lata 2 3 hecho 0 nivel 0 movimiento 0 latas 3)
)

(defrule tritura_izquierda
	?f<-(robot ?x ?y $?ini lata ?xl ?y $?med hecho ?fact nivel ?niv movimiento ?mov latas ?latas)
	(agujero ?xa ?y)
	(test (and (= (- ?x 2) ?xa) (= (- ?x 1) ?xl)))
	=>
	(assert (robot (- ?x 1) ?y $?ini $?med hecho ?f nivel (+ ?niv 1) movimiento tritura_izquierda latas (- ?latas 1)))
	(printout t "Trituradora a la izquierda." crlf)
) 