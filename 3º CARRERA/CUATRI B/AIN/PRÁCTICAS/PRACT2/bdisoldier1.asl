//TEAM_AXIS

+flag (F): team(200)
  <-
  .register_service("soldier1");
  +accion.

+accion: flag(F)
<-
  .print("Hola");
  .goto(F);
  .print("He llegado a la bandera").

+accion: not flag(F)
<-
  -+accion.
