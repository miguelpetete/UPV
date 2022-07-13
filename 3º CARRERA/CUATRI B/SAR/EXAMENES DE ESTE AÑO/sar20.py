

# ===========================================================================================
# 					DATA 
# ===========================================================================================
# Documentos relevantes
A = [3,5,18,22,35,40,41,63,80,89]

# Lo que devuelve el sistema de recuperacion
B = [89, 22, 93, 40, 4, 7, 18, 63, 62, 19, 2, 76]

# BETA
BETA = 1

# PRESICION AT
PRESICION_AT = 8




# ACTIVAR EXTRA
EXTRA = True

# PERMUTERM & QUERYS
PERMUTERM = 'garza'
QUERYS = ['ga*za','*rza']

Recall = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
# ===========================================================================================
# ===========================================================================================
# ===========================================================================================
# ===========================================================================================

def intersect(a= [], b= []):
	A = sorted(a)
	B = sorted(b)
	C = []
	#   We will use two pointers in the list to compare, i and j
	i = j = 0
	a = len(A) 
	b = len(B) 
	while i < a and j < b:
		if A[i] == B[j]:
			C.append(A[i])
			i += 1; j += 1
		elif A[i] < B[j]:
			i +=1
		else:
			j += 1
	return C

def precision(a = [], b = []):
	A = sorted(a)
	B = sorted(b)
	dRelRec = len(intersect(A,B))
	recuperados = len(B)
	return dRelRec / recuperados

def recall(a = [], b= []):
	A = sorted(a)
	B = sorted(b)
	dRelRec = len(intersect(A,B))
	relevantes = len(A)
	return dRelRec / relevantes

def fMedia(a = [], b = [], beta = BETA):
	A = sorted(a)
	B = sorted(b)
	p = precision(A,B)
	r = recall(A,B)
	return ((beta**2 + 1) * p * r) / ((beta**2) * p + r)

def tolinea(A= []):
	sol = ''
	for i in A:
		sol += " "+str(i) + " "* (6 - len(str(i))) +"|"
	return sol

def tablaPreci(relevante = [], recuperado = []):
	sol = []
	sumar = []
	for i in recuperado:
		if i in relevante:
			sol.append("Y")
			sumar.append(True)
		else:
			sol.append("N")
			sumar.append(False)

	print("="*11+"="*8*len(recuperado))
	print("S1       |", tolinea([i for i in range(1, len(recuperado)+1)]))
	print("Relevante|", tolinea(sol))

	# Imprimo precision
	pres1 = []
	pres2 = []
	unidad = 0
	for i in range(1,len(recuperado)+1):
		if sumar[i-1]:
			unidad += 1
			pres1.append((str(unidad)+"/"+str(i)+"="))
			pres2.append(round(unidad / i,3))
		else:
			pres1.append((str(unidad)+"/"+str(i)+"="))
			pres2.append(round(unidad / i,3))

	print("-"*11+"-"*8*len(recuperado))
	print("Precision|", tolinea(pres1))
	print("         |", tolinea(pres2))
	print("-"*11+"-"*8*len(recuperado))
	
	# Recall
	pres3 = []
	pres4 = []
	unidad = 0
	for i in range(1,len(recuperado)+1):
		if sumar[i-1]:
			unidad += 1
			pres3.append((str(unidad)+"/"+str(len(relevante))+"="))
			pres4.append(round(unidad / len(relevante),3))
		else:
			pres3.append((str(unidad)+"/"+str(len(relevante))+"="))
			pres4.append(round(unidad / len(relevante),3))
			
	print("Recall   |", tolinea(pres3))
	print("         |", tolinea(pres4))
	print("*"*11+"*"*8*len(recuperado))
	# Precision S1
	precisionS1 = []
	
	for i in Recall:
		for j in range(len(pres4)):
			if pres4[j] >= i:
				pos = j
				# busco al mayor
				mayor = 0
				for k in range(pos, len(pres2)):
					if pres2[k] > mayor:
						mayor = pres2[k]
				precisionS1.append(mayor)
				break 
	precisionS1 = precisionS1 + [0 for i in range(len(Recall)-len(precisionS1))]
	print("Preci.S1 |",tolinea(precisionS1))
	print("Recall   |", tolinea(Recall))
	print("="*11+"="*8*len(recuperado))
	print("> (MAP) Precision media del sistema  >>>  (sum(PrecisionS1) / longitudRelevantes) = ", \
		str(round(sum([pres2[i] for i in range(len(pres2)) if sumar[i]])/len(relevante),3)))
	rel = 0
	for i in range(len(relevante)):
		if sumar[i] == True:
			rel += 1


	print("> R-PRESICION del sistema  >>  (Relevantes_hasta_len(relevantes) / docs_relevantes) = ", round(rel/len(relevante),3))
	print("> PRESICION AT ",PRESICION_AT," >>  (Relevantes_hasta_len(relevantes) / docs_relevantes) = ", round(pres2[PRESICION_AT-1],3))


# Helping Methods
def rotate(word):
	return word[1:] + word[0]

def search(word= '', permuterm= []):
	word = word[:-1]
	l = len(word)
	for p in permuterm:
		if word == p[:l]:
			return p
	return "Doesn't exist!"
'''
	Prints the output for all combinations of the permuterm
	@param: word to permut
	@param query to search
'''
def permuterm(WORD_PERMUTERM = 'costa$', QUERY_PERMUTERM = ['hel*o']):
	word = WORD_PERMUTERM+"$"
	permuterm = [word]
	print("\n\n","="*20,"PERMUTERM INDEX","="*20)
	# Permuterm Index different rotations
	for i in range(len(word)-1):
		word = rotate(word)
		permuterm.append(word)
	print("> Permuterm: El indice permuterm para el termino '", WORD_PERMUTERM, "' se construye añadiendo por la derecha el simbolo $ y construyendo todas las posibles combinaciones del termino:")
	print("> Permuterm: ",permuterm) 


	# Query searching
	for Query in QUERY_PERMUTERM: 
		query = Query +"$"
		rotations = [query]
		while query[-1] is not '*':
			query = rotate(query)
			rotations.append(query)
		print("-"*40)
		print("> Rotations for QUERY: ",rotations)
		print("> La busqueda que se realiza para '",Query,"' se obtiene añadiendo por la derecha el simbolo $ y haciendo rotaciones hasta conseguir que el simbolo * aparezca a la derecha, es decir: ", query)
		print("\n> Solution for QUERY: ", query, " -> Searching in Permuterm: ", search(query, permuterm))
	print(" ","="*56)




print("="*20,"DATOS","="*20)
print("A: ",A)
print("B: ",B,)
print("="*20,"SOLU ","="*20)
print("> Interseccion de A y B  >>  ", intersect(A,B))
print("-"*40)

print("> Precision  >>  (RelevantesRecuperados / reuperados) = ", precision(A,B))
print("-"*40)

print("> Recall  >>  (RelevantesRecuperados / relevantes) = ", recall(A,B))
print("-"*40)

print("> F-Media  >>  (2PR / P+ R) = ", round(fMedia(A,B, BETA),4))
print("-"*40)

print("TABLA PRECISION & RECALL REALES:")
tablaPreci(A,B)
print("-"*40)

if EXTRA:
	permuterm(PERMUTERM, QUERYS)

