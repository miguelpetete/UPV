#-------------------------------------------------------------------------------
#------------------------TRABAJO PRÁCTICAS PER----------------------------------
#-------------------------------------------------------------------------------
#---- Autor: Miguel Ángel Navarro Arenas
#---- Clase: 3CO11
#---- Curso: 2020-2021
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
#---- EJERCICIO 2.1
#---- Implementa la función pca que recibe como parámetro de entrada los datos 
#---- de entrenamiento por filas y el vector media m y la matriz de proyección 
#---- W donde los vectores propios están dispuestos por columnas de mayor a 
#---- menor valor propio asociado. 
#-------------------------------------------------------------------------------
function [m, W] = pca(X)
  muestras = rows(X);
  m = sum(X)/muestras;
  Xm = X-m;
  Sigma = (Xm'*Xm)/muestras;
  [eigvec, eigval] = eig(Sigma);
  [S,I]=sort(diag(eigval),"descend");
  W = eigvec(:,I);  
end




