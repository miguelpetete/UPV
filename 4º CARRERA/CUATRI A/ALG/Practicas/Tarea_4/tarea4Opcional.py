## Opcional
# Levenshtein hacia delante 

def dp_levenshtein_forwards(x, y, threshold=3):
    active_states = {} # diccionario de estatos activos
    t = self.trie
    states = t.get_num_states()
    lterm = len(term)+1
    D = np.empty((states,lterm))

    D[t.get_root(), 0] = 0
    parent_st = t.get_root()
    for child_st in  t.iter_children(parent_st):
        print(child_st)