//TEAM_AXIS


+flag (F): team(200)
  <-
  +accion.

+accion: flag(F)
<-
  .print("Hola, bandera en: ", F);
  +estado(1);
  .register_service("soldier1");
  .friendsAlive(X);
  .print("Friends alive: ",X);
  .get_service("general");
  .wait(1000);
  if(general(B)&B=0){
    .banderaRobada;
  };
  !patrullar(F).

+!patrullar(X): estado(E) & E=1
<-
  .patrulla1(X);
  .wait(1000);
  .print("Patrullando en zona 1.");
  -estado(_);
  +estado(E-1);
  ?health(Vida);
  if(Vida < 40){
    +pedidaayudamedics;
    .get_medics;
  };
  ?ammo(Municion);
  if(Municion < 10){
    +pedidaayudamunicion;
    .get_fieldops;
  }
  .get_service("soldier2");
  .wait(1000);
  if(soldier2(A) & A<3){
    +irZona2;
    .goZone2(A);
  }
  else{
    !patrullar(F);
  }.

+patrullar(X): estado(E) & E=0
<-
  -estado(_);
  +estado(1);
  !patrullar(F).

+goZone2(M): irZona2
<-
  .print("Necesitan ayuda en zona 2.");
  +bids([]);
  +agents([]);
  +pos([]);
  ?position(Pos);
  .send(M, tell,savemeproposal(Pos));
  .wait(1000);
  !!elegirmejor;
  -goZone2(_).

+mypos(Pos)[source(A)]: irZona2
<-
  .print("Guardo posiciones.");
  ?pos(P);
  .concat(P,[Pos], P1);
  -+pos(P1);
  -mypos(Pos).

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

+!elegirmejor: bids(Bi) & agents(Ag)
<-
  .print("Seleccionamos al que menos vida tenga: ", Bi, Ag);
  .menorVida(Bi, Ag, AgM);
  .send(AgM, tell, accept.proposal);
  .delete(AgM, Ag, Ag1);
  .send(Ag1, tell, cancelproposal);
  -+bids(_);
  -+agents(_);
  -+pos(_);
  .goto(pos(AgM)).

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

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .shoot(3, Position).
