#!/usr/bin/env python
#! -*- encoding: utf8 -*-
# 3.- Mono Library

import pickle
import random
import re
import sys
import math

## Nombres: 
#   Adrian Davia Garcia
#   Mykyta Grygoryev

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
        #self.r1 = re.compile('[.;?!]')
        self.r1 = re.compile('[|.|;|?|!|]|\n\n')
        self.r2 = re.compile('\W+')
        # self.r3 = re.compile('[\s\s]') # \s -> cualquier espacio (lo mismo que [ \t\n\r\f]). PROBLEMA que no solo coge \n



    def index_sentence(self, sentence, tri):
        sentence = "$ " + sentence + " $"
        sentence = self.r2.sub(" ", sentence).lower().split(" ")
        sentence[0] = '$'
        sentence[-1] = '$'
        #sentence = sentence.split(" ")
        anterior = ""
        for word in sentence:
            if(word not in self.index['bi'] and word != ""):
                self.index['bi'][word] = {}
            if(anterior != word and anterior != "" and word != ""):
                if (word not in self.index['bi'][anterior]):
                    self.index['bi'][anterior][word] = 1 
                else:
                    self.index['bi'][anterior][word] = self.index['bi'][anterior][word] + 1
            anterior = word
        if(tri):
            ## COMPLETAR ##
            # 1. coger de los bigramas cada uno de sus pares y crear tuplas con ellos
            for i in range(0,len(sentence)-2):
                w1,w2,w3 = sentence[i:i+3]
                tupla = (w1,w2)
                
                if(tupla not in self.index['tri'] and tupla != ("","")):
                    self.index['tri'][tupla] = {}
                if(w3 !=""):
                    if (w3 not in self.index['tri'][tupla]):
                        self.index['tri'][tupla][w3] = 1 
                    else:
                        self.index['tri'][tupla][w3] = self.index['tri'][tupla][w3] + 1
            

            # 2. con cada una de las tuplas buscar las palabras que le sigen
            # 3. hacer un contador de las palabras asociadas a cada tupla
            

    def compute_index(self, filename, tri):
        #fh = open(filename,"r",encoding='utf-8').read().replace('\n\n', '.').split(self.r1)
        #lines = self.r1.sub(" ", fh).split()
        self.index = {'name': filename, "bi": {}}
        if tri:
            self.index["tri"] = {}
        with open(filename,"r",encoding='utf-8') as fh:
            file = fh.read()
            file = self.r1.split(file)
            for sentence in file:
                if(sentence != ""):
                    self.index_sentence(sentence, tri)
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
        sentence = ""
        if('tri' in self.index):
            # Mirar que hace con los bi pero en principio es lo mismo lo unico
            # que ahora tendras que tener en cuenta que son tuplas para poder
            # generar frases
            tri = self.index['tri']
            keys = tri.keys()
            posInicio = [] 
            inicio = True
            nextTri = ""
            word = "$"
            for z in range(0,n-1):
                for i in keys:
                    if(i[0] == word):
                        triX = tri[i]
                        for x in range(0,triX[0]):
                            posInicio.append(i)
                word = random.choice(posInicio)
                if(inicio): 
                    sentence = word[1]
                    inicio = False
                nextWords = tri[word][1]
                palabras = []
                #Secuencia de todas las posibles palabras. Lo hacemos para el random
                for j in range(0,len(nextWords)):
                    nWord = nextWords[j][0]
                    nextWord = nextWords[j][1]
                    for x in range(0,nWord):
                        palabras.append(nextWord)
                #Obtenemos de la sec una palabra "random"
                word = random.choice(palabras)
                if(word == "$"): break
                sentence = sentence + " " + word 
        else:
            word = '$'
            for i in range(0,n):
                listaWordsNext = self.index['bi'][word][1]
                palabras = []
                #Secuencia de todas las posibles palabras. Lo hacemos para el random
                for j in range(0,len(listaWordsNext)):
                    nWord = listaWordsNext[j][0]
                    nextWord = listaWordsNext[j][1]
                    for x in range(0,nWord):
                        palabras.append(nextWord)
                #Obtenemos de la sec una palabra "random"
                word = random.choice(palabras)
                if(word == "$"): break
                sentence = sentence + " " + word
        print(sentence)

if __name__ == "__main__":
    print("Este fichero es una librería, no se puede ejecutar directamente")


