% Use this editor as a MiniZinc scratch book
int: n=15; 
%int: altoMax=60;
%int: anchoMax=60;
var 0..100: d;

array [1..n] of int: alto;
array [1..n] of int: ancho;
array [1..n] of var 0..10000: posX;
array [1..n] of var 0..10000: posY;

% alto1=alto[i], ancho1=ancho[i], alto2=alto[j], ancho2=ancho[j];
constraint forall (i,j in 1..n where i!=j) ((posX[j]>=posX[i]+ancho[i]) \/ (posX[i]>=posX[j]+ancho[j]) \/ (posY[i]>=posY[j]+alto[j]) \/ (posY[j]>=posY[i]+alto[i]));

%Evitar que nos pasemos de los límites de dxd
constraint forall(i in 1..n) ((posX[i]+ancho[i]<=d) /\ (posY[i]+alto[i]<=d));

%El extremo superior derecho del rectángulo 3 tiene que estar pegado al comienzo del rectángulo 4.
constraint ((posX[3]+ancho[3])=posX[4]) /\ ((posY[3]+alto[3])=posY[4]);

solve minimize d*d;

output [("X: " ++ show(posX[i]) ++ " Y: " ++ show(posY[i]) ++ "\n" )| i in 1..n];
output ["Largo: " ++ show(d) ++ " Ancho: " ++ show(d) ++ "\n"];
output [show(d*d)];


