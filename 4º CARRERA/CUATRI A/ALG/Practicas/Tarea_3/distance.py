import numpy as np


def dp_levenshtein_backwards(x, y, threshold=3):
    D = np.empty((len(x)+1, len(y)+1))
    D[0, 0] = 0
    for i in range(1, len(x)+1):
        D[i, 0] = D[i-1, 0] + 1
    for j in range(1, len(y)+1):
        D[0, j] = D[0, j-1] + 1
        for i in range(1, len(x)+1):
            D[i, j] = min(D[i-1, j] + 1, D[i, j-1]+1,
                          D[i-1, j-1] + (x[i-1] != y[j-1]))
        if(min(D[:, j]) > threshold):
            return threshold+1
    return D[len(x), len(y)]


def dp_restricted_damerau_backwards(x, y, threshold=3): 
    D = np.empty((len(x)+1, len(y)+1))
    D[0, 0] = 0
    for i in range(1, len(x)+1):
        D[i, 0] = D[i-1, 0] + 1
    for j in range(1, len(y)+1):
        D[0, j] = D[0, j-1] + 1
        for i in range(1, len(x)+1):
            if (j > 1 and i > 1) and (x[i-2] == y[j-1] and x[i-1] == y[j-2]):
                D[i, j] = min(D[i-1, j] + 1,
                              D[i, j-1] + 1,
                              D[i-1, j-1] + (x[i-1] != y[j-1]),
                              D[i-2, j-2] + 1)
       
            else:
                D[i, j] = min(D[i-1, j] + 1,
                              D[i, j-1] + 1,
                              D[i-1, j-1] + (x[i-1] != y[j-1]))
        if(min(D[:, j]) > threshold):
            return threshold+1
    return D[len(x), len(y)]


def dp_intermediate_damerau_backwards(x, y, threshold=3):
    cte = 1
    D = np.empty((len(x)+1, len(y)+1))
    D[0, 0] = 0
    for i in range(1, len(x)+1):
        D[i, 0] = D[i-1, 0] + 1
    for j in range(1, len(y)+1):
        D[0, j] = D[0, j-1] + 1
        for i in range(1, len(x)+1):
            aux = min(D[i-1, j] + 1,
                        D[i, j-1] + 1,
                        D[i-1, j-1] + (x[i-1] != y[j-1]))

            # case ab <-> ba
            if (i > 1 and j > 1) and int(x[i-2] == y[j-1] and x[i-1] == y[j-2]) <= cte:
                aux = min(aux,
                            D[i-2, j-2] + 1)

            # case aub <-> ba
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
            return threshold+1

    return D[len(x), len(y)]


""" test = [("algoritmo", "algortimo"),
        ("algoritmo", "algortximo"),
        ("algoritmo", "lagortimo"),
        ("algoritmo", "agaloritom"),
        ("algoritmo", "algormio"),
        ("acb", "ba"),
        ("def", "abc")]

for x, y in test:
    print(f"{x:12} {y:12} ", end="")
    for dist, name in ((dp_levenshtein_backwards, "levenshtein"),
                       (dp_restricted_damerau_backwards, "restricted"),
                       (dp_intermediate_damerau_backwards, "intermediate")):
        print(f" {name} {dist(x,y)}", end="")
    print() """


"""
Salida del programa:
algoritmo    algortimo    levenshtein  2 restricted  1 intermediate  1
algoritmo    algortximo   levenshtein  3 restricted  3 intermediate  2
algoritmo    lagortimo    levenshtein  4 restricted  2 intermediate  2
algoritmo    agaloritom   levenshtein  5 restricted  4 intermediate  3
algoritmo    algormio     levenshtein  3 restricted  3 intermediate  2
acb          ba           levenshtein  3 restricted  3 intermediate  2
"""

