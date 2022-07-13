//TEAM_AXIS

+flag (F): team(200)
  <-
  +estado(1);
  .register_service("coronel");
  .goto(F);



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
