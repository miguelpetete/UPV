#practica1
import numpy as np 
T=np.array([[0,0,0,.576],[0,0,1,.008],[0,1,0,.144],[0,1,1,.072],[1,0,0,.064],[1,0,1,.012],[1,1,0,.016],[1,1,1,.108]])
pd1c1=np.sum(T[np.where((T[:,0]==1) & (T[:,1]==1))[0],-1])
pc1=np.sum(T[np.where(T[:,1]==1)[0],-1])
pd1=np.sum(T[np.where(T[:,0]==1)[0],-1])
pc1d1=pc1*(pd1c1/pd1)
print('P(c=1|d=1)= %.5f' % pd1c1)
