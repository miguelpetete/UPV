def elegir(A,M,D,points,dur, inf = 2**31):
    P = {}
    P[0,0] = 0
    for d in range(1,D+1):
        P[0,d] = -inf 
    for a in range(1,A+1):
        for d in range(D+1):
            P[a,d] = max((P[a-1, d+dur(a,m)] + points(a,m) for m in range(1,M+1) if d>=dur(a,m)),default = -inf)