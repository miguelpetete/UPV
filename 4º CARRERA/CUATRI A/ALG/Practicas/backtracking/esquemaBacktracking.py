class esquemaBactracking:
    def is_complete(self, s):  # Devuelve True sii s es un estado completo
        return 0

    def is_feasible(self, s):  # Devuelve True sii la unica solucion de s es factible
        return 0

    # Devuelve False sii es imposible que s contenga una solucion factible
    def is_promising(self, s):
        return 0

    def branch(self, s):  # Devuelve una secuencia de estados (que puede ser vacia) obtenidos por ramificacion de s
        return 0

    def backtracking(self, s):  # Explora el subarbol que tiene por raiz a s y devuelve la primera
        # solucion factible que encunetra (si la hay). Si no hay ninguna devuelve None
        if self.is_complete(s):
            if self.is_feasible(s):
                return s
            else:
                for s0 in self.branch(s):
                    if self.is_promising(s0):
                        found = self.backtracking(s0)
                        if found != None:
                            return found
                return None

    def solve(self, s):
        return self.backtracking([])
