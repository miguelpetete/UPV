//TEAM_AXIS

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
  .print("Patrullando en zona 1.");
  -estado(_);
  +estado(E-1);
  !patrullar(F).



+target_reached(T): patrolling & team(200)
  <-
  .print("AMMOPACK!");
  .reload;
  ?patroll_point(P);
  -+patroll_point(P+1);
  -target_reached(T).

+patroll_point(P): total_control_points(T) & P<T
  <-
  ?control_points(C);
  .nth(P,C,A);
  .goto(A).

+patroll_point(P): total_control_points(T) & P==T
  <-
  -patroll_point(P);
  +patroll_point(0).


//TEAM_ALLIED

+flag (F): team(100)
  <-
  .goto(F).

+flag_taken: team(100)
  <-
  .print("In ASL, TEAM_ALLIED flag_taken");
  ?base(B);
  +returning;
  .goto(B);
  -exploring.

+heading(H): exploring
  <-
  .reload;
  .wait(2000);
  .turn(0.375).

//+heading(H): returning
//  <-
//  .print("returning").

+target_reached(T): team(100)
  <-
  .print("target_reached");
  +exploring;
  .turn(0.375).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .shoot(3,Position).
