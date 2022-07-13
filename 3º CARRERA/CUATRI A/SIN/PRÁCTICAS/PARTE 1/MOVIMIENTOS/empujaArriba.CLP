(deffacts hechos
	(grid 8 5)
	(agujero 6 3)
	(robot 3 3 lata 4 3 lata 3 2 lata 3 4 lata 2 3 hecho 0 nivel 0 movimiento 0 latas 3)
)

(defrule empuja_arriba
	?f<-(robot ?x ?y $?inilatas lata ?lx ?y $?finlatas hecho ?fact nivel ?niv movimiento ?mov latas ?numlatas)
	(grid ?xmax ?ymax)
	(test (< 0 ?numlatas))
	(test (< (+ ?y 1) ?ymax))
	(not (agujero ?x =(+ ?y 2)))
	(test (= (+ ?y 1) ?ly))
	(test (not (member$ (create$ lata ?x (+ ?y 2)) $?inilatas)))
	(test (not (member$ (create$ lata ?x (+ ?y 2)) $?inilatas)))
	(test (neq ?mov empujaabajo))
	=>
	(assert (robot ?x (+ ?y 1) $?inilatas lata ?x (+ ?y 2) $?finlatas hecho ?f nivel (+ ?niv 1) movimiento empujaarriba latas ?numlatas))
)
