//TEAM_AXIS

//ESTE AGENTE ES SIMILAR AL MÉDICO, SOLO QUE REALIZA .movFieldOps Y LAS
//CONTRACT-NET QUE ESTABLECE SON CON SOLDADOS QUE PIDEN MUNICIÓN Y NO VIDA.

+flag (F): team(200)
  <-
  +estado(1);
  .register_service("fieldOps");
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
  .movFieldOps(F);
  .wait(1000);
  .print("FieldOps yendo a zona");
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

+savemeproposalmunicion(Pos)[source(A)]: not (ayudando(_,_))
<-
  ?position(MiPos);
  .send(A,tell,mybidmunicion(MiPos));
  +ayudando(A, Pos);
  -savemeproposalmunicion(_);
  .print("Propuesta de ayuda enviada.").

+aceptproposalmunicion[source(A)]: ayudando(A,Pos)
<-
  .print("Me voy a ayudar al agente: ",A," a la posición: ",Pos);
  .goto(Pos).

+target_reached(T): ayudando(A,T)
<-
  .print("AMMOPACK! para el agente: ",A);
  .reload;
  ?miposicion(P);
  .goto(P);
  -ayudando(A,Pos);

+cancelproposalmunicion[source(A)]: ayudando(A,Pos)
<-
  .print("Me cancelan mi proposición.");
  -ayudando(A,Pos).
