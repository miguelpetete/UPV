#!/usr/local/bin/octave
if (nargin!=7) printf("mge.sh X xl Y yl Ks as Ds\n"); exit(1);end
ed = [];
arg_list=argv(); 
data=arg_list{1}; load(data); 
labels=arg_list{2}; load(labels); 
fY = arg_list{3}; load(fY); 
fyl = arg_list{4}; load(fyl);
K=str2num(arg_list{5}); 
a=str2num(arg_list{6});
D=str2num(arg_list{7});

printf("\n K \t alpha \t error \t [it.conf] \n");

[m, W] = pca(X); Xtm = X; Xdm = Y;

for d=D
	Wp=W(:,1:d); xtr_p = Xtm * Wp; xdr_p = Xdm * Wp;
	for i=1:length(a)
		for k=1:length(K)
			ed = [ed mixgaussian(xtr_p,xl,xdr_p,yl,K(k),a(i))];
		endfor
	endfor
endfor

for d=D
    for j=1:length(K)
        m=(ed(d-1)*length(K) + j)/100; s = sqrt(m*(1-m)/M); r = 1.96*s;
        printf("%3d \t %3d \t %6.3f \t [%.3f,%.3f]\n",pca_ks(k),ks(j),m*100,(m-r)*100,(m+r)*100);
    endfor
endfor