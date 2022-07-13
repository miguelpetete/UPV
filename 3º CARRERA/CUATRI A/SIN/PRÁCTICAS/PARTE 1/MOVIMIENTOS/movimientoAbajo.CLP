(deffacts hechos
	(agujero 3 3)
	(agujero 1 5)
	(agujero 2 1)
	(agujero 4 3)
	(agujero 4 5)
	(agujero 6 1)
	(agujero 7 5)
	(agujero 8 1)
	(agujero 8 3)
	(robot 2 3 lata 4 3 lata 6 3 lata 6 4 hecho 0 nivel 0 movimiento 0 latas 3)
	(grid 8 5)
)

(defrule robot_abajo
	?f<-(robot ?x ?y $?latas hecho ?fact nivel ?niv movimiento ?mov $?fin)
	(test (< 0 ?y))
	(not (agujero ?x =(- ?y 1)))
	(test (eq (member$ (create$ lata ?x (- ?y 1)) $?latas) FALSE))
	(test (neq ?mov arriba))
	=>
	(assert (robot ?x (- ?y 1) $?latas hecho ?f nivel (- ?niv 1) movimiento abajo $?fin))
	(printout t "Movimiento realizado abajo" crlf)
)