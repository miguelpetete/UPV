from Practicas.esquemaBacktracking import esquemaBactracking


class AllSoBacktrackingScheme(esquemaBactracking):
    # Explora el subarbol que tiene por raiz a s y genera todas las
    def backtracking(self, s, soluciones):
        # soluciones factibles (si las hay) que encuentra
        if self.is_complete(s):
            if self.is_feasible(s):
                soluciones.append(s)
            else:
                for s0 in self.branch(s):
                    if self.is_promising(s0):
                        self.backtracking(s0)

    def solve(self, s):
        soluciones = []
        self.backtracking([], soluciones)
