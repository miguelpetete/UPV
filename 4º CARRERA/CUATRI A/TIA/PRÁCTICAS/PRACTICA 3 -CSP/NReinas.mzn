int:n;
array[1..n] of var 1..n: q;


include "alldifferent.mzn";

constraint forall (i,j in 1..n where i!=j) (q[i]!=q[j]);

constraint forall (i,j in 1..n where i!=j) ((q[i]-q[j]) != (i-j));

constraint forall (i,j in 1..n where i!=j) ((q[j]-q[i]) != (i-j));

solve satisfy;

output [(show(q[i]) ++ " ") | i in 1..n];