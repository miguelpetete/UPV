import json
from nltk.stem.snowball import SnowballStemmer
import os
import re
import math
from ALG import spellsuggest
import codecs

class SAR_Project:
    """
    Prototipo de la clase para realizar la indexacion y la recuperacion de noticias

        Preparada para todas las ampliaciones:
          parentesis + multiples indices + posicionales + stemming + permuterm + ranking de resultado

    Se deben completar los metodos que se indica.
    Se pueden añadir nuevas variables y nuevos metodos
    Los metodos que se añadan se deberan documentar en el codigo y explicar en la memoria
    """

    # lista de campos, el booleano indica si se debe tokenizar el campo
    # NECESARIO PARA LA AMPLIACION MULTIFIELD
    fields = [("title", True), ("date", False),
              ("keywords", True), ("article", True),
              ("summary", True)]


    # numero maximo de documento a mostrar cuando self.show_all es False
    SHOW_MAX = 10

    def __init__(self):
        """
        Constructor de la classe SAR_Indexer.
        NECESARIO PARA LA VERSION MINIMA

        Incluye todas las variables necesaria para todas las ampliaciones.
        Puedes añadir más variables si las necesitas

        """

        self.index = {} # hash para el indice invertido de terminos --> clave: termino, valor: posting list.
                        # Si se hace la implementacion multifield, se pude hacer un segundo nivel de hashing de tal forma que:
                        # self.index['title'] seria el indice invertido del campo 'title'.
        self.sindex = {} # hash para el indice invertido de stems --> clave: stem, valor: lista con los terminos que tienen ese stem
        self.ptindex = {} # hash para el indice permuterm.
        self.docs = {} # diccionario de terminos --> clave: entero(docid),  valor: ruta del fichero.
        self.weight = {} # hash de terminos para el pesado, ranking de resultados. puede no utilizarse
        self.news = {} # hash de noticias --> clave entero (newid), valor: la info necesaria para diferencia la noticia dentro de su fichero
        self.tokenizer = re.compile("\W+") # expresion regular para hacer la tokenizacion
        self.stemmer = SnowballStemmer('spanish') # stemmer en castellano
        self.show_all = False # valor por defecto, se cambia con self.set_showall()
        self.show_snippet = False # valor por defecto, se cambia con self.set_snippet()
        self.use_stemming = False # valor por defecto, se cambia con self.set_stemming()
        self.use_ranking = False  # valor por defecto, se cambia con self.set_ranking()
        self.numero_total_articulos = 0
        

        #################################
        #   Parte perteneciente a ALG   #
        #################################
        self.create_suggest = False
        self.use_trie = False
        self.use_suggester = False



    ###############################
    ###                         ###
    ###      CONFIGURACION      ###
    ###                         ###
    ###############################

    newid = 0
    docid = 0
    nDays = 0
    days = []


    def set_showall(self, v):
        """

        Cambia el modo de mostrar los resultados.

        input: "v" booleano.

        UTIL PARA TODAS LAS VERSIONES

        si self.show_all es True se mostraran todos los resultados el lugar de un maximo de self.SHOW_MAX, no aplicable a la opcion -C

        """
        self.show_all = v


    def set_snippet(self, v):
        """

        Cambia el modo de mostrar snippet.

        input: "v" booleano.

        UTIL PARA TODAS LAS VERSIONES

        si self.show_snippet es True se mostrara un snippet de cada noticia, no aplicable a la opcion -C

        """
        self.show_snippet = v


    def set_stemming(self, v):
        """

        Cambia el modo de stemming por defecto.

        input: "v" booleano.

        UTIL PARA LA VERSION CON STEMMING

        si self.use_stemming es True las consultas se resolveran aplicando stemming por defecto.

        """
        self.use_stemming = v


    def set_ranking(self, v):
        """

        Cambia el modo de ranking por defecto.

        input: "v" booleano.

        UTIL PARA LA VERSION CON RANKING DE NOTICIAS

        si self.use_ranking es True las consultas se mostraran ordenadas, no aplicable a la opcion -C

        """
        self.use_ranking = v

    def set_suggester(self, v):
        self.use_suggester = v

    def set_trieSugester(self, v):
        self.use_trie = v




    ###############################
    ###                         ###
    ###   PARTE 1: INDEXACION   ###
    ###                         ###
    ###############################


    def index_dir(self, root, **args):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Recorre recursivamente el directorio "root"  y indexa su contenido
        los argumentos adicionales "**args" solo son necesarios para las funcionalidades ampliadas

        """

        self.multifield = args['multifield']
        self.positional = args['positional']
        self.stemming = args['stem']
        self.permuterm = args['permuterm']
        self.set_stemming(self.stemming)


        #################################
        #   Parte perteneciente a ALG   #
        #################################
        self.create_suggest = args['trie']


        for dir, subdirs, files in os.walk(root):
            for filename in files:
                if filename.endswith('.json'):
                    fullname = os.path.join(dir, filename)
                    self.index_file(fullname)





        ##########################################
        ## COMPLETAR PARA FUNCIONALIDADES EXTRA ##
        ##########################################


    def index_file(self, filename): # ACABADO
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Indexa el contenido de un fichero.

        Para tokenizar la noticia se debe llamar a "self.tokenize"

        Dependiendo del valor de "self.multifield" y "self.positional" se debe ampliar el indexado.
        En estos casos, se recomienda crear nuevos metodos para hacer mas sencilla la implementacion

        input: "filename" es el nombre de un fichero en formato JSON Arrays (https://www.w3schools.com/js/js_json_arrays.asp).
                Una vez parseado con json.load tendremos una lista de diccionarios, cada diccionario se corresponde a una noticia

        """

        #
        # "jlist" es una lista con tantos elementos como noticias hay en el fichero,
        # cada noticia es un diccionario con los campos:
        #      "title", "date", "keywords", "article", "summary"
        #
        # En la version basica solo se debe indexar el contenido "article"
        #
        #
        #
        #################
        ### ACABADO ###
        #################

        with open(filename) as fh:

            jlist = json.load(fh)
            # COMPLETAR: asignar identificador al fichero 'filename'
            self.docid = self.docid + 1
            self.docs[self.docid] = filename
            for new in jlist:
                # COMPLETAR: asignar identificador a la notica 'new'
                self.newid = self.newid + 1
                if(new['date'] not in self.days):
                    self.days.append(new['date'])
                    self.nDays += 1
                self.news[self.newid] = {}
                self.news[self.newid]['Title'] = new['title']
                self.news[self.newid]['Date'] = new['date']
                self.news[self.newid]['Keywords'] = new['keywords']
                self.news[self.newid]['Article'] = new['article']
                content = new['article']
                # COMPLETAR: indexar el contenido de 'content'
                # Crear un indice invertido accesible por termino. Cada entrada contendra una lista
                # con las noticias en las que aparece ese termino.
                text = self.tokenize(content) # Contiene todos los tokens de una noticia dada
                # Creacion de las postinglist y la insercion de cada newid que le corresponda, la posting list tiene que estar ordenada
                for term in text:
                    if(term not in self.index):
                        self.index.setdefault(term, [])
                    if (self.newid not in self.index[term]):
                        self.index.setdefault(term,[]).append(self.newid)
                    #if not term in self.index:
                        #self.index[term] = []
                    #self.index[term].append(self.newid)
                    if (term not in self.weight):
                        self.weight[term] = {}
                        self.weight[term][self.newid] = 1
                    else:
                        if (self.newid in self.weight[term]):
                            self.weight[term][self.newid] += 1
                        else:
                            self.weight[term][self.newid] = 1
        if(self.use_stemming == True):
            self.make_stemming()
        if(self.permuterm == True):
            self.make_permuterm()



    def tokenize(self, text):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Tokeniza la cadena "texto" eliminando simbolos no alfanumericos y dividientola por espacios.
        Puedes utilizar la expresion regular 'self.tokenizer'.

        params: 'text': texto a tokenizar

        return: lista de tokens

        """
        return self.tokenizer.sub(' ', text.lower()).split()


    #################
    ###  ACABADO  ###
    #################
    def make_stemming(self):
        """
        NECESARIO PARA LA AMPLIACION DE STEMMING.

        Crea el indice de stemming (self.sindex) para los terminos de todos los indices.

        self.stemmer.stem(token) devuelve el stem del token

        """
        # Para cada termino sacar su stemmer
        for term in self.index:
            stem = self.stemmer.stem(term)
            #if not stem in self.sindex:
            self.sindex.setdefault(stem,[]).append(term)
            #self.sindex[stem].append(term)

        ####################################################
        ## COMPLETAR PARA FUNCIONALIDAD EXTRA DE STEMMING ##
        ####################################################


    def make_permuterm(self): ##Completado##
        """
        NECESARIO PARA LA AMPLIACION DE PERMUTERM

        Crea el indice permuterm (self.ptindex) para los terminos de todos los indices.

        """
        for term in self.index:
            if (term != ""):
                aux = term+"$"
                for i in range(0,len(aux)):
                    if aux not in self.ptindex:
                        self.ptindex[aux] = term
                    aux = aux[1:len(aux)] + aux[0]


    #################################
    #   Parte perteneciente a ALG   #
    #################################
    def createVocab(self):
        if(self.create_suggest):
            self.exportIndex()
            self.make_vocab()
            self.make_trie()

    def exportIndex(self):
        f = codecs.open("index","w", "utf-8")
        f.write(str(self.index.keys()))
        f.close()

    def make_trie(self):
        self.spellSuggesterTrie = spellsuggest.TrieSpellSuggester("./index")

    def make_vocab(self):
        self.spellSuggester = spellsuggest.SpellSuggester("./index")
        




    def show_stats(self):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Muestra estadisticas de los indices

        """
        stats = "========================================\nNumber of indexed days: "

        stats = stats + str(self.nDays) + "\n----------------------------------------\nNumber of indexed news: " + str(self.newid) + "\n"
        stats = stats + "TOKENS:\n             # of tokens in 'article': " + str(len(self.index))
        if (self.use_stemming == True):
            stats = stats + "\n----------------------------------------\nSTEMS:\n             # of stems in 'article': " + str(len(self.sindex))
        if (self.permuterm == True):
            stats = stats + "\n----------------------------------------\nPERMUTERM:\n             # of stems in 'article': " + str(len(self.ptindex))
        stats = stats + "\n----------------------------------------\nPositional queries are NOT allowed\n========================================\n"
        print(stats)
        ########################################
        ## COMPLETAR PARA TODAS LAS VERSIONES ##
        ########################################










    ###################################
    ###                             ###
    ###   PARTE 2.1: RECUPERACION   ###
    ###                             ###
    ###################################


    def solve_query(self, query, prev={}):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Resuelve una query.
        Debe realizar el parsing de consulta que sera mas o menos complicado en funcion de la ampliacion que se implementen


        param:  "query": cadena con la query
                "prev": incluido por si se quiere hacer una version recursiva. No es necesario utilizarlo.


        return: posting list con el resultado de la query

        """
        if query is None or len(query) == 0:
            return []

        else:
            query = query.replace("(", " ( ")
            query = query.replace(")", " ) ")
            queryListForm = query.split()
            if len(queryListForm) == 1:
                res = self.get_posting(queryListForm[0])
            else:
                exitQueue = []
                functionStack = []
                reversedStack = []
                for i in queryListForm:
                    if i == "AND" or i == "OR": #or i == "NOT" or i == "(":
                        for j in reversedStack:
                            if(j == "AND" or j == "OR" or j == "NOT"):
                                aux = functionStack.pop()
                                reversedStack = reversedStack[1:len(reversedStack)]
                                exitQueue.append(aux)
                            elif (j == "("):
                                break
                        functionStack.append(i)
                        reversedStack.insert(0,i)
                    elif i == "NOT" or i == "(":
                        functionStack.append(i)
                        reversedStack.insert(0,i)
                    elif i == ")":
                        while True:
                            aux = functionStack.pop()
                            reversedStack = reversedStack[1:len(reversedStack)]
                            if aux == "(":
                                break
                            else:
                                exitQueue.append(aux)
                    else:
                        exitQueue.append(i)
                functionStack.reverse()
                exitQueue = exitQueue + functionStack

                variableStack = []
                for i in exitQueue:
                    if i == "AND":
                        var1 = variableStack.pop()
                        var2 = variableStack.pop()
                        aux = self.and_posting(var1, var2)
                        variableStack.insert(len(variableStack),aux)
                    elif i == "OR":
                        var1 = variableStack.pop()
                        var2 = variableStack.pop()
                        aux = self.or_posting(var1, var2)
                        variableStack.insert(len(variableStack),aux)
                    elif i == "NOT":
                        var1 = variableStack.pop()
                        aux = self.reverse_posting(var1)
                        variableStack.insert(len(variableStack),aux)
                    else:
                        variableStack.insert(len(variableStack), self.get_posting(i))
                res = variableStack.pop()
        return res


        ########################################
        ## COMPLETAR PARA TODAS LAS VERSIONES ##
        ########################################



    def get_posting(self, term, field='article'):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Devuelve la posting list asociada a un termino.
        Dependiendo de las ampliaciones implementadas "get_posting" puede llamar a:
            - self.get_positionals: para la ampliacion de posicionales
            - self.get_permuterm: para la ampliacion de permuterms
            - self.get_stemming: para la amplaicion de stemming


        param:  "term": termino del que se debe recuperar la posting list.
                "field": campo sobre el que se debe recuperar la posting list, solo necesario se se hace la ampliacion de multiples indices

        return: posting list

        """
        if('*' in term or '?' in term):
            return self.get_permuterm(term)
        elif (self.use_stemming):
            return self.get_stemming(term)
        elif (term in self.index.keys()):
                return self.index[term]
        else:
            return []
        ########################################
        ## COMPLETAR PARA TODAS LAS VERSIONES ##
        ########################################



    def get_positionals(self, terms, field='article'):
        """
        NECESARIO PARA LA AMPLIACION DE POSICIONALES

        Devuelve la posting list asociada a una secuencia de terminos consecutivos.

        param:  "terms": lista con los terminos consecutivos para recuperar la posting list.
                "field": campo sobre el que se debe recuperar la posting list, solo necesario se se hace la ampliacion de multiples indices

        return: posting list

        """
        pass
        ########################################################
        ## COMPLETAR PARA FUNCIONALIDAD EXTRA DE POSICIONALES ##
        ########################################################

    #################
    ###  ACABADO  ###
    #################
    def get_stemming(self, term, field='article'):
        """
        NECESARIO PARA LA AMPLIACION DE STEMMING

        Devuelve la posting list asociada al stem de un termino.

        param:  "term": termino para recuperar la posting list de su stem.
                "field": campo sobre el que se debe recuperar la posting list, solo necesario se se hace la ampliacion de multiples indices

        return: posting list

        """

        aux = []
        stem = self.stemmer.stem(term)
        if(stem in self.sindex):
            aux.append(stem)
        return aux

        ####################################################
        ## COMPLETAR PARA FUNCIONALIDAD EXTRA DE STEMMING ##
        ####################################################


    def get_permuterm(self, term, field='article'):
        """
        NECESARIO PARA LA AMPLIACION DE PERMUTERM

        Devuelve la posting list asociada a un termino utilizando el indice permuterm.

        param:  "term": termino para recuperar la posting list, "term" incluye un comodin (* o ?).
                "field": campo sobre el que se debe recuperar la posting list, solo necesario se se hace la ampliacion de multiples indices

        return: posting list

        """
        ##Ejemplo: buscar ho*a##
        aux = []
        postingList = []
        longitud = len(term)
        separador = ''
        if ('*' in term):
            parts = term.split('*')
            separador = '*'
            #[ho,a]#
        else:
            parts = term.split('?')
            separador = '?'
        if (len(parts) > 2): return []
        search = parts[1] + "$" + parts[0]
            #a$ho#
        lista = sorted(self.ptindex)
        final = False
        x = 0
        while(x != -1):
            x = self.busqueda_binaria_recursiva(lista, search, 0, len(lista)-1)
            if (x != -1):
                termino = self.ptindex[lista[x]]
                if (self.ptindex[lista[x]] not in aux):
                    if (len(termino) == longitud and separador == '?'):
                        aux.append(termino)
                    elif (len(termino) >= longitud - 1 and separador == '*'):
                        aux.append(termino)
                lista.pop(x)

        for x in aux:
            postingX = self.index[x]
            for i in postingX:
                if (i not in postingList):
                    postingList.append(i)
        return postingList
    ##Metodo propio##
    def busqueda_binaria_recursiva(self, lista, search, izquierda, derecha):
        if izquierda > derecha:
            return -1
        mitad = (izquierda + derecha) // 2
        elementomitad = lista[mitad]
        if search in elementomitad:
            return mitad
        if search < elementomitad:
            return self.busqueda_binaria_recursiva(lista, search, izquierda, (mitad-1))
        else:
            return self.busqueda_binaria_recursiva(lista, search, (mitad+1), derecha)

    def reverse_posting(self, p):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Devuelve una posting list con todas las noticias excepto las contenidas en p.
        Util para resolver las queries con NOT.


        param:  "p": posting list


        return: posting list con todos los newid exceptos los contenidos en p

        """
        res = []
        p = sorted(p)
        for i in range(1, self.newid+1):
            if not i in p:
                res.append(i)

        return res

        ########################################
        ## COMPLETAR PARA TODAS LAS VERSIONES ##
        ########################################



    def and_posting(self, p1, p2):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Calcula el AND de dos posting list de forma EFICIENTE

        param:  "p1", "p2": posting lists sobre las que calcular


        return: posting list con los newid incluidos en p1 y p2

        """
        res = []
        i = 0
        j = 0
        p1 = sorted(p1)
        p2 = sorted(p2)
        booleanCondition = True
        if len(p1)>0 and len(p2)>0:
            while booleanCondition:

                if p1[i] == p2[j]:
                    res.append(p1[i])
                    i = i+1
                    j = j+1
                elif p1[i] < p2[j]:
                    i = i+1
                else:
                    j = j+1

                if i >= len(p1) or j >= len(p2):
                    booleanCondition = False

        return res

        ########################################
        ## COMPLETAR PARA TODAS LAS VERSIONES ##
        ########################################



    def or_posting(self, p1, p2):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Calcula el OR de dos posting list de forma EFICIENTE

        param:  "p1", "p2": posting lists sobre las que calcular


        return: posting list con los newid incluidos de p1 o p2

        """

        res = []
        restOfP1 = sorted(p1)
        restOfP2 = sorted(p2)
        booleanCondition = True
        if len(p1)>0 and len(p2)>0:
            while booleanCondition:

                if restOfP1[0] == restOfP2[0]:
                    res.append(restOfP1[0])
                    del restOfP1[0]
                    del restOfP2[0]


                elif restOfP1[0] < restOfP2[0]:
                    res.append(restOfP1[0])
                    del restOfP1[0]

                else:
                    res.append(restOfP2[0])
                    del restOfP2[0]

                if len(restOfP1) <= 0 or len(restOfP2) <= 0:
                    booleanCondition = False

        if len(restOfP1) < len(restOfP2):
            res = res + restOfP2
        elif len(restOfP2) < len(restOfP1):
            res = res + restOfP1

        return res

        ########################################
        ## COMPLETAR PARA TODAS LAS VERSIONES ##
        ########################################


    def minus_posting(self, p1, p2):
        """
        OPCIONAL PARA TODAS LAS VERSIONES

        Calcula el except de dos posting list de forma EFICIENTE.
        Esta funcion se propone por si os es util, no es necesario utilizarla.

        param:  "p1", "p2": posting lists sobre las que calcular


        return: posting list con los newid incluidos de p1 y no en p2

        """

        i = 1
        j = 1
        p1 = sorted(p1)
        p2 = sorted(p2)
        booleanCondition = True
        if len(p1)>0 and len(p2)>0:
            while booleanCondition:
                if p1[i] == p2[j]:
                    del p1[i]
                    i = i+1
                    j = j+1
                elif p1[i] < p2[j]:
                    i = i+1
                else:
                    j = j+1

                if i >= len(p1) or j >= len(p2):
                    booleanCondition = False
        return p1
        ########################################################
        ## COMPLETAR PARA TODAS LAS VERSIONES SI ES NECESARIO ##
        ########################################################





    #####################################
    ###                               ###
    ### PARTE 2.2: MOSTRAR RESULTADOS ###
    ###                               ###
    #####################################


    def solve_and_count(self, query):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Resuelve una consulta y la muestra junto al numero de resultados

        param:  "query": query que se debe resolver.

        return: el numero de noticias recuperadas, para la opcion -T

        """
        result = self.solve_query(query)
        if(len(result) == 0):
            if(self.use_suggester):
                result = self.applySuggester(query, False)
            elif(self.use_trie):
                result = self.applySuggester(query, True)
                
        print("%s\t%d" % (query, len(result)))
        return len(result)  # para verificar los resultados (op: -T)


    def solve_and_show(self, query):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Resuelve una consulta y la muestra informacion de las noticias recuperadas.
        Consideraciones:

        - En funcion del valor de "self.show_snippet" se mostrara una informacion u otra.
        - Si se implementa la opcion de ranking y en funcion del valor de self.use_ranking debera llamar a self.rank_result

        param:  "query": query que se debe resolver.

        return: el numero de noticias recuperadas, para la opcion -T

        """
        result = self.solve_query(query)
        if(len(result) == 0):
            if(self.use_suggester):
                result = self.applySuggester(query, False)
            elif(self.use_trie):
                result = self.applySuggester(query, True)


        contador = 1
        print("=====================" + "\n" +"Query:    " + query + "\n" + "number of results:    " + str(len(result)) + "\n")
        if self.use_ranking:
            #query_tokenizer se encarga de coger la consulta y eliminar los AND, OR y paréntesis de la consulta
            tok_query = self.query_tokenizer(query)
            rankedResult = self.rank_result(result, tok_query)
            orderedRankedResults = sorted(rankedResult, key=rankedResult.get, reverse=True)
            result = orderedRankedResults

        if not(self.show_all) and len(result) > 10:
            result = result[0: 10]



        for i in result:
            articuloParaImpresion = self.news[i]['Title'] #aqui colocaremos el titulo del articulo
            fechaDeArticuloParaImpresion  = self.news[i]['Date']  #aqui colocaremos la fecha del articulo
            keywordsArticuloParaImpresion = self.news[i]['Keywords'] # aqui colocaremos las keywords del documento
            if(self.use_ranking):
                score = round(rankedResult[i], 3)
            else:
                score = 0

            if not self.show_snippet:
                print("#" + str(contador) + "   " +   str(score)  + "   (" + str(i) +  ")  (" + str(fechaDeArticuloParaImpresion) + ")  " + articuloParaImpresion + "  ("+ 
                keywordsArticuloParaImpresion + ")" + '\n')
            else:
                snippets = self.snippetCalculator(i, query)
                print("#" + str(contador) + "\n" + "Score:    " + str(score) + "\n" + 
                str(i) + "\n" + "Date:    " + fechaDeArticuloParaImpresion + "\n" + "Title:    " + articuloParaImpresion + "\n" + 
                "Keywords" + keywordsArticuloParaImpresion + "\n" + snippets + "\n" + "----------" +"\n")
            contador += 1
            
        print("=====================" + "\n")


        ########################################
        ## COMPLETAR PARA TODAS LAS VERSIONES ##
        ########################################

    def snippetCalculator(self, newid, query):
        q = query.replace("AND", "")
        q = q.replace("OR", "")
        q = q.replace("(", "")
        q = q.replace(")", "")
        q = q.replace("NOT", "")
        q = self.tokenize(q)
        res = ""
        newsBody = self.news[newid]['Article']
        newsBodyNormalized = newsBody.lower()
        for i in q:
            startSnippet = 0
            endSnippet = len(newsBodyNormalized)
            wordLocation = newsBodyNormalized.find(i)
            if wordLocation > 30:
                startSnippet = wordLocation - 30 - (len(newsBodyNormalized[0: wordLocation - 30]) - newsBodyNormalized[0: wordLocation - 30].rfind(" "))
            if wordLocation < len(newsBodyNormalized) - 30:
                endSnippet = wordLocation + 30 + newsBodyNormalized[wordLocation + 30: len(newsBody)].find(" ")
            res = res + (newsBody[startSnippet: endSnippet]) + " ... "
        return res
                


    def rank_result(self, result, query):
        """
        NECESARIO PARA LA AMPLIACION DE RANKING

        Ordena los resultados de una query.

        param:  "result": lista de resultados sin ordenar
                "query": query, puede ser la query original, la query procesada o una lista de terminos


        return: la lista de resultados ordenada

        """
        normalizacion = 0
        wtd = {}
        norm = {}
        ord_result = {}
        df = {}
        idf = {}
        queryWithoutWrongElements = query.copy()
        if len(result)>0:
            for articulo_query in result:
                wtd[articulo_query] = {}
                for term in query:
                    if term in self.weight:
                        if articulo_query in self.weight[term]:
                            ftd = self.weight[term][articulo_query] #ftd-> peso del término del query (term) dentro de la colección de resultados (result)
                            if ftd > 0:
                                tftd = (1 + math.log(ftd, 10)) #calculamos tftd
                            else:
                                tftd = 0
                            df[term] = len(self.weight[term].keys()) #calculamos df
                            N = len(self.docs)
                            if df[term]>0:
                                idf[term] = math.log(N/df[term], 10) #calculamos idf
                            else:
                                idf[term] = 0
                            wtd[articulo_query][term] = tftd * idf[term] #calculamos wtd
                        else:
                            wtd[articulo_query][term] = 0
                    else:
                        queryWithoutWrongElements.remove(term)
                query = queryWithoutWrongElements
                
        
        # Calculo de l-norm para cada documento dentro de cada articulo
        for articulo in result:
            norm[articulo] = {}
            normalizacion = 0
            for term in query:
                normalizacion += wtd[articulo][term]**2
            divisor = math.sqrt(normalizacion)
            for term in query:
                norm[articulo][term] = wtd[articulo][term] / divisor
        
        #calculo de l-norm para la consulta
        norm["consulta"] = {}
        normalizacion = 0
        for term in query: 
            if term in idf:
                normalizacion += idf[term]**2
        divisor = math.sqrt(normalizacion)
        for term in query:
            if term in idf:
                norm["consulta"][term] = idf[term] / divisor 

        # Calculo de la similitud coseno entre el cada documento y la consulta
        lCoseno = {}
        for article in result:
            lCoseno[article] = 0
            for word in norm["consulta"]:
                    lCoseno[article] += norm[article][word] * norm["consulta"][word]
         
        return lCoseno

        ###################################################
        ## COMPLETAR PARA FUNCIONALIDAD EXTRA DE RANKING ##
        ###################################################



    def query_tokenizer(self, query):
        """
        'Tokeniza' la query, quitándole los AND y OR. Tampoco se le hace caso a lo que haya más alla del NOT.

        param:  "query": query, a tokenizar.

        return: palabras de la query que tenemos que estudiar para hacer ranking

        """
        terms = []
        to_delete = ['AND', 'NOT', 'OR']
        query = query.replace('(', '')
        query= query.replace(')','')
        words = query.split()
        for i in range(len(words)):
            if words[i]not in to_delete and words[i] not in terms:
                terms.append(words[i])
        return terms

        #################################
        #   Seccion de trabajo de ALG   #
        #################################

    def applySuggester(self, query, useTrie):
        oldQuery = query
        dictionaryWithSugestions = {}
        incorrectWord = []
        wordsWithoutConnectors = self.query_tokenizer(query)
        for word in wordsWithoutConnectors:
            result = self.solve_query(word)
            if (len(result) == 0):
                incorrectWord.append(word)
        for word in incorrectWord:
            if not useTrie:
                dictionaryWithSugestions[word] = self.spellSuggester.suggest(word) # es necesario agregar que distancia se va a usar y con que threshold
            elif useTrie:
                dictionaryWithSugestions[word] = self.spellSuggesterTrie.suggest(word) # es necesario agregar que distancia se va a usar y con que threshold
        for word in dictionaryWithSugestions.keys():
            for correctWord in dictionaryWithSugestions[word]:
                query = query + " OR (" + oldQuery.replace(word, correctWord) + ")"
        result = self.solve_query(query)
        return result


