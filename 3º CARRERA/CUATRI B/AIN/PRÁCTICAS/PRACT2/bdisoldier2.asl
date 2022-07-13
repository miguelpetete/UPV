//TEAM_AXIS

+flag (F): team(200)
  <-
  .create_control_points(F,25,3,C);
  +control_points(C);
  .register_service("soldier2");
  .length(C,L);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0);
  .print("Got control points");

+target_reached(T): patrolling & team(200)
  <-
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

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .shoot(3,Position).
