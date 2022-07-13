def tramos(K, L, C, S):
    # K es un entero
    # L, C, S son listas de len N
    N, inf = len(L), 2**31
    M = {(0, k): inf for k in range(K+1)}
    M[0, 0] = 0  # Caso base
    for t in range(N):  # tipo de tramo
        for k in range(K):
            M[t, k] = min(M[t-1, k-x*L[t]] + x*C[t]
                          for x in range(min(k//L[t], S[t])+1))
    return M[N, K]


print(tramos(100, (10, 20, 30, 40), (1, 2, 3, 4, 5), (4, 4, 4, 4, 4)))
