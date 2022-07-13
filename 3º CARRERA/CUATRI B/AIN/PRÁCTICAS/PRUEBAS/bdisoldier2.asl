//TEAM_AXIS


+flag (F): team(200)
  <-
  +accion.

+accion: flag(F)
<-
  .print("Hola, bandera en: ", F);
  +estado(1);
  .register_service("soldier2");
  .friendsAlive(X);
  .print("Friends alive: ",X);
  .get_service("coronel");
  .wait(1000);
  if(not(coronel(A))){
    .banderaRobada;
  };
  !patrullar(F).

+patrullar(X): estado(E) & E=1
<-
  .get_service("coronel");
  .wait(1000);
  if(not(coronel(A))){
    .banderaRobada;
  };
  .patrulla2(X);
  .wait(1000);
  .print("Patrullando en zona 2.")
  -estado(_);
  +estado(E-1);
  ?health(Vida);
  if(Vida < 40){
    +pedidaayudamedics;
    .get_medics;
  };
  !patrullar(F).

+patrullar(X): estado(E) & E=0
<-
  .get_service("coronel");
  .wait(1000);
  if(not(coronel(A))){
    .banderaRobada;
  };
  -estado(_);
  +estado(1);
  !patrullar(F).

+savemeproposal(Pos)[source(A)]: not (ayudando(_,_,_)) & not (disparando)
<-
  ?position(MiPos);
  ?health(MiHealth);
  .send(A, tell, mypos(MiPos));
  .send(A, tell, vidaAliado(MiHealth));
  +ayudando(A, Pos, Health);
  -savemeproposal(_);
  .print("enviada propuesta ayuda");

+acceptproposal[source(A)]: ayudando(A, Pos, Health)
<-
  .print("Viene a ayudarme el agente: ", A);
  -ayudando(A,Pos,Health).

+calcelproposal[source(A)]: ayudando(A, Pos, Health)
<-
  .print("Me cancelan mi proposición");
  -ayudando(A, Pos, Health).

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
  -mybidmedics(Pos).

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
  +disparando;
  .shoot(3, Position).
