(defrule robot_izquierda
	?f<-(robot ?x ?y $?ini lata ?lx ?ly $?mid hecho ?fact nivel ?niv movimiento ?mov $?fin)
	(agujero ?ax ?ay)
	(prof-max ?prof)
	(test (<> (- ?x 1) ?lx))
	(test (<> (- ?x 1) ?ax))
	(test (> ?x 0))
	(test (neq ?mov derecha))
	(test (< ?niv ?prof))
	=>
	(assert (robot (- ?x 1) ?y $?ini lata ?lx ?ly $? mid hecho ?f nivel (+ ?niv 1) movimiento derecha $?fin))
)

(defrule robot_arriba
	?f<-(robot ?x ?y $?ini lata ?lx ?ly $?mid hecho ?fact nivel ?niv movimiento ?mov $?fin)
	(agujero ?ax ?ay)
	(prof-max ?prof)
	(test (<> (+ ?y 1) ?ly))
	(test (<> (+ ?y 1) ?ay))
	(test (neq ?mov abajo))
	(test (< ?niv ?prof))
	=>
	(assert (robot ?x (+ ?y 1) $?ini lata ?lx ?ly $? mid hecho ?f nivel (+ ?niv 1) movimiento arriba $?fin))
)

(defrule robot_abajo
	?f<-(robot ?x ?y $?ini lata ?lx ?ly $?mid hecho ?fact nivel ?niv movimiento ?mov $?fin)
	(agujero ?ax ?ay)
	(prof-max ?prof)
	(test (<> (- ?y 1) ?ly))
	(test (<> (- ?y 1) ?ay))
	(test (neq ?mov arriba))
	(test (< ?niv ?prof))
	=>
	(assert (robot ?x (- ?y 1) $?ini lata ?lx ?ly $? mid hecho ?f nivel (+ ?niv 1) movimiento derecha $?fin))
)




(defrule tritura_derecha
	?f<-(grid $?x R 2 1 $?y nivel ?n $?resto latas ?latas)
	(prof-max ?prof)
	(test (< ?n ?prof))
=>
	(assert (grid $?x 0 R 1 $?y nivel (+ ?n 1) $?resto latas (- ?latas 1))))
	;(bind ?*nod-gen* (+ ?*nod-gen* 1)))


(defrule tritura_izquierda
	?f<-(grid $?x 1 2 R $?y nivel ?n $?resto latas ?latas )
	(prof-max ?prof)
	(test (< ?n ?prof))
=>
	(assert (grid $?x 1 R 0 $?y nivel (+ ?n 1) $?resto latas (- ?latas 1))))
	;(bind ?*nod-gen* (+ ?*nod-gen* 1)))


(defrule tritura_arriba
	?f<-(grid $?x 1 $?medio1 2 $?medio2 R $?y nivel ?n $?resto latas ?latas)
	(prof-max ?prof)
	(test (< ?n ?prof))
	(test (= (length $?medio1) 7))
	(test (= (length $?medio2) 7))
=>
	(assert (grid $?x 1 $?medio1 R $?medio2 0 $?y nivel (+ ?n 1) $?resto latas (- ?latas 1))))
	;(bind ?*nod-gen* (+ ?*nod-gen* 1)))

(defrule tritura_abajo
	?f<-(grid $?x R $?medio1 2 $?medio2 1 $?y nivel ?n $?resto latas ?latas)
	(prof-max ?prof)
	(test (< ?n ?prof))
	(test (= (length $?medio1) 7))
	(test (= (length $?medio2) 7))
=>
	(assert (grid $?x 0 $?medio1 R $?medio2 1 $?y nivel (+ ?n 1) $?resto latas (- ?latas 1))))
	;(bind ?*nod-gen* (+ ?*nod-gen* 1)))

(defrule empuja-derecha
	?f<-(grid $?x R 2 0 $?y nivel ?n $?resto)
	(prof-max ?prof)
	(test (< ?n ?prof))
	(test (and (<> (length $?x) 7)(<> (length $?y) 31)))
	(test (and (<> (length $?x) 15)(<> (length $?y) 23)))
	(test (and (<> (length $?x) 23)(<> (length $?y) 15)))
	(test (and (<> (length $?x) 31)(<> (length $?y) 7)))

	(test (and (<> (length $?x) 6)(<> (length $?y) 32)))
	(test (and (<> (length $?x) 14)(<> (length $?y) 24)))
	(test (and (<> (length $?x) 22)(<> (length $?y) 16)))
	(test (and (<> (length $?x) 30)(<> (length $?y) 8)))
=>
	(assert (grid $?x 0 R 2 $?y nivel (+ ?n 1) $?resto)))
	;(bind ?*nod-gen* (+ ?*nod-gen* 1)))

(defrule empuja-izquierda
	?f<-(grid $?x 0 2 R $?y nivel ?n $?resto)
	(prof-max ?prof)
	(test (< ?n ?prof))
	(test (and (<> (length $?x) 8)(<> (length $?y) 30)))
	(test (and (<> (length $?x) 16)(<> (length $?y) 22)))
	(test (and (<> (length $?x) 24)(<> (length $?y) 14)))
	(test (and (<> (length $?x) 32)(<> (length $?y) 6)))

	(test (and (<> (length $?x) 7)(<> (length $?y) 31)))
	(test (and (<> (length $?x) 15)(<> (length $?y) 23)))
	(test (and (<> (length $?x) 23)(<> (length $?y) 15)))
	(test (and (<> (length $?x) 31)(<> (length $?y) 7)))
=>
	(assert (grid $?x 0 R 2 $?y nivel (+ ?n 1) $?resto)))
	;(bind ?*nod-gen* (+ ?*nod-gen* 1)))

(defrule empuja-arriba
	?f<-(grid $?x 0 $?medio1 2 $?medio2 R $?y nivel ?n $?resto)
	(prof-max ?prof)
	(test (< ?n ?prof))
	(test (= (length $?medio1) 7))
	(test (= (length $?medio2) 7))
=>
	(assert (grid $?x 2 $?medio1 R $?medio2 0 $?y nivel (+ ?nivel 1) $?resto)))
	;(bind ?*nod-gen* (+ ?*nod-gen* 1)))

(defrule empuja-abajo
	?f<-(grid $?x R $?medio1 2 $?medio2 0 $?y nivel ?n $?resto)
	(prof-max ?prof)
	(test (< ?n ?prof))
	(test (= (length $?medio1) 7))
	(test (= (length $?medio2) 7))
=>
	(assert (grid $?x 0 $?medio1 R $?medio2 2 $?y nivel (+ ?nivel 1) $?resto)))
	;(bind ?*nod-gen* (+ ?*nod-gen* 1)))

(defrule objetivo
	(declare (salience 100))
	?f<-(grid $?x nivel ?n movimiento ?m hecho ?fact latas 0)
	(prof-max ?prof)
	(test (< ?n ?prof))
=>
	(printout t "SOLUCION ENCONTRADA EN EL NIVEL " ?n crlf)
 	;(printout t "NUM DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*nod-gen* crlf)
 	(printout t "HECHO OBJETIVO " ?f crlf)
	(printout t "MOVIMIENTO PREVIO " ?m crlf)
	(printout t "���ENHORABUENA!!! " crlf)
	(printout t "FINALIZANDO EJECUCI�N... " crlf)
 	(halt))
