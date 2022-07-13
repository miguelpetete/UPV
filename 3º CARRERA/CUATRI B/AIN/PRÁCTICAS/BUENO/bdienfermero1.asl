//TEAM_AXIS

+flag (F): team(200)
  <-
  +estado(1);
  //registramos servicio medics
  .register_service("medics");
  .get_service("coronel");
  .wait(1000);
  //comprobamos que el coronel esté vivo
  if(not(coronel(A))){
    .banderaRobada;
  };
  !patrullar(F).

//patrullamos, igual que soldier1
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

//patrullamos, igual que soldier 1
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

//comunicación proveniente de soldados. Le enviamos nuestra posició y
//"aceptamos" ayudarle hasta que el decida de quien va a recibir ayuda
+savemeproposalmedics(Pos)[source(A)]: not (ayudando(_,_))
<-
  ?position(MiPos);
  .send(A,tell,mybidmedics(MiPos));
  +ayudando(A, Pos);
  -savemeproposalmedics(_);
  .print("Propuesta de ayuda enviada.").

//en caso de seleccionarnos a nosotros para recibir la ayuda,
//iremos a la posición del agente que nos ha demandado.
+aceptproposalmedics[source(A)]: ayudando(A,Pos)
<-
  .print("Me voy a ayudar al agente: ",A," a la posición: ",Pos);
  .goto(Pos).

//cuando llegamos a la posición del agente, le curamos y volvemos a la
//posición en la que nos encontrábamos originalmente.
+target_reached(T): ayudando(A,T)
<-
  .print("MEDPACK! para el agente: ",A);
  .cure;
  ?miposicion(P);
  .goto(P);
  -ayudando(A,Pos);

//en caso de que el agente nos rechaze...
+cancelproposalmedics[source(A)]: ayudando(A,Pos)
<-
  .print("Me cancelan mi proposición.");
  -ayudando(A,Pos).
