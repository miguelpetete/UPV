import numpy as np


#--------------------------------------------------------------------------------#
#------LEVENSTEIN BÁSICO---------------------------------------------------------#
#--------------------------------------------------------------------------------#
def dp_levenshtein_backwards(x, y, threshold=3):
    D = np.empty((len(x)+1, len(y)+1)) #Creamos matriz. A las longitudes de las palabras se les suma uno debido a que se tiene en cuenta las inserciones 
    D[0, 0] = 0                        #Inicializamos la matriz a ceros
    for i in range(1, len(x)+1):       #Bucle para realizar inserciones iniciales de la primera palabra
        D[i, 0] = D[i-1, 0] + 1
    for j in range(1, len(y)+1):       #Bucle para realizar inserciones de la segunda palabra
        D[0, j] = D[j-1, 0] + 1
        for i in range(1, len(x)+1):   #Mediante un doble bucle recorremos toda la matriz  
            D[i, j] = min(D[i-1, j] + 1, D[i, j-1]+1,
                          D[i-1, j-1] + (x[i-1] != y[j-1])) #Aquí es donde aplicamos el algoritmo de Levenstein, eligiendo el mínimo entre los tres nodos anteriores si la matriz fuera un "grafo"
        if(min(D[:, j]) > threshold):  #Aplicación del threshold de la tarea 3. Si lo superamos, 
            return None
    return D[len(x), len(y)]           #Retornamos la posición final que es donde se encuentra el resultado final de Levenstein. 




#--------------------------------------------------------------------------------#
#------DAMERAU-LEVENSTEIN RESTRINGIDO--------------------------------------------#
#--------------------------------------------------------------------------------#
def dp_restricted_damerau_backwards(x, y, threshold=3): #Idem que el anterior, solo que necesitamos comprobar, no solo los tres nodos anteriores.
    D = np.empty((len(x)+1, len(y)+1))
    D[0, 0] = 0
    for i in range(1, len(x)+1):
        D[i, 0] = D[i-1, 0] + 1
    for j in range(1, len(y)+1):
        D[0, j] = D[j-1, 0] + 1
        for i in range(1, len(x)+1):   #Dentro de este bucle reside la diferencia con el algoritmo de Levenstein.
            if (j > 1 and i > 1) and (x[i-2] == y[j-1] and x[i-1] == y[j-2]): #Comprobamos que dos pares de letras sean iguales pero intercambiados de orden. En este caso el coste sería 1 y no 2 
                D[i, j] = min(D[i-1, j] + 1,
                              D[i, j-1] + 1,
                              D[i-1, j-1] + (x[i-1] != y[j-1]), 
                              D[i-2, j-2] + 1) 
       
            else:                      #Si no se cumple que los pares de letras sean iguales pero intercambiados de orden, se aplica Levenstein de manera normal. 
                D[i, j] = min(D[i-1, j] + 1,
                              D[i, j-1] + 1,
                              D[i-1, j-1] + (x[i-1] != y[j-1]))
        if(min(D[:, j]) > threshold):  #Aplicación del threshold de la tarea 3. Si lo superamos, 
            return None
    return D[len(x), len(y)]




#--------------------------------------------------------------------------------#
#------DAMERAU-LEVENSTEIN INTERMEDIO---------------------------------------------#
#--------------------------------------------------------------------------------#
def dp_intermediate_damerau_backwards(x, y, threshold=3): #En este caso, también tenemos que tener en cuenta dos posibilidades: ab <-> bva ó bva <-> ab
    cte = 1
    D = np.empty((len(x)+1, len(y)+1))
    D[0, 0] = 0
    for i in range(1, len(x)+1):
        D[i, 0] = D[i-1, 0] + 1
    for j in range(1, len(y)+1):
        D[0, j] = D[j-1, 0] + 1
        for i in range(1, len(x)+1):
            aux = min(D[i-1, j] + 1, #Algoritmo de Levenstein original
                        D[i, j-1] + 1,
                        D[i-1, j-1] + (x[i-1] != y[j-1]))

            # case ab <-> ba, aplicamos idem que en el Damerau-Levenstein restringido
            if (i > 1 and j > 1) and int(x[i-2] == y[j-1] and x[i-1] == y[j-2])  <= cte:
                aux = min(aux,
                            D[i-2, j-2] + 1)

            # case avb <-> ba
            elif (i > 2 and j > 1) and int(x[i-3] == y[j-1] and x[i-1] == y[j-2]) <= cte:
                aux = min(aux,
                            D[i-3, j-2] + 1)

            # case ab <-> bva
            elif (i > 1 and j > 2) and int(x[i] == y[j-3] and x[i-2] == y[j-1]) <= cte:
                aux = min(aux,
                            D[i-2, j-3] + 1)

            # insercion, borrado y intercambio
            D[i, j] = aux
        if(min(D[:, j]) > threshold):
            return None

    return D[len(x), len(y)]


#--------------------------------------------------------------------------------#
#------TEST----------------------------------------------------------------------#
#--------------------------------------------------------------------------------#

test = [("algoritmo", "algortimo"),
        ("algoritmo", "algortximo"),
        ("algoritmo", "lagortimo"),
        ("algoritmo", "agaloritom"),
        ("algoritmo", "algormio"),
        ("acb", "ba"),
        ("def", "abc")]

for x,y in test:
    print(f"{x:12} {y:12}",end="")
    for dist,name in ((dp_levenshtein_backwards,"levenshtein"),
                      (dp_restricted_damerau_backwards,"restricted"),
                      (dp_intermediate_damerau_backwards,"intermediate")):
        print(f" {name} {dist(x,y):2}",end="")
    print()
                 
"""
Salida del programa:

algoritmo    algortimo    levenshtein  2 restricted  1 intermediate  1
algoritmo    algortximo   levenshtein  3 restricted  3 intermediate  2
algoritmo    lagortimo    levenshtein  4 restricted  2 intermediate  2
algoritmo    agaloritom   levenshtein  5 restricted  4 intermediate  3
algoritmo    algormio     levenshtein  3 restricted  3 intermediate  2
acb          ba           levenshtein  3 restricted  3 intermediate  2
""" 


#### Apartados opcionales
#   De manera opcional puedes implementar la versión general de Damerau-Levenstein.
# def dp_no_restricted_damerau_backwards(x, y):
#     D = np.empty((len(x)+1, len(y)+1))
#     D[0, 0] = 0
#     for i in range(1, len(x)+1):
#         D[i, 0] = D[i-1, 0] + len(x)
#     for j in range(1, len(y)+1):
#         D[0, j] = D[j-1, 0] + len(y)
#         for i in range(1, len(x)+1):
#             if (j > 1 and i > 1) and (x[i-2] == y[j-1] and x[i-1] == y[j-2]):
#                 D[i, j] = min(D[i-1, j] + i,
#                               D[i, j-1] + j,
#                               D[i-1, j-1] + (x[i-1] != y[j-1]),
#                               D[i-2, j-2] + 1)
       
#             else:
#                 D[i, j] = min(D[i-1, j] + i,
#                               D[i, j-1] + j,
#                               D[i-1, j-1] + (x[i-1] != y[j-1]))
#         if(min(D[:, j])):
#             return None
#     return D[len(x), len(y)]

# Versiones hacia atrás para Damerau-Levenstein restringida e intermedia.