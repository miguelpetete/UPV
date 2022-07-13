//TEAM_AXIS

+flag (F): team(200)
  <-
  +estado(1);
  .register_service("medics");
  .get_service("coronel");
  .wait(1000);
  if(not(coronel(A))){
    .banderaRobada;
  };
  !patrullar(F).

+!patrullar(X): estado(E) & E=1
<-
  .get_service("coronel");
  .wait(1000);
  if(not(coronel(A))){
    .banderaRobada;
  };
  .movMed1(F);
  .wait(1000);
  .print("Patrullando en zona 1.");
  -estado(_);
  +estado(E-1);
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

+savemeproposalmedics(Pos)[source(A)]: not (ayudando(_,_))
<-
  ?position(MiPos);
  .send(A,tell,mybidmedics(MiPos));
  +ayudando(A, Pos);
  -savemeproposalmedics(_);
  .print("Propuesta de ayuda enviada.").

+aceptproposalmedics[source(A)]: ayudando(A,Pos)
<-
  .print("Me voy a ayudar al agente: ",A," a la posición: ",Pos);
  .goto(Pos).

+target_reached(T): ayudando(A,T)
<-
  .print("MEDPACK! para el agente: ",A);
  .cure;
  ?miposicion(P);
  .goto(P);
  -ayudando(A,Pos);

+cancelproposalmedics[source(A)]: ayudando(A,Pos)
<-
  .print("Me cancelan mi proposición.");
  -ayudando(A,Pos).
