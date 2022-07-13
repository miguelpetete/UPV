//TEAM_AXIS


+flag (F): team(200)
  <-
  +accion.

+accion: flag(F)
<-
  //se muestra la posición inicial de la bandera
  .print("Hola, bandera en: ", F);
  +estado(1);
  .register_service("soldier1");
  //se comprueba el servicio del coronel, si no existe es porque el coronel ha
  //muerto y van a robar la bandera pronto
  .get_service("coronel");
  .wait(1000);
  if(not(coronel(A))){
    .banderaRobada;
  };
  //si el coronel está vivo, patrullamos, que es la función principal de
  //este agente, patrullar y defender.
  !patrullar(F).

//realizamos un bucle similar al mostrado en la primera práctica para estar
//constantemente girando, pero en este caso, estamos constantemente patrullando
+!patrullar(X): estado(E) & E=1
<-
  //volvemos a comprobar que el coronel siga vivo
  .get_service("coronel");
  .wait(1000);
  if(not(coronel(A))){
    .banderaRobada;
  };
  //realizamos la acción de patrullaje que se ha creado en el archivo python
  .patrulla1(X);
  .wait(1000);
  .print("Patrullando en zona 1.");
  -estado(_);
  +estado(E-1);
  ?health(Vida);
  //si mientras estamos patrullando la salud baja de 40 puntos, pedimos ayuda
  //a los médicos
  if(Vida < 40){
    +pedidaayudamedics;
    .get_medics;
  };
  //Si la munición es inferior a 10 unidades, pedimos munición a los fieldOps
  ?ammo(Municion);
  if(Municion < 10){
    +pedidaayudamunicion;
    .get_fieldops;
  }
  //comprobamos los agentes de nivel dos que hay. Si han matado a alguno,
  //realizamos la acción goZone, esta acción está explicada en la memoria.
  .get_service("soldier2");
  .wait(1000);
  if(soldier2(A) & A<3 & not(disparando)){
    +irZona2;
    .goZone2(A);
  }
  //si no ocurre nada de lo anterior, seguimos patrullando.
  else{
    !patrullar(F);
  }.

+patrullar(X): estado(E) & E=0
<-
  //seguimos monitorizando si el coronel ha muerto. La defensa de la bandera
  //es lo más importante
  .get_service("coronel");
  .wait(1000);
  if(not(coronel(A))){
    .banderaRobada;
  };
  -estado(_);
  +estado(1);
  !patrullar(F).

//realizamos la ayuda a los agentes de la zona 2 en caso de que alguno de
//ellos haya muerto
+goZone2(M): irZona2
<-
  .print("Necesitan ayuda en zona 2.");
  +bids([]);
  +agents([]);
  +pos([]);
  ?position(Pos);
  //realizamos una coordinación con los agentes de tipo 2
  .send(M, tell,savemeproposal(Pos));
  .wait(1000);
  !!elegirmejor;
  -goZone2(_).

//recibimos las posiciones en las que se encuentras los soldier2
+mypos(Pos)[source(A)]: irZona2
<-
  .print("Guardo posiciones.");
  ?pos(P);
  .concat(P,[Pos], P1);
  -+pos(P1);
  -mypos(Pos).

//recibimos la vida de los soldier2, junto con una lista de los mismos
//aprovechando el source(A)
+vidaAliado(Vida)[source(A)]: irZona2
<-
  .print("Recibida la vida.");
  ?bids(B);
  .concat(B,[Vida],B1);
  -+bids(B1);
  ?agents(Ag);
  .concat(Ag,[A],Ag1);
  -+agents(Ag1);
  -vidaAliado(Vida).

//elegimos el agente de tipo 2 que menos vida tenga para ir a su posición y
//ayudarlo, en caso de igualdad de vidas, elegimos al primero.
+!elegirmejor: bids(Bi) & agents(Ag)
<-
  .print("Seleccionamos al que menos vida tenga: ", Bi, Ag);
  //acción externa que se realiza en Python
  .menorVida(Bi, Ag, AgM);
  .send(AgM, tell, accept.proposal);
  .delete(AgM, Ag, Ag1);
  .send(Ag1, tell, cancelproposal);
  -+bids(_);
  -+agents(_);
  -+pos(_);
  //vamos a la posición del agente con menos vida
  .goto(pos(AgM)).

//idéntico al mostrado en las prácticas
+myMedics(M): pedidaayudamedics
<-
  .print("Pido ayuda.");
  ?position(Pos);
  +bidsmedics([]);
  +agentsmedics([]);
  .send(M,tell,savemeproposalmedics(Pos));
  .wait(1000);
  !!elegirmejormedics;
  -myMedics(_);

//identico al mostrado en prácticas
+mybidmedics(Pos)[source(A)]: pedidaayudamedics
<-
  .print("Recibo respuesta");
  ?bidsmedics(B);
  .concat(B, [Pos], B1);
  -+bidsmedics(B1);
  ?agentsmedics(Ag);
  .concat(Ag, [A], Ag1);
  -+agentsmedics(Ag1);
  -mybid(Pos).

//idéntico al mostrado en prácticas
+!elegirmejormedics: bidsmedics(Bi) & agentsmedics(Ag)
<-
  .print("Selecciono el primero: ", Bi, Ag);
  .nth(0,Bi,Pos);
  .nth(0,Ag,A);
  .send(A,tell,acceptproposalmedics);
  .delete(0,Ag,Ag1);
  .send(Ag1, tell,cancelproposalmedics);
  -+bidsmedics(_);
  -+agentsmedics(_);

//parecido al de los médicos, pero en este damos un paquete de munición
+myFieldOps(F): pedidaayudamunicion
<-
  .print("Pido munición");
  ?position(Pos);
  +bidsmunicion([]);
  +agentsmunicion([]);
  .send(M,tell,savemeproposalmunicion(Pos));
  .wait(1000);
  !!elegirmejormunicion;
  -myFieldOps(_).

//parecido al de los médicos, pero en este damos un paquete de munición
+mybidmunicion(Pos)[source(A)]: pedidaayudamunicion
<-
  .print("Recibo respuesta.");
  ?bidsmunicion(B);
  .concat(B,[Pos]B1);
  -+bidsmunicion(B1);
  ?agentsmunicion(Ag);
  .concat(Ag,[A],Ag1);
  -+agentsmunicion(Ag1);
  -mybidmunicion(Pos).

//parecido al de los médicos, pero en este damos un paquete de munición
+!elegirmejormunicion: bidsmunicion(Bi) & agentsmunicion(Ag)
<-
  .print("Selecciono el primero: ",Bi,Ag);
  .nth(0,Bi,Pos);
  .nth(0,Ag,A);
  .send(A,tell,acceptproposalmunicion);
  .delete(0,Ag,Ag1);
  .send(Ag1,tell,cancelproposalmunicion);
  -+bidsmunicion(_);
  -+agentsmunicion(_);

//disparar al enemigo
+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  //incluimos disparando, para que en caso de ser atacados, no acudir en ayudar
  //de agentes de tipo 2, como bien hemos dicho en la memoria. 
  +disparando;
  .shoot(3, Position).
