;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;TRABAJO REALIZADO POR: Miguel Angel Navarro Arenas y Javier Alarcon Sanchez.
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------


(defglobal ?*nod-gen* = 0)
;(defglobal ?*prof* = 15)

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; EN LA EJECUCION DEL EJEMPLO DEL EXAMEN EL PROGRAMA CLIPS SE CERRABA
; AUTOMATICAMENTE. HAY QUE REVISARLO. 
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------







;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Estado inicial de la base de hechos y pregunta al usuario por profundidad,
; tipo de busqueda, tamanyo del eje y asercion de hechos dinamicos a la base
; inicial
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

(deffacts hechos
	;ESTATICOS
	(agujero 2 2)
	(agujero 3 3)
	(agujero 4 4)
	(agujero 5 5)
	(agujero 6 4)
	(agujero 7 3)
	(agujero 7 5)
	(agujero 8 2)
	(recarga 3 1)
	(recarga 4 2)
	(recarga 6 3)
	(recarga 7 4)


	;DINAMICO
	(robot 3 2 cargas 0 lata 3 4 lata 5 3 lata 6 2 hecho 0 nivel 0 movimiento 0 latas 3)
)
(deffunction inicio ()
	(reset)
	(printout t "Profundidad Maxima:= " )
	(bind ?prof (read))
	(printout t "Tipo de Busqueda " crlf "1.- Anchura" crlf "2.- Profundidad" crlf )
	(bind ?a (read))
	(printout t "Tamanyo maximo eje X grid:= " )
	(bind ?xgrid (read))
	(printout t "Tamanyo maximo eje Y grid:= " )
	(bind ?ygrid (read))
	(if (= ?a 1)
 		then (set-strategy breadth)
 		else (set-strategy depth))
 	(assert (prof-max ?prof))
	(assert (grid ?xgrid ?ygrid))
)

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Reglas para finalizar la ejecucion: ya sea con o sin solucion.
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defrule solucion
	(declare (salience 100))
	?f <- (robot $?x nivel ?niv movimiento ?mov latas ?latas)
	(test (= ?latas 0))
	=>
	(printout t "Solucion encontrada en el nivel: " ?niv crlf)
	(printout t "Ultimo hecho: " ?f crlf)
	(printout t "Nodos generados por la ejecucion: " ?*nod-gen* crlf)
	(printout t "FINALIZANDO LA EJECUCION... " crlf)
	(halt)
)
(defrule no-solucion
	(declare (salience -100))
	?f <- (robot $?x nivel ?niv $?y)
	=>
	(printout t "Solucion NO encontrada en el nivel: " ?niv crlf)
	(printout t "Nodos generados por la ejecucion: " ?*nod-gen* crlf)
	(printout t "FINALIZANDO LA EJECUCION... " crlf)
	(halt)
)

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;REGLA PARA EL EXAMEN: RECARGAR EL ROBOT
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
(defrule recargar
	;(declare (salience 80))
	?f <- (robot ?x ?y cargas ?car $?resto hecho ?h nivel ?niv movimiento ?mov $?fin)
	(recarga ?x ?y)
	(test (< ?car 4))
	=>
	(assert (robot ?x ?y cargas 4 $?resto hecho ?f nivel ?niv movimiento RECARGA $?fin))
)


;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;Reglas en las que el robot se mueve en las cuatro direcciones
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

(defrule robot_derecha
	?f<-(robot ?x ?y cargas ?c $?latas hecho ?fact nivel ?niv movimiento ?mov $?fin)
	(grid ?xmax ?ymax)
	(test (< ?x ?xmax))
	(not (agujero =(+ ?x 1) ?y))
	(test (eq (member$ (create$ lata (+ ?x 1) ?y) $?latas) FALSE))
	(test (neq ?mov izquierda))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot (+ ?x 1) ?y cargas ?c $?latas hecho ?f nivel (+ ?niv 1) movimiento derecha $?fin))
	;(printout t "Movimiento realizado a la derecha." crlf)
)
(defrule robot_izquierda
	?f<-(robot ?x ?y cargas ?c $?latas hecho ?fact nivel ?niv movimiento ?mov $?fin)
	(test (< 0 ?x))
	(not (agujero =(- ?x 1) ?y))
	(test (eq (member$ (create$ lata (- ?x 1) ?y) $?latas) FALSE))
	(test (neq ?mov derecha))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot (- ?x 1) ?y cargas ?c $?latas hecho ?f nivel (+ ?niv 1) movimiento izquierda $?fin))
	;(printout t "Movimiento realizado a la izquierda" crlf)
)
(defrule robot_abajo
	?f<-(robot ?x ?y cargas ?c $?latas hecho ?fact nivel ?niv movimiento ?mov $?fin)
	(test (< 0 ?y))
	(not (agujero ?x =(- ?y 1)))
	(test (eq (member$ (create$ lata ?x (- ?y 1)) $?latas) FALSE))
	(test (neq ?mov arriba))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot ?x (- ?y 1) cargas ?c $?latas hecho ?f nivel (+ ?niv 1) movimiento abajo $?fin))
	;(printout t "Movimiento realizado abajo" crlf)
)
(defrule robot_arriba
	?f<-(robot ?x ?y cargas ?c $?latas hecho ?fact nivel ?niv movimiento ?mov $?fin)
	(grid ?xmax ?ymax)
	(test (< ?y ?ymax))
	(not (agujero ?x =(+ ?y 1)))
	(test (eq (member$ (create$ lata ?x (+ ?y 1)) $?latas) FALSE))
	(test (neq ?mov abajo))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot ?x (+ ?y 1) cargas ?c $?latas hecho ?f nivel (+ ?niv 1) movimiento arriba $?fin))
	;(printout t "Movimiento realizado arriba" crlf)
)



;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;Reglas en las que el robot mueve una lata en las cuatro direcciones: derecha, izquierda, arriba y abajo.
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

(defrule empuja_derecha
	?f<-(robot ?x ?y cargas ?c $?inilatas lata ?lx ?y $?finlatas hecho ?fact nivel ?niv movimiento ?mov latas ?numlatas)
	(grid ?xmax ?ymax)
	(test (> ?c 0))
	(test (< 0 ?numlatas))
	(test (< (+ ?x 1) ?xmax))
	(not (agujero =(+ ?x 2) ?y))
	(not (recarga =(+ ?x 2) ?y))
	(test (= (+ ?x 1) ?lx))
	(test (not (member$ (create$ lata (+ ?x 2) ?y) $?inilatas)))
	(test (not (member$ (create$ lata (+ ?x 2) ?y) $?finlatas)))
	;(test (neq ?mov empujaizquierda))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot (+ ?x 1) ?y cargas (- ?c 1) $?inilatas lata (+ ?x 2) ?y $?finlatas hecho ?f nivel (+ ?niv 1) movimiento empujaderecha latas ?numlatas))
	;(printout t "Empuja lata derecha" crlf)
)
(defrule empuja_izquierda
	?f<-(robot ?x ?y cargas ?c $?inilatas lata ?lx ?y $?finlatas hecho ?fact nivel ?niv movimiento ?mov latas ?numlatas)
	(test (> ?c 0))
	(test (< 0 ?numlatas))
	(test (> ?x 2))
	(not (agujero =(- ?x 2) ?y))
	(not (recarga =(- ?x 2) ?y))
	(test (= (- ?x 1) ?lx))
	(test (not (member$ (create$ lata (- ?x 2) ?y) $?inilatas)))
	(test (not (member$ (create$ lata (- ?x 2) ?y) $?finlatas)))
	;(test (neq ?mov empujaderecha))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot (- ?x 1) ?y cargas (- ?c 1) $?inilatas lata (- ?x 2) ?y $?finlatas hecho ?f nivel (+ ?niv 1) movimiento empujaizquierda latas ?numlatas))
	;(printout t "Empuja lata izquierda" crlf)
)
(defrule empuja_abajo
	?f<-(robot ?x ?y cargas ?c $?inilatas lata ?x ?ly $?finlatas hecho ?fact nivel ?niv movimiento ?mov latas ?numlatas)
	(test (> ?c 0))
	(test (< 0 ?numlatas))
	(test (> ?y 2))
	(not (agujero ?x =(- ?y 2)))
	(not (recarga ?x =(- ?y 2)))
	(test (= (- ?y 1) ?ly))
	(test (not (member$ (create$ lata ?x (- ?y 2)) $?inilatas)))
	(test (not (member$ (create$ lata ?x (- ?y 2)) $?finlatas)))
	;(test (neq ?mov empujaarriba))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot ?x (- ?y 1) cargas (- ?c 1) $?inilatas lata ?x (- ?y 2) $?finlatas hecho ?f nivel (+ ?niv 1) movimiento empujaabajo latas ?numlatas))
	;(printout t "Empuja lata abajo" crlf)
)
(defrule empuja_arriba
	?f<-(robot ?x ?y cargas ?c $?inilatas lata ?x ?ly $?finlatas hecho ?fact nivel ?niv movimiento ?mov latas ?numlatas)
	(grid ?xmax ?ymax)
	(test (> ?c 0))
	(test (< 0 ?numlatas))
	(test (< (+ ?y 1) ?ymax))
	(not (agujero ?x =(+ ?y 2)))
	(not (recarga ?x =(+ ?y 2)))
	(test (= (+ ?y 1) ?ly))
	(test (not (member$ (create$ lata ?x (+ ?y 2)) $?inilatas)))
	(test (not (member$ (create$ lata ?x (+ ?y 2)) $?finlatas)))
	;(test (neq ?mov empujaabajo))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot ?x (+ ?y 1) cargas (- ?c 1) $?inilatas lata ?x (+ ?y 2) $?finlatas hecho ?f nivel (+ ?niv 1) movimiento empujaarriba latas ?numlatas))
	;(printout t "Empuja lata arriba" crlf)
)


;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;Reglas en las que el robot elimina una lata
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

(defrule tritura_derecha
	(declare (salience 30))
	?f<-(robot ?x ?y cargas ?c $?ini lata ?xl ?y $?med hecho ?fact nivel ?niv movimiento ?mov latas ?latas)
	(test (> ?c 0))
	(agujero ?xa ?y)
	(test (and (= (+ ?x 2) ?xa) (= (+ ?x 1) ?xl)))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot (+ ?x 1) ?y cargas (- ?c 1) $?ini $?med hecho ?f nivel (+ ?niv 1) movimiento tritura_derecha latas (- ?latas 1)))
	;(printout t "Trituradora a la derecha." crlf)
)
(defrule tritura_izquierda
	(declare (salience 30))
	?f<-(robot ?x ?y cargas ?c $?ini lata ?xl ?y $?med hecho ?fact nivel ?niv movimiento ?mov latas ?latas)
	(test (> ?c 0))
	(agujero ?xa ?y)
	(test (and (= (- ?x 2) ?xa) (= (- ?x 1) ?xl)))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot (- ?x 1) ?y cargas (- ?c 1) $?ini $?med hecho ?f nivel (+ ?niv 1) movimiento tritura_izquierda latas (- ?latas 1)))
	;(printout t "Trituradora a la izquierda." crlf)
)
(defrule tritura_arriba
	(declare (salience 30))
	?f<-(robot ?x ?y cargas ?c $?ini lata ?x ?yl $?med hecho ?fact nivel ?niv movimiento ?mov latas ?latas)
	(test (> ?c 0))
	(agujero ?x ?ya)
	(test (and (= (+ ?y 2) ?ya) (= (+ ?y 1) ?yl)))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot ?x (+ ?y 1) cargas (- ?c 1) $?ini $?med hecho ?f nivel (+ ?niv 1) movimiento tritura_arriba latas (- ?latas 1)))
	;(printout t "Trituradora arriba." crlf)
)
(defrule tritura_abajo
	(declare (salience 30))
	?f<-(robot ?x ?y cargas ?c $?ini lata ?x ?yl $?med hecho ?fact nivel ?niv movimiento ?mov latas ?latas)
	(test (> ?c 0))
	(agujero ?x ?ya)
	(test (and (= (- ?y 2) ?ya) (= (- ?y 1) ?yl)))
	(prof-max ?prof)
	(test (< ?niv ?prof))
	=>
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	(assert (robot ?x (- ?y 1) cargas (- ?c 1) $?ini $?med hecho ?f nivel (+ ?niv 1) movimiento tritura_abajo latas (- ?latas 1)))
	;(printout t "Trituradora abajo." crlf)
)
