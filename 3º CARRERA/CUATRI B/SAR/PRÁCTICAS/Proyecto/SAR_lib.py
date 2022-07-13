import json
from nltk.stem.snowball import SnowballStemmer
import os
import re
import math


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
        self.newsDate = {}
        self.newsKeyWords = {}
        self.numero_total_articulos = 0


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
                self.news[self.newid] = new['title']
                self.newsKeyWords[self.newid] = new['keywords']
                self.newsDate[self.newid] = new['date']
                content = new['article']
                # COMPLETAR: indexar el contenido de 'content'
                # Crear un indice invertido accesible por termino. Cada entrada contendra una lista
                # con las noticias en las que aparece ese termino.
                text = self.tokenize(content) # Contiene todos los tokens de una noticia dada
                # Creacion de las postinglist y la insercion de cada newid que le corresponda, la posting list tiene que estar ordenada
                for term in text:
                    if not term in self.index:
                        self.index[term] = set()
                    self.index[term].add(self.newid)
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
            stemmer = self.stemmer.stem(term)
            if not stemmer in self.sindex:
                self.sindex[stemmer] = set()
            self.sindex[stemmer].add(term)

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
                        self.ptindex[aux] = [term]
                    elif aux in self.ptindex:
                        self.ptindex[aux].append(term)
                    aux = aux[1:len(aux)] + aux[0]






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
            queryListForm = query.split()
            if len(queryListForm) == 1:
                res = self.get_posting(queryListForm[0])
            else:
                exitQueue = []
                functionStack = []
                for i in queryListForm:
                    if i == "AND" or i == "OR" or i == "(":
                        functionStack.insert(0, i)
                    elif i == ")":
                        while True:
                            aux = functionStack.pop()
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
                        variableStack.insert(0,aux)
                    elif i == "OR":
                        var1 = variableStack.pop()
                        var2 = variableStack.pop()
                        aux = self.or_posting(var1, var2)
                        variableStack.insert(0,aux)
                    elif i == "NOT":
                        var1 = variableStack.pop()
                        aux = self.reverse_posting(var1)
                        variableStack.insert(0,aux)
                    else:
                        variableStack.insert(0, self.get_posting(i))
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

        if(term in self.index.keys()):
            return self.index[term]
        if(use_stemming):
            get_stemming(term)
        else:
            print("no hemos conseguido nada. #l387")
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
        if ('*' in term):
            parts = term.split('*')
            #[ho,a]#
        else:
            parts = term.split('?')
        search = parts[1] + "$" + parts[0]
            #a$ho#
        lista = sorted(self.ptindex)
        izq = 0 # izq guarda el índice inicio del segmento
        der = len(lista) -1 # der guarda el índice fin del segmento
        while izq <= der:
            # el punto medio del segmento
            medio = (izq+der)/2
            # si el medio es igual al valor buscado, lo devuelve
            term = lista[medio]
            if search in term:
                term = self.ptindex[term]
                if term not in aux:
                    aux.append(term)
                izq = medio+1
            # si el valor del punto medio es mayor que x, sigue buscando
            # en el segmento de la izquierda: [izq, medio-1], descartando la
            # derecha
            elif lista[medio] > search:
                der = medio-1
            # sino, sigue buscando en el segmento de la derecha:
            # [medio+1, der], descartando la izquierda
            else:
                izq = medio+1
        for x in aux:
            postingList.append(self.get_posting(x))
        return postingList

    def reverse_posting(self, p):
        """
        NECESARIO PARA TODAS LAS VERSIONES

        Devuelve una posting list con todas las noticias excepto las contenidas en p.
        Util para resolver las queries con NOT.


        param:  "p": posting list


        return: posting list con todos los newid exceptos los contenidos en p

        """
        res = []
        for i in range(1, self.newid):
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
        restOfP1 = p1
        restOfP2 = p2
        i = 1
        j = 1
        booleanCondition = True
        if len(p1)>0 and len(p2)>0:
            while booleanCondition:

                if p1[i] == p2[j]:
                    res.append(p1[i])
                    del restOfP1[i]
                    del restOfP2[i]
                    i = i+1
                    j = j+1

                elif p1[i] < p2[j]:
                    res.append(p1[i])
                    del restOfP1[i]
                    i = i+1

                else:
                    res.append(p2[j])
                    del restOfP2[j]
                    j = j+1

                if i >= len(p1) or j >= len(p2):
                    booleanCondition = False

        if i >= len(p1):
            res.append(restOfP2)
        elif j >= len(p2):
            res.append(restOfP1)

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
        contador = 1
        if not(self.show_all) and len(result) > 10:
            result = result[0: 10]

        if self.use_ranking:
            #query_tokenizer se encarga de coger la consulta y eliminar los AND, OR y paréntesis de la consulta
            tok_query = query_tokenizer(query)
            result = self.rank_result(result, tok_query)


        for i in result:
            articuloParaImpresion = self.news[i] #aqui colocaremos el summary del articulo
            fechaDeArticuloParaImpresion  = self.newsDate[i]  #aqui colocaremos la fecha del articulo
            keywordsArticuloParaImpresion = self.newsKeyWords[i] # aqui colocaremos las keywords del documento

            print("#" + str(contador) + "(0)  (" + str(i) +  ")  (" + str(fechaDeArticuloParaImpresion) + ")  " + articuloParaImpresion + "  ("+ keywordsArticuloParaImpresion + ")"+ '\n')
            contador += 1


        ########################################
        ## COMPLETAR PARA TODAS LAS VERSIONES ##
        ########################################




    def rank_result(self, result, query):
        """
        NECESARIO PARA LA AMPLIACION DE RANKING

        Ordena los resultados de una query.

        param:  "result": lista de resultados sin ordenar
                "query": query, puede ser la query original, la query procesada o una lista de terminos


        return: la lista de resultados ordenada

        """
        normalizacion = 0
        if len(result)>0:
            for term in query:
                for articulo_query in result:
                    if articulo_query in self.weight[term]:
                        ftd[articulo_query][term] = self.weight[term][articulo_query] #ftd-> peso del término del query (term) dentro de la colección de resultados (result)
                        if ftd > 0:
                            tftd[articulo_query][term] = (1 + math.log(ftd[articulo_query][term], 10)) #calculamos tftd
                        else:
                             tftd[articulo_query][term] = 0
                        df[articulo_query][term] = len(self.weight[term].keys()) #calculamos df
                        N = len(self.docs)
                        if df[articulo_query][term]>0:
                            idf[articulo_query][term] = math.log((N)/(df[articulo_query][term]), 10) #calculamos idf
                        else:
                             idf[articulo_query][term] = 0
                         wtd[articulo_query][term] = tftd[articulo_query][term] * idf[articulo_query ][term] #calculamos wtd
                    else:
                        return result
        #calculamos L_Norm
        for articulo in result:
            for term in query:
                normalizacion += wtd[articulo][term]**2
            divisor = math.sqrt(normalización)
            for term in query:
                norm[articulo][term] = wtd[articulo][term] / divisor

        for term in query:
            for articulo in result:
                    coseno[term][articulo] += norm[articulo][term]
        ord_result[][] = []

        return ord_result

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
            if words[i]not in to_delete:
                terms.append(words[i])
        return terms
