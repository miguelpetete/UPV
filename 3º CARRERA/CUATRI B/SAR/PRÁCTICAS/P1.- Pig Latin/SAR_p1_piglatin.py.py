#!/usr/bin/env python
#! -*- encoding: utf8 -*-

# 1.- Pig Latin

# Authors:
    # Mykyta Grygoryev
    # Adrian Davia Garcia

import sys
import re
import os.path


class Translator():

    def __init__(self, punt=None):
        """
        Constructor de la clase Translator

        :param punt(opcional): una cadena con los signos de puntuación
                                que se deben respetar
        :return: el objeto de tipo Translator
        """
        if punt is None:
            self.re = re.compile("(\w+)([.,;?!]*)")
        else:
            self.re = re.compile("(\w+)(["+punt+"]*)")

    def translate_word(self, word):
        """
        Este método recibe una palabra en inglés y la traduce a Pig Latin

        :param word: la palabra que se debe pasar a Pig Latin
        :return: la palabra traducida
        """

        #sustituir
        vocals = "aeiouyAEIOUY"
        new_word = word
        if(type(word[0]) != str):
            new_word = word
        elif(word[0] in vocals):
            new_word = new_word + "ay"
        else:
            # Para las palabras que comienzan por consonantes,
            # se mueven todas las consonantes antes de la primera vocal al ﬁnal y se agrega la sílaba “ay”.
            # P.ej: mess -> essmay
            signo = False
            signos = [".",",",";","?","!"] 
            if(word[-1] in signos):
                 aux = word[-1]
                 word = word[0:-1]
                 new_word = word
                 signo = True
            for x in word:
                if(x in vocals):
                    if(new_word.isupper()):
                        new_word = new_word + "AY"
                    else:
                        new_word = new_word + "ay"   
                    if(signo == True): new_word += aux
                    return new_word
                else:
                    # cuando x no es una vocal, mueves el elemento al final y sigues con el bucle
                    new_word = new_word[1:] + x
            if(signo == True): new_word += aux
        return new_word

    def translate_sentence(self, sentence):
        """
        Este método recibe una frase en inglés y la traduce a Pig Latin

        :param sentence: la frase que se debe pasar a Pig Latin
        :return: la frase traducida
        """

        # sustituir
        lista = sentence.split() # lista del palabras de la sentencia
        aux = ""
        for x in lista:
            word = self.translate_word(x)
            aux = aux + word + " "
        new_sentence = aux

        return new_sentence

    def translate_file(self, filename):
        """
        Este método recibe un fichero y crea otro con su tradución a Pig Latin

        :param filename: el nombre del fichero que se debe traducir
        :return: True / False 
        """
        
        # rellenar
        if(os.path.exists("./"+filename) == False): #Comprobar si son uno o dos puntos
            print('Fichero no encontrado')
            return False
        else:
            fhRead = open(filename, "r")
            lines = fhRead.read()
            lines = lines.split('\n')
            nF = filename.split(".")
            fhWrite = open(nF[0] + "_latin." +nF[1] ,"w")
            new_sentence = ""
            for l in lines:
                new_sentence = self.translate_sentence(l)
                new_sentence = new_sentence + "\n"
                fhWrite.write(new_sentence)
            fhRead.close()
            fhWrite.close()
            return True
        

if __name__ == "__main__":
    if len(sys.argv) > 2:
        print('Syntax: python %s [filename]' % sys.argv[0])
        exit
    else:
        t = Translator()
        if len(sys.argv) == 2:
            t.translate_file(sys.argv[1])
        else:
            while True:
                sentence = input("ENGLISH: ")
                if len(sentence) < 2:
                    break
                print("PIG LATIN:", t.translate_sentence(sentence))