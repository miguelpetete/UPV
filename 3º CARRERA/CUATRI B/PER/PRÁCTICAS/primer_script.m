#-------------------------------------------------------------------------------
#------------------------TRABAJO PRÁCTICAS PER----------------------------------
#-------------------------------------------------------------------------------
#---- Autor: Miguel Ángel Navarro Arenas
#---- Clase: 3CO11
#---- Curso: 2020-2021
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
#----PRECARGA DE LOS DATOS DE MNIST
#-------------------------------------------------------------------------------
load("train-images-idx3-ubyte.mat.gz"); #X
load("t10k-images-idx3-ubyte.mat.gz"); #Y
load("train-labels-idx1-ubyte.mat.gz"); #xl
load("t10k-labels-idx1-ubyte.mat.gz"); #yl


#-------------------------------------------------------------------------------
#----MUESTRA POR PANTALLA DE LOS TAMAÑOS DE LA LIBRERÍA
#-------------------------------------------------------------------------------
disp('Tamaño imagenes entrenamiento: ');
disp(size(X));
disp('Tamaño imagenes test: ');
disp(size(Y));
disp('Tamaño vector etiquetas de clase entrenamiento: ');
disp(size(xl));
disp('Tamaño vector etiquetas de clase test: ');
disp(size(yl));


#-------------------------------------------------------------------------------
#----ESTABLECIMIENTO DE PARÁMETROS NECESARIOS PARA LOS CÁLCULOS
#-------------------------------------------------------------------------------
labs = unique(xl);


#-------------------------------------------------------------------------------
#---- EJERCICIO 4.2.1
#---- Calcular el vector media de cada dígito y almacenarlo en las columnas de 
#---- una matriz llamada medias.
#-------------------------------------------------------------------------------
function [medias] = obtenerMedia(X)
    for c = labs'
      idc = find(xl==c);
      Xc = X(idc,:);
      mXc = sum(Xc)/rows(Xc);
      medias(:,c+1) = mXc;
    endfor
endfunction

#-------------------------------------------------------------------------------
#---- EJERCICIO 4.2.2
#---- Idem del anterior pero untilizar la función mean
#-------------------------------------------------------------------------------
function [medias] = obtenerMedia(X)
    for c = labs'
      idc = find(xl==c);
      Xc = X(idc,:);
      mXc = mean(Xc);
      medias(:,c+1) = mXc;
    endfor
endfunction

#-------------------------------------------------------------------------------
#---- EJERCICIO 5.1
#---- Implementar una versión matricial de linmach.m que no utilize bucles
#-------------------------------------------------------------------------------









