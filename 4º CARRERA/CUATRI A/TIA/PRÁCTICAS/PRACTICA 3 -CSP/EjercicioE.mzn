% Use this editor as a MiniZinc scratch book
int: n=15; 
%int: altoMax=60;
%int: anchoMax=60;
var 0..1000: d;

array [1..n] of int: alto;
array [1..n] of int: ancho;
array [1..n] of var 0..10000: posX;
array [1..n] of var 0..10000: posY;

% alto1=alto[i], ancho1=ancho[i], alto2=alto[j], ancho2=ancho[j];
constraint forall (i,j in 1..n where i!=j) ((posX[j]>=posX[i]+ancho[i]) \/ (posX[i]>=posX[j]+ancho[j]) \/ (posY[i]>=posY[j]+alto[j]) \/ (posY[j]>=posY[i]+alto[i]));

%Evitar que nos pasemos de los límites de dxd
constraint forall(i in 1..n) ((posX[i]+alto[i]<=d) /\ (posY[i]+ancho[i]<=d));

%Exigimos que los rectángulos 5 y 8 se toquen en un punto de sus lados verticales
%Tenemos el punto donde comienza el rectángulo 8 -> posX[8], posY[8]
%Cogemos dos puntos del rectángulo 5, suponiendo que el rectángulo 8 está a la derecha del cinco
%El punto del rectángulo 8 posY[8] debe estar contenido entre el punto superior derecho de 5 y el punto inferior derecho de 5
%Para ello, tenemos que igualar las coordenadas X de ambos rectángulos y posY[8] between posY[5],posY[5]+alto -> posY[5]<=posY[8]<=(posY[5]+altura[5] 
constraint ((posX[5]+ancho[5]=posX[8]) /\ ((posY[5]<=posY[8]) \/ (posY[8]<=(posY[5]+alto[5])) \/ (posY[5]+alto[5]<=posY[8]+alto[8]))) /\
((posX[5]+ancho[5]=posX[8]) /\ ((posY[8]<=posY[5]) \/ (posY[5]<=(posY[8]+alto[8])) \/ (posY[8]+alto[8]<=posY[5]+alto[5]))) /\
%Hacemos lo mismo pero ahora suponiendo que 8 está a la izquierda y 5 a la derecha
((posX[8]+ancho[8]=posX[5]) /\ ((posY[8]<=posY[5]) \/ (posY[5]<=(posY[8]+alto[8])) \/ (posY[8]+alto[8]<=posY[5]+alto[5]))) /\
((posX[8]+ancho[8]=posX[5]) /\ ((posY[5]<=posY[8]) \/ (posY[8]<=(posY[5]+alto[5])) \/ (posY[5]+alto[5]<=posY[8]+alto[8])));

solve minimize d*d;

output [("X: " ++ show(posX[i]) ++ " Y: " ++ show(posY[i]) ++ "\n" )| i in 1..n];
output ["Largo: " ++ show(d) ++ " Ancho: " ++ show(d) ++ "\n"];
output [show(alto[5])++ " " ++ show(ancho[5])++"\n"];
output [show(posX[5])++ " " ++ show(posY[5])++"\n"];
output [show(alto[8])++ " " ++ show(ancho[8])++"\n"];
output [show(posX[8])++ " " ++ show(posY[8])++"\n"];
output [show(d*d)];


