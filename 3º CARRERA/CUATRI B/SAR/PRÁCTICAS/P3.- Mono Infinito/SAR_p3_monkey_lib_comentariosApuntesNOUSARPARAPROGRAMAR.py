#!/usr/bin/env python
#! -*- encoding: utf8 -*-
# 3.- Mono Library

import pickle
import random
import re
import sys

## Nombres: 

########################################################################
########################################################################
###                                                                  ###
###  Todos los métodos y funciones que se añadan deben documentarse  ###
###                                                                  ###
########################################################################
########################################################################



def sort_index(d):
    for k in d:
        l = sorted(((y, x) for x, y in d[k].items()), reverse=True)
        d[k] = (sum(x for x, _ in l), l)


class Monkey():

    def __init__(self):
        self.r1 = re.compile('[.;?!]')
        self.r2 = re.compile('\W+')


    def index_sentence(self, sentence, tri):
        #############
        # COMPLETAR 
        # coger la frase, limpiarla. minuscula. palabra, dolar principio y final, y computar las estadisticas, vamos, hacer los bi y añadirlos a index
        # si es tri, pues sacas los trigrama y te jodes#
        #############
        """
            Metodo que, pasandole una sentencia, por cada palabra saca sus posteriores y lo devuelve a compute_indexs
        """
        sentence = self.r2.sub(" ", sentence).lower()
        sentence = "$" + sentence + "$" 
        words = sentence.split()
        lista = {}
        for i in range(0,len(words)):
            if(len(words[i+1]) > 0): # no se si hace falta pero por si acaso
                lista[words[i]] = words[i+1] 
            else: 
                break
        return lista
        pass # sustituir por nuestro codigo


    def compute_index(self, filename, tri): # genera el indice
        self.index = {'name': filename, "bi": {}} 
        if tri:
            self.index["tri"] = {}
        raw_sentence = ""
        #############
        # COMPLETAR 
        # coger el fichero, abrilo, leer la frase y enviarla al index_Sentence#
        ############# -> sustituir
        with open(filename) as fh: 
            file = fh.read() #todo el fichero
            #of.replace('\n\n', '.').replace(';','.')...split('.') vamos quitando los fin de frase. MAL: te lees mil veces el puto quijote
            #utilizar el split de las expresiones regulares, ademas del sub, utilizar el split -> partir la cadena con todo aquello que hace matching con la expresión regular
            #montar una expresion regular 
            pl = {}
            file = self.r1.split(file) #devuelve separado por final, solo faltaría el \n\n
            for sentence in file:
                i = index_sentence(self, sentence, tri)
                if(i not in pl):
                    pl[i] += 1
                else:
                    pl[i] = 1
            index['bi'] = pl
        sort_index(self.index['bi'])
        if tri:
            sort_index(self.index['tri'])
        

    def load_index(self, filename):
        with open(filename, "rb") as fh:
            self.index = pickle.load(fh)


    def save_index(self, filename):
        with open(filename, "wb") as fh:
            pickle.dump(self.index, fh)


    def save_info(self, filename):
        with open(filename, "w") as fh:
            print("#" * 20, file=fh)
            print("#" + "INFO".center(18) + "#", file=fh)
            print("#" * 20, file=fh)
            print("filename: '%s'\n" % self.index['name'], file=fh)
            print("#" * 20, file=fh)
            print("#" + "BIGRAMS".center(18) + "#", file=fh)
            print("#" * 20, file=fh)
            for word in sorted(self.index['bi'].keys()):
                wl = self.index['bi'][word]
                print("%s\t=>\t%d\t=>\t%s" % (word, wl[0], ' '.join(["%s:%s" % (x[1], x[0]) for x in wl[1]])), file=fh)
            if 'tri' in self.index:
                print(file=fh)
                print("#" * 20, file=fh)
                print("#" + "TRIGRAMS".center(18) + "#", file=fh)
                print("#" * 20, file=fh)
                for word in sorted(self.index['tri'].keys()):
                    wl = self.index['tri'][word]
                    print("%s\t=>\t%d\t=>\t%s" % (word, wl[0], ' '.join(["%s:%s" % (x[1], x[0]) for x in wl[1]])), file=fh)


    def generate_sentences(self, n=10):
        #############
        # COMPLETAR 
        # todas las frases comienzan en $ (siempre)
        # $ => 11 => sapm:5, egg:5, lobster:1 -> Tiramos un "dado" (un random) de 11 caras y si sale del 1-5 spam, 6-10 egg, 11 lobster
        # si no le pasamos argumento, n es 10 es palabras por defecto en una frase#
        #############
        pass # sustituir por nuestro codigo


if __name__ == "__main__":
    print("Este fichero es una librería, no se puede ejecutar directamente")


#Ejemplo con SPAM#
# Probablemente la frase que generemos empezará con SPAM o EGG
# La idea es tener un diccionario de palabras cuyo valor será
# otro diccionarió cuyo valores serán las palabrás que vayan después de ella (con el numero de veces que aparecen despues)
# Ejemplo-> [Egg : [bacon:5, and:3, x:2],...]
# No las escribira al azar, si no con las probabilidades, esperando  que escriba algo, mas o menos sensato
# Si modificamos algo que no sea del _lib, subirlo también
# Rellenar y documentar cada metodo: """ comentario """
# Lo que marca final de frase -> pag.8 
# "frase" -> tambien son frases los titulos. en mini_quijote, TASA es una frase 
# los $ son tokens
# ejemplo:
#   $ | hola | que | tal | $
#   $  -> {hola: x, ...}
#   hola -> {que: y, ...}
#   que -> {tal: z, ...}
#   tal -> {$: w, ...}
# egg and bacon; -> frase (; dice que termina la frase)
# ejemplo de .info -> $ => 11 (a aparecido en todo el fichero) => (lista de palabras que van despues)  
# pickle -> permite grabar en disco un objeto de python en binario diap.16
# elegir la palabra siguiente diap.17
# AMPLIACION -> tus muertos cabrón de mierda, ni que solo tuviesemos está mierda asquerosa solo. ODIO LA PUTA UNIVERSIDAD 
# TRIGRAMAS DICE EL PUTO VIEJO CABRON
# CABRON 
# BORRAR ESTO EN CUANTO TE DES CUENTA MARICA 
# TRIGRAMA: es un bigrama con mierda
# Ahora de verdad. Conjunto de tres palabras consecutivas, las dos primeras, y la tercera es la que viene despues de las dos juntos 
# ($ egg) -> [and: x, ...]
# (and bacon) -> [$: y, ...]
# No puedes generar frases con trigramas, primero te apoyas en los bigramas y despues te vas al trigrama -> mirar las referencias, no es complicado, creo
# los binarios no tienen que coincidir (.index) 
# que tenemos que tocar? nuestro rabo. BABOSO
# El puto maricon pijo de mierda es tonto#
