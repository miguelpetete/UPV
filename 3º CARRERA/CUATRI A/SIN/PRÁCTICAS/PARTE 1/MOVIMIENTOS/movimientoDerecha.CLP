(deffacts hechos
	(agujero 1 2)
	(agujero 1 5)
	(agujero 2 1)
	(agujero 4 2)
	(agujero 4 5)
	(agujero 6 1)
	(agujero 7 5)
	(agujero 8 1)
	(agujero 8 2)
	(robot 2 3 lata 4 2 lata 6 2 lata 6 4 hecho 0 nivel 0 movimiento 0 latas 3)
	(grid 8 5)
)

(defrule robot_derecha
	?f<-(robot ?x ?y $?latas hecho ?fact nivel ?niv movimiento ?mov $?fin)
	(grid ?xmax ?ymax)
	(test (< ?x ?xmax))
	(not (agujero =(+ ?x 1) ?y))
	(test (eq (member$ (create$ lata (+ ?x 1) ?y) $?latas) FALSE))
	(test (neq ?mov izquierda))
	=>
	(assert (robot (+ ?x 1) ?y $?latas hecho ?f nivel (+ ?niv 1) movimiento derecha $?fin))
	(printout t "Movimiento realizado a la derecha." crlf)
)
