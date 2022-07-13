#!/usr/local/bin/octave
if (nargin!=8) printf("script.sh X xl Y yl Ks as Ds tr\n"); exit(1); end
# X = Conjunto de entrenamiento
# xl = etiquetas conjunto de entrenamiento
# Y = conjunto de test
# yl = etiquetas conjunto de test
# Ks = número de componentes por mixtura (K = 1, 2, 5, 10, 20, 50, 100)
# as = (alphas) valores de suavizado
# tr%% = porcentaje de entrenamiento-validación
# Ds = dimensiones de PCA (D = 1, 2, 5, 10, 20, 50, 100)
arg_list=argv(); 
train = arg_list{1}; load(train); 
train_l = arg_list{2}; load(train_l);
test = arg_list{3}; load(test);
test_l = arg_list{4}; load(test_l);   
K=str2num(arg_list{5}); 
a=str2num(arg_list{6});
D=str2num(arg_list{7});
tp=str2num(arg_list{8});

N=rows(train); rand("seed",23); 
p=randperm(N); X=X(p,:); xl=xl(p,:);
Nt=round(tp/100*N); dp=100-tp
Nd=round(dp/100*N);
Xt=X(1:Nt,:); xlt=xl(1:Nt); Xd=X(N-Nd+1:N,:); xld=xl(N-Nd+1:N);
printf("\n  K   alpha dv-err\n--- ------- ------\n");

#PCA
[m, W] = pca(X);
Xtm = X;
Xdm = Y;
ed = [];
for d=D
	Wp=W(:,1:d);
	proyXt = Xtm * Wp;
	proyXd = Xdm * Wp;
	for i=a
		for k=K
			ed = [ed mixgaussian(proyXt,xl,proyXd,yl,k,a)];
		endfor
	endfor
endfor

for d=D
    for j=1:length(K)
        m=(ed(d-1)*length(K) + j)/100;
        s = sqrt(m*(1-m)/M);
        r = 1.96*s;
        printf("%3d %3d %6.3f [%.3f,%.3f]\n",pca_ks(k),ks(j),m*100,(m-r)*100,(m+r)*100);
    endfor
endfor



