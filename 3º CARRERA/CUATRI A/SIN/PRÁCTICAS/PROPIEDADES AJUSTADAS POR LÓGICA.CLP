(defglobal ?*nod-gen* = 0)

(deffacts robot-edificio
	(Edificio 11 4)
	(Escalera 1 3)
	(Escalera 2 2)
	(Escalera 3 1)
	(Escalera 7 1)
	(Escalera 7 3)
	(Escalera 10 2)
	(Escalera 11 3)
	(Hueco 3 3)
	(Hueco 4 4)
	(Hueco 5 2)
	(Hueco 5 4)
	(Hueco 6 4)
	(Hueco 8 3)

	(Juego Robot 1 1 Caja 3 4 Caja 4 3 Caja 11 2 Enemigo 4 2 Enemigo 8 2 Enemigo 8 4 Disparos 2 Nivel 0 Movimiento nulo Hecho 0)
)

(defrule recoger
	(declare (salience 90))

	(Prof-maxima ?prof)

	?f1 <- (Juego Robot ?robotX ?robotY $?a Caja ?robotX ?robotY $?b Nivel ?nivel $?)

	(test (< ?nivel ?prof))

	=>
	
	(assert (Juego Robot ?robotX ?robotY ?a ?b Nivel (+ ?nivel 1) Movimiento recoger Hecho ?f1))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule derecha
	(declare (salience 89))

	(Prof-maxima ?prof)
	(Edificio ?edificioX ?)

	?f1 <- (Juego Robot ?robotX ?robotY $?a Nivel ?nivel Movimiento ?mov Hecho ?hecho)

	(test (< ?robotX ?edificioX))
	(test (< ?nivel ?prof))
	(test (neq ?mov izquierda))

	(not (Hueco =(+ ?robotX 1) ?robotY))
	(not (Juego $? Enemigo =(+ ?robotX 1) ?robotY $? Movimiento ?mov Hecho ?hecho))

	=>
	
	(assert (Juego Robot (+ ?robotX 1) ?robotY ?a Nivel (+ ?nivel 1) Movimiento derecha Hecho ?f1))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule izquierda
	(declare (salience 86))

	(Prof-maxima ?prof)

	?f1 <- (Juego Robot ?robotX ?robotY $?a Nivel ?nivel Movimiento ?mov Hecho ?hecho)

	(test (> ?robotX 1))
	(test (< ?nivel ?prof))
	(test (neq ?mov derecha))

	(not (Hueco =(- ?robotX 1) ?robotY))
	(not (Juego $? Enemigo =(- ?robotX 1) ?robotY $? Movimiento ?mov Hecho ?hecho))

	=>
	
	(assert (Juego Robot (- ?robotX 1) ?robotY ?a Nivel (+ ?nivel 1) Movimiento izquierda Hecho ?f1))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule subir
	(declare (salience 88))

	(Prof-maxima ?prof)
	(Escalera ?escaleraX ?escaleraY)

	?f1 <- (Juego Robot ?robotX ?robotY $?a Nivel ?nivel Movimiento ?mov $?)

	(test (eq ?robotX ?escaleraX))
	(test (eq ?robotY ?escaleraY))
	(test (< ?nivel ?prof))
	(test (neq ?mov bajar))

	=>
	
	(assert (Juego Robot ?robotX (+ ?robotY 1) ?a Nivel (+ ?nivel 1) Movimiento subir Hecho ?f1))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule bajar
	(declare (salience 87))

	(Prof-maxima ?prof)
	(Escalera ?escaleraX ?escaleraY)

	?f1 <- (Juego Robot ?robotX ?robotY $?a Nivel ?nivel Movimiento ?mov $?)

	(test (eq ?robotX ?escaleraX))
	(test (eq (- ?robotY 1) ?escaleraY))
	(test (< ?nivel ?prof))
	(test (neq ?mov subir))

	=>
	
	(assert (Juego Robot ?robotX (- ?robotY 1) ?a Nivel (+ ?nivel 1) Movimiento bajar Hecho ?f1))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule disparar
	(declare (salience 85))

	(Prof-maxima ?prof)

	?f1 <- (Juego Robot ?robotX ?robotY $?a Enemigo ?enemigoX ?enemigoY $?b Disparos ?disparos Nivel ?nivel $?)

	(test (or (eq ?enemigoX (- ?robotX 1)) (eq ?enemigoX (+ ?robotX 1))))
	(test (eq ?enemigoY ?robotY))
	(test (> ?disparos 0))
	(test (< ?nivel ?prof))

	=>
	
	(assert (Juego Robot ?robotX ?robotY ?a ?b Disparos (- ?disparos 1) Nivel (+ ?nivel 1) Movimiento disparar Hecho ?f1))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule objetivo
	(declare (salience 100))

	?f1 <- (Juego $? Nivel ?nivel $?)

	(or (exists (Juego Robot ? ? Enemigo $?)) (exists (Juego Robot ? ? Disparos $?)))

	=>

	(printout t "HAS GANADO" crlf)
	(printout t "SOLUCION ENCONTRADA EN EL NIVEL " ?nivel crlf)
	(printout t "NUMERO DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*nod-gen* crlf)
	(printout t "HECHO OBJETIVO " ?f1 crlf)

	(halt)
)

(defrule no-solucion
	(declare (salience -99))
	
	(Juego $? Nivel ?nivel $?)

	=>

	(printout t "SOLUCION NO ENCONTRADA" crlf)
	(printout t "NUMERO DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*nod-gen* crlf)

	(halt)
)

(deffunction inicio()
	(reset)
	(printout t "Profundidad Maxima: " )
	(bind ?prof (read))
	(printout t "Tipo de Busqueda " crlf " 1.- Anchura" crlf " 2.- Profundidad" crlf )
	(bind ?a (read))
	(if (= ?a 1)
		then (set-strategy breadth)
		else (set-strategy depth)
	)
	(printout t "Ejecuta run para poner en marcha el programa " crlf)
	(assert (Prof-maxima ?prof))
)