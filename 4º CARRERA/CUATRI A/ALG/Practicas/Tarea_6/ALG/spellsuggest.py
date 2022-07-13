# -*- coding: utf-8 -*-
import re
from ALG.distance import dp_levenshtein_backwards as levenshtein
from ALG.distance import dp_restricted_damerau_backwards as restricted
from ALG.distance import dp_intermediate_damerau_backwards as intermediate
from ALG.trie import Trie
import numpy as np
from time import process_time

class SpellSuggester:

    """
    Clase que implementa el método suggest para la búsqueda de términos.
    """

    def __init__(self, vocab_file_path):
        """Método constructor de la clase SpellSuggester

        Construye una lista de términos únicos (vocabulario),
        que además se utiliza para crear un trie.

        Args:
            vocab_file (str): ruta del fichero de texto para cargar el vocabulario.

        """

        self.vocabulary  = self.build_vocab(vocab_file_path, tokenizer=re.compile("\W+"))

    def build_vocab(self, vocab_file_path, tokenizer):
        """Método para crear el vocabulario.

        Se tokeniza por palabras el fichero de texto,
        se eliminan palabras duplicadas y se ordena
        lexicográficamente.

        Args:
            vocab_file (str): ruta del fichero de texto para cargar el vocabulario.
            tokenizer (re.Pattern): expresión regular para la tokenización.
        """
        with open(vocab_file_path, "r", encoding='utf-8') as fr:
            vocab = set(tokenizer.split(fr.read().lower()))
            vocab.discard('') # por si acaso
            return sorted(vocab)

    def suggest(self, term, distance="levenshtein", threshold=3):

        """Método para sugerir palabras similares siguiendo la tarea 3.

        A completar.

        Args:
            term (str): término de búsqueda.
            distance (str): algoritmo de búsqueda a utilizar
                {"levenshtein", "restricted", "intermediate"}.
            threshold (int): threshold para limitar la búsqueda
                puede utilizarse con los algoritmos de distancia mejorada de la tarea 2
                o filtrando la salida de las distancias de la tarea 2
        """

        assert distance in ["levenshtein", "restricted", "intermediate"]

        if distance == "levenshtein":
            f = levenshtein
        if distance == "restricted":
            f =restricted
        if distance == "intermediate":
            f = intermediate

        results = {} # diccionario termino:distancia
        
        for word in self.vocabulary:
            d = f(word,term)
            if d <= threshold:
                results[word] = d
        return results

        
        

        
        



class TrieSpellSuggester(SpellSuggester):
    """
    Clase que implementa el método suggest para la búsqueda de términos y añade el trie
    """
    def __init__(self, vocab_file_path):
        super().__init__(vocab_file_path)
        self.trie = Trie(self.vocabulary)
        def suggest(self, term, distance="restricted", threshold=3):
            results = {} # diccionario termino:distancia
            t = self.trie
            states = t.get_num_states()
            lterm = len(term)+1
            D = np.empty((states,lterm))

            D[t.get_root(), 0] = 0
            for i in range(1, states):
                D[i, 0] = D[t.get_parent(i), 0] + 1
            for j in range(1, lterm):
                D[0, j] = D[0, j-1] + 1
                for i in range(1, states):
                    D[i, j] = min(D[t.get_parent(i), j] + 1, # Insercion
                                D[i, j-1] + 1, # Borrado
                                D[t.get_parent(i), j-1] + (t.get_label(i) != term[j-1])) # Acierto / Fallo

                if(min(D[:, j]) > threshold):
                    return threshold + 1
            
            for i in range(1,states):
                if t.is_final(i) and D[i,lterm-1] <= threshold:
                    results[t.get_output(i)] = D[i,lterm-1]
                    
            return results

        
    
if __name__ == "__main__":
    aTime = process_time()
    spellsuggester = TrieSpellSuggester("./corpora/quijote.txt")
    dTime = process_time()
    print(spellsuggester.suggest("casa")) #alábese
    print( str(dTime-aTime))
    aTime = process_time()
    spellsuggester = SpellSuggester("./corpora/quijote.txt")
    dTime = process_time()
    print(spellsuggester.suggest("casa")) #alábese
    print( str(dTime-aTime))
    # cuidado, la salida es enorme print(suggester.trie)

    
