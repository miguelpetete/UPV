% Use this editor as a MiniZinc scratch book
int: n=15; 
var 0..100: d;

array [1..n] of int: alto;
array [1..n] of int: ancho;
array [1..n] of var 0..100: posX;
array [1..n] of var 0..100: posY;

% alto1=alto[i], ancho1=ancho[i], alto2=alto[j], ancho2=ancho[j];
constraint 
(forall (i,j in 1..n where i!=j) 
((posX[j]>=posX[i]+ancho[i]) \/ 
(posX[i]>=posX[j]+ancho[j]) \/ 
(posY[i]>=posY[j]+alto[j]) \/ 
(posY[j]>=posY[i]+alto[i])));

%comprobación del último rectángulo girado
constraint 
(forall (i in 1..(n-1))
(posX[i]>=posX[n]+alto[n] \/ posX[n]>=posX[i]+ancho[i] \/ posY[n]>=posY[i]+alto[i] \/ posY[i]>=posY[n]+ancho[n]));


%Evitar que nos pasemos de los límites de (x,y)
constraint forall(i in 1..n) ((posX[i]+alto[i]<=d) /\ (posY[i]+ancho[i]<=d));

%alldiferent de las posiciones
constraint forall(i,j in 1..n where i!=j)((posX[i]!=posX[j])/\(posY[i]!=posY[j]));

solve minimize d*d;

output [("X: " ++ show(posX[i]) ++ " Y: " ++ show(posY[i]) ++ "\n" )| i in 1..n];
output ["Largo: " ++ show(d) ++ " Ancho: " ++ show(d) ++ "\n"];
output [show(d*d)];


