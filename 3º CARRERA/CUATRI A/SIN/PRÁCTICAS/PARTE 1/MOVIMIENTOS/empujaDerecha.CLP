(deffacts hechos
	(grid 8 5)
	(agujero 6 3)
	(robot 3 3 lata 4 3 lata 3 2 lata 3 4 lata 2 3 hecho 0 nivel 0 movimiento 0 latas 3)
)

(defrule empuja_derecha
	?f<-(robot ?x ?y $?inilatas lata ?lx ?y $?finlatas hecho ?fact nivel ?niv movimiento ?mov latas ?numlatas)
	(grid ?xmax ?ymax)
	(test (< 0 ?numlatas))
	(test (< (+ ?x 1) ?xmax))
	(not (agujero =(+ ?x 2) ?y))
	(test (= (+ ?x 1) ?lx))
	(test (not (member$ (create$ lata (+ ?x 2) ?y) $?inilatas)))
	(test (not (member$ (create$ lata (+ ?x 2) ?y) $?inilatas)))
	(test (neq ?mov empujaizquierda))
	=>
	(assert (robot (+ ?x 1) ?y $?inilatas lata (+ ?x 2) ?y $?finlatas hecho ?f nivel (+ ?niv 1) movimiento empujaderecha latas ?numlatas))
)
