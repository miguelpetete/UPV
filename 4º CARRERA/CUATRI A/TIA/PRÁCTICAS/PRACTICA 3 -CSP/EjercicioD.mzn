% Use this editor as a MiniZinc scratch book
int: n=5; 
%int: altoMax=60;
%int: anchoMax=60;
var 0..10000: x;
var 0..10000: y;

array [1..n] of int: alto;
array [1..n] of int: ancho;
array [1..n] of var 0..10000: posX;
array [1..n] of var 0..10000: posY;

% alto1=alto[i], ancho1=ancho[i], alto2=alto[j], ancho2=ancho[j];
constraint 
(forall (i,j in 1..n where i!=j) 
((posX[j]>=posX[i]+ancho[i]) \/ 
(posX[i]>=posX[j]+ancho[j]) \/ 
(posY[i]>=posY[j]+alto[j]) \/ 
(posY[j]>=posY[i]+alto[i])));

constraint 
(forall (i in 1..(n-1))
(%(posX[n]>=posX[i]+ancho[i] \/ posX[n]>=posX[n]+ancho[n] \/ posY[i]>=posY[n]+alto[n] \/ posY[n]>=posY[i]+alto[i]) 
%/\ 
(posX[i]>=posX[n]+alto[n] \/ posX[n]>=posX[i]+ancho[i] \/ posY[n]>=posY[i]+alto[i] \/ posY[i]>=posY[n]+ancho[n])));


%Evitar que nos pasemos de los límites de (x,y)
constraint forall(i in 1..n) ((posX[i]+alto[i]<=x) /\ (posY[i]+ancho[i]<=y));

%alldiferent de las posiciones
constraint forall(i,j in 1..n where i!=j)((posX[i]!=posX[j])/\(posY[i]!=posY[j]));

solve minimize x*y;

output [("X: " ++ show(posX[i]) ++ " Y: " ++ show(posY[i]) ++ "\n" )| i in 1..n];
output ["Largo: " ++ show(x) ++ " Ancho: " ++ show(y) ++ "\n"];
output [show(x*y)];


