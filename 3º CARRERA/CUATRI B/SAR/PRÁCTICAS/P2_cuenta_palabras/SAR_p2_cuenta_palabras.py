#!/usr/bin/env python
#! -*- encoding: utf8 -*-

# Authors:
    # Mykyta Grygoryev
    # Adrian Davia Garcia

# Implementada la ampliación de calculo de bigramas. 

########################################################################
########################################################################
###                                                                  ###
###  Todos los métodos y funciones que se añadan deben documentarse  ###
###                                                                  ###
########################################################################
########################################################################


## Tomar cada linea como una frase $ Hola qué tal $ usar los $ al principio y 
## al final para saber por que palabra empieza la frase y por cual acaba
import argparse
import re
import sys
import operator

def sort_dic_by_values(d, asc=True): #el asc=True no seria necesario, ya esta en forma ascendente con -a[1]
    return sorted(d.items(), key=lambda a: (-a[1], a[0])) #para ordenar por valor de forma ascendente -a[1] para que sea ascendente a es la clave

class WordCounter:

    def calcStopwords(self, words,stopwordsfile):
        #Leer stopwords y separar por lineas
        stopwords = open(stopwordsfile).read().split('\n')
        #aux = lista de palabras sin los stopwords
        aux = []
        for word in words: 
            if(word not in stopwords):
                aux.append(word)
        return aux

    def __init__(self):
        """
           Constructor de la clase WordCounter
        """
        self.clean_re = re.compile('\W+')

    def write_stats(self, filename, stats, use_stopwords, bigrams, full):
        """
        Este método escribe en fichero las estadísticas de un texto
            

        :param 
            filename: el nombre del fichero destino.
            stats: las estadísticas del texto.
            use_stopwords: booleano, si se han utilizado stopwords
            full: boolean, si se deben mostrar las stats completas

        :return: None
        """
        #simplemente escribe lo que le pasas para que quede como el ejemplo
        with open(filename, 'w', encoding = 'utf-8') as fh:
            fh.write('Lines: ' +  str(stats['nlines']) + "\n")
            without_with_stopwrods = " (including stopwords): "
            if(use_stopwords): 
                fh.write("Number words" + without_with_stopwrods + str(stats['nwords']) +"\n")
                without_with_stopwrods = " (without stopwords): " 
            fh.write("Number words" + without_with_stopwrods + str(stats['nwordsStopWords']) +"\n")
            fh.write("Vocabulary size: " + str(len(stats['word'])) + "\n")
            #Calcular todos los simbolos que hay en total
            valoresSymbol = stats['symbol'].values()
            nTotal = 0
            for value in valoresSymbol:
                nTotal += value
            fh.write("Number of symbols: " + str(nTotal) + "\n")
            fh.write("Number of different symbols: " + str(len(stats['symbol'])) +"\n")
            if(not full): 
                fh.write("Words (alphabetical order):\n")
                #Ordenamos el vocabulario por orden alfabetico
                words = sorted(stats['word'].items())
                cont = 0
                for word in words:
                    if(cont < 20):
                        fh.write("      " + word[0] + ": " + str(word[1]) + "\n")
                    else:
                        break 
                    cont += 1
                fh.write("      ... " + str(len(words)-20) + " more ...\n")
                fh.write("Words (by frequency):\n")
                #Ordenamos por orden de valores > a < 
                words = sorted(stats['word'].items(), key = operator.itemgetter(1), reverse=True)
                cont = 0
                for word in words:
                    if(cont < 20):
                        fh.write("      " + word[0] + ": " + str(word[1]) + "\n")
                    else:
                        break
                    cont += 1
                fh.write("      ... " + str(len(words)-20) + " more ...\n")
                fh.write("Symbols (alphabetical order):\n")
                #Ordenamos el vocabulario por orden alfabetico
                symbols = sorted(stats['symbol'].items())
                cont = 0
                for symbol in symbols:
                    if(cont < 20):
                        fh.write("      " + symbol[0] + ": " + str(symbol[1]) + "\n")
                    else: break
                    cont += 1
                fh.write("      ... " + str(len(symbols)-20) + " more ...\n")
                fh.write("Symbols (by frequency):\n")
                #Ordenamos por orden de valores > a < 
                symbols = sorted(stats['symbol'].items(), key = operator.itemgetter(1), reverse=True)
                cont = 0
                for symbol in symbols:
                    if(cont < 20):
                        fh.write("      " + symbol[0] + ": " + str(symbol[1]) + "\n")
                    else: break
                    cont += 1
                fh.write("      ... " + str(len(symbols)-20) + " more ...\n")


                #Escribir los biwords
                if(bigrams):
                    fh.write("Words pairs (alphabetical order):\n")
                    #Ordenamos el vocabulario por orden alfabetico
                    words = sorted(stats['biword'].items())
                    cont = 0
                    for word in words:
                        if(cont < 20):
                            fh.write("      " + word[0] +  ": " + str(word[1]) + "\n")
                        else:
                            break 
                        cont += 1
                    fh.write("      ... " + str(len(words)-20) + " more ...\n")
                    fh.write("Words pairs (by frequency):\n")
                    #Ordenamos por orden de valores > a < 
                    words = sorted(stats['biword'].items(), key = operator.itemgetter(1), reverse=True)
                    cont = 0
                    for word in words:
                        if(cont < 20):
                            fh.write("      " + word[0] +  ": " + str(word[1]) + "\n")
                        else:
                            break
                        cont += 1
                    fh.write("      ... " + str(len(words)-20) + " more ...\n")
                    fh.write("Symbols pairs (alphabetical order):\n")
                    #Ordenamos el vocabulario por orden alfabetico
                    symbols = sorted(stats['bisymbol'].items())
                    cont = 0
                    for symbol in symbols:
                        if(cont < 20):
                            fh.write("      " + symbol[0] +  ": " + str(symbol[1]) + "\n")
                        else: break
                        cont += 1
                    fh.write("      ... " + str(len(symbols)-20) + " more ...\n")
                    fh.write("Symbols pairs (by frequency):\n")
                    #Ordenamos por orden de valores > a < 
                    symbols = sorted(stats['bisymbol'].items(), key = operator.itemgetter(1), reverse=True)
                    cont = 0
                    for symbol in symbols:
                        if(cont < 20):
                            fh.write("      " + symbol[0] +  ": " + str(symbol[1]) + "\n")
                        else: break
                        cont += 1
                    fh.write("      ... " + str(len(symbols)-20) + " more ...\n")
            else:
                fh.write("Words (alphabetical order):\n")
                #Ordenamos el vocabulario por orden alfabetico
                words = sorted(stats['word'].items())
                for word in words:
                    fh.write("      " + word[0] + ": " + str(word[1]) + "\n")
                fh.write("Words (by frequency):\n")
                #Ordenamos por orden de valores > a < 
                words = sorted(stats['word'].items(), key = operator.itemgetter(1), reverse=True)
                for word in words:
                    fh.write("      " + word[0] + ": " + str(word[1]) + "\n")
                fh.write("Symbols (alphabetical order):\n")
                #Ordenamos el vocabulario por orden alfabetico
                symbols = sorted(stats['symbol'].items())
                for symbol in symbols:
                    fh.write("      " + symbol[0] + ": " + str(symbol[1]) + "\n")
                fh.write("Symbols (by frequency):\n")
                #Ordenamos por orden de valores > a < 
                symbols = sorted(stats['symbol'].items(), key = operator.itemgetter(1), reverse=True)
                for symbol in symbols:
                    fh.write("      " + symbol[0] + ": " + str(symbol[1]) + "\n")





                #Escribir los biwords 
                if (bigrams):
                    fh.write("Words pairs (alphabetical order):\n")
                #Ordenamos el vocabulario por orden alfabetico
                words = sorted(stats['biword'].items())
                for word in words:
                    fh.write("      " + word[0] +  ": " + str(word[1]) + "\n")
                fh.write("Words pairs (by frequency):\n")
                #Ordenamos por orden de valores > a < 
                words = sorted(stats['biword'].items(), key = operator.itemgetter(1), reverse=True)
                for word in words:
                    fh.write("      " + word[0] +  ": " + str(word[1]) + "\n")
                fh.write("Symbols pairs (alphabetical order):\n")
                #Ordenamos el vocabulario por orden alfabetico
                symbols = sorted(stats['bisymbol'].items())
                for symbol in symbols:
                    fh.write("      " + symbol[0] +  ": " + str(symbol[1]) + "\n")
                fh.write("Symbols pairs (by frequency):\n")
                #Ordenamos por orden de valores > a < 
                symbols = sorted(stats['bisymbol'].items(), key = operator.itemgetter(1), reverse=True)
                for symbol in symbols:
                    fh.write("      " + symbol[0] +  ": " + str(symbol[1]) + "\n")

        #para evitar hacer un close al final -> fh = open(filename,"w") pass fh.close()
            pass

    
    def file_stats(self, filename, lower, stopwordsfile, bigrams, full):
        """
        Este método calcula las estadísticas de un fichero de texto
            

        :param 
            filename: el nombre del fichero.
            lower: booleano, se debe pasar todo a minúsculas?
            stopwordsfile: nombre del fichero con las stopwords o None si no se aplican
            bigram: booleano, se deben calcular bigramas?
            full: booleano, se deben montrar la estadísticas completas?

        :return: None
        """
        # variables for results
        #tablas hash, no hay orden -> sort para el orden alfabetico, queda ordenar los valores esta en
        sts = {
                'nwords': 0,
                'nlines': 0,
                'word': {},
                'symbol': {},
                'nwordsStopWords': 0
                }

        if bigrams:
            sts['biword'] = {}
            sts['bisymbol'] = {}
            
        # default stats
        fh = open(filename,"r",encoding='utf-8')
        lines = fh.read()
        new_filename = ""
        #Pasar todo el contenido a minusculas 
        if(lower): 
            lines = lines.lower()
            new_filename = "l" + new_filename
        # conteo de lineas
        sts['nlines'] = len(lines.split('\n')) - 1

        words = self.clean_re.sub(" ", lines).split()
        sts['nwords'] = len(words)
        #Quitamos las stopwords de la lista de palabras
        if(stopwordsfile is not None): 
            new_filename += 's'
            words = self.calcStopwords(words,stopwordsfile)
        sts['nwordsStopWords'] = len(words)

        vocabulary = {}
        symbols = {}
        #Rellenamos el diccionario de vocabulario y simbolos 
        for word in words:
            if(word not in vocabulary):
                vocabulary[word] = 1
            else:
                vocabulary[word] = vocabulary[word] + 1
            for i in range(0, len(word)):
                symbol = word[i]
                if(symbol not in symbols):
                    symbols[symbol] = 1
                else:
                    symbols[symbol] = symbols[symbol] + 1   
        sts['symbol'] = symbols
        sts['word'] = vocabulary
        
        if(bigrams):
            #Rellenamos las listas de biwords y bisymbols
            bigramsList = {}
            bisymbolsList = {}
            # $ frase\n $
            for line in lines.split('\n'):
                words = self.clean_re.sub(" ", line).split()        
                words = self.calcStopwords(words,stopwordsfile)
                if(len(words) != 0):  words = ['$'] + words + ['$']
                for i in range(0, len(words)-1):
                    w1,w2 = words[i : i + 2]
                    bigram = w1 + " " + w2
                    if(bigram not in bigramsList):
                        bigramsList[bigram] = 1
                        for j in range(0,len(w1) - 1):
                            s1,s2 = w1[j : j + 2]
                            bisymbol = s1+s2
                            if(bisymbol not in bisymbolsList):
                                bisymbolsList[bisymbol] = 1
                            else:
                                bisymbolsList[bisymbol] = bisymbolsList[bisymbol] + 1
                        for j in range(0,len(w2) - 1):
                            s1,s2 = w2[j : j + 2]
                            bisymbol = s1+s2
                            if(bisymbol not in bisymbolsList):
                                bisymbolsList[bisymbol] = 1
                            else:
                                bisymbolsList[bisymbol] = bisymbolsList[bisymbol] + 1
                    else:
                        bigramsList[bigram] = bigramsList[bigram] + 1

            sts['biword'] = bigramsList
            sts['bisymbol'] = bisymbolsList
            new_filename += "b" 
        if(full): new_filename += "f"

        nFile = filename.split('.')
        final = "_stats.txt"
        if (new_filename != ""): new_filename = "_" + new_filename
        new_filename = nFile[0] + new_filename + final # cambiar
        self.write_stats(new_filename, sts, stopwordsfile is not None, bigrams, full)

    #DONE
    def compute_files(self, filenames, **args):
        """
        Este método calcula las estadísticas de una lista de ficheros de texto
            

        :param 
            filenames: lista con los nombre de los ficheros.
            args: argumentos que se pasan a "file_stats".

        :return: None
        """

        for filename in filenames:
            self.file_stats(filename, **args)

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Compute some statistics from text files.')
    parser.add_argument('file', metavar='file', type=str, nargs='+',
                        help='text file.')

    parser.add_argument('-l', '--lower', dest='lower', action='store_true', default=False, 
                    help='lowercase all words before computing stats.')

    parser.add_argument('-s', '--stop', dest='stopwords', action='store',
                    help='filename with the stopwords.')

    parser.add_argument('-b', '--bigram', dest='bigram', action='store_true', default=False, 
                    help='compute bigram stats.')

    parser.add_argument('-f', '--full', dest='full', action='store_true', default=False, 
                    help='show full stats.')

    args = parser.parse_args()
    wc = WordCounter()
    wc.compute_files(args.file, lower=args.lower, stopwordsfile=args.stopwords, bigrams=args.bigram, full=args.full)


    #EJEMPLOS:
        # import re
        # clean_re = re.compile('\W+') -> cualquier cadena no alfanumerica una o mas, para elminar lo que hace matching con esto
        # s = "Hola, qué tal?"
        # dir(clean_re)
        # help(clean_re.sub)
        # print(clean_re.sub("**", s))
        # print(clean_re.sub(" ", s)) -> eliminas los espacios
        # print(clean_re.sub(" ", s).split())
        # print(clean_re.sub(" ", s.lower).split())
        # 


        # para contar palabras
        # word=clean_re.sub(" ", s.lower).split()
        # for word in words
        #    print(word)
        #   for sy in word 
        #       print('\t',sy)


         # for word in words: -> te cuenta las palabras en la tabla hash
        #   print(word)
        #   cnt[word] = cnt.get(word, 0) + 1 -> falla el acceso si la palabra word no existe todavia, le dices que te devuelva un 0 si la palabra no esta
#       print(cnt)


        # si quieres calcular biwords
        # word= ["$"] +  clean_re.sub(" ", s.lower).split() + ["$"]
        # for i in range(len(words) - 1):
        #   w1, w2 = words[i : i + 2] -> creas una tupla de dos elementos
        #   //w2 = words[i+1]
        #   //(w1,w2) -> tupla, inmutable
        #   print(w1,w2)
        #   cnt[(w1,w2)] = cnt.get((w1,w2),0) + 1
        # print(cnt)



        # sts["word"] = sts["word"].get(w,0)+1