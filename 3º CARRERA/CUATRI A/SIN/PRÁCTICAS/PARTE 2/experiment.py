#!/usr/bin/python
#trabajo realizado por Miguel Ángel Navarro Arenas y Javier Alarcón Sánchez.

import sys
import math
import numpy as np

from perceptron import perceptron
from confus import confus
from linmach import linmach

if len(sys.argv)!=4:
   print('Usage: %s <data> <alphas> <bs>' %sys.arg[0])
   sys.exit(1)

data = np.loadtxt(sys.argv[1])
alphas=np.fromstring(sys.argv[2],sep=' ')
bs=np.fromstring(sys.argv[3],sep=' ')

#Inicialización de los datos para obtener mínimos. 
error_min_por = 100.0
error_min_num = 100000  
b_max = -1.0
a_max = 0
k_min = 1000000
ite_min_fijado = 0
ite_max_fijado = 0
E_min = 100000

#Preparacion de los datos
N,L=data.shape
D=L-1
etiquetas=np.unique(data[:,L-1])
C=etiquetas.size
np.random.seed(23)
perm=np.random.permutation(N)
data=data[perm]

#División de los datos en entrenamiento(70%) y test(30%)
#AQUI ES DONDE DIVIDIMOS EL DATASHET, EN EL EXAMEN NOS PUEDEN HACER CAMBIARLO 
#Si queremos un 60%-40% -> NTr=int(round(.6*N))  
NTr=int(round(.7*N)) 
train=data[:NTr,:]
M=N-NTr
test=data[NTr:,:]

with open('salida.txt', 'a') as f:
    f.write('EJECUCIÓN DE: ')
    f.write(str(sys.argv[1]))
    f.write('\n')
    f.write('Alphas: ')
    f.write(sys.argv[2])
    f.write('\n')
    f.write('Betas: ')
    f.write(sys.argv[3])
    f.write('\n')
    f.write('#'*68)
    f.write('\n')
    f.write('#      a         b    E    k  Ete   Ete (%)         Ite    (%)      ')
    f.write('\n')
    f.write('#-------  --------  ---  ---  ---  --------   ----------------------')
    f.write('\n')
f.close()

print('#      a         b    E    k  Ete   Ete (%)         Ite    (%)      ');
print('#-------  --------  ---  ---  ---  --------   ----------------------');

for a in alphas:
    for b in bs:
        w,E,k = perceptron(train,b,a)
        rl = np.zeros((M,1))
        for n in range (M):
            rl[n] = etiquetas[linmach(w,np.concatenate(([1],test[n,:D])))]
        nerr,m = confus(test[:,L-1].reshape(M,1),rl)
        per=nerr/M
        per_por = per*100
        r=1.96*math.sqrt(per*(1-per)/M)
        ite_menor=(per-r)*100
        ite_mayor=(per+r)*100
        print('%8.1f  %8.1f  %3d  %3d  %3d  %8.1f   [%1f - %1f]' % (a,b,E,k,nerr,per_por,ite_menor,ite_mayor) )

        exit =[a,b,E,k,nerr,per_por,ite_menor,ite_mayor]
        with open('salida.txt','a') as f:
            f.write('%8.1f  %8.1f  %3d  %3d  %3d  %8.1f   [%1f - %1f]' % (a,b,E,k,nerr,per_por,ite_menor,ite_mayor))
            f.write('\n')
        f.close()

        
        

  
                
        
            

        
with open('salida.txt', 'a') as f:
    f.write('-'*68)
    f.write('\n')
    f.write('FIN DE EJECUCIÓN...')
    f.write('\n')
    f.write('#'*68)
    f.write('\n')
    f.write('\n')
f.close()