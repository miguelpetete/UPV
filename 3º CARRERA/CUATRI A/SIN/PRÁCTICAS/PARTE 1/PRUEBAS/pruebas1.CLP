(deffacts datos
	(lista 4 5 3 46 12 10))


(defrule ordenar 
	?f1<-(lista $?ini ?x ?y $?fin)
	(test (< ?y ?x))
=>
	(retract ?f1)
	(assert (lista $?ini ?y ?x $?fin)))