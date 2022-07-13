#!/usr/bin/local/octave
if (nargin!=7) printf("mge.sh X xl Ks as tr%% dv%% Ds\n"); exit(1);end
arg_list=argv(); 
data=arg_list{1}; load(data); 
labels=arg_list{2}; load(labels); 
Ks=str2num(arg_list{3});
a=str2num(arg_list{4});
tp=str2num(arg_list{5}); 
dp=str2num(arg_list{6}); 
D=str2num(arg_list{7});

N=rows(X); rand("seed",23); p=randperm(N); X=X(p,:); xl=xl(p,:);
Nt=round(tp/100*N); Nd=round(dp/100*N);
Xtr=X(1:Nt,:); xltr=xl(1:Nt); Xdr=X(N-Nd+1:N,:); xldr=xl(N-Nd+1:N);
printf("\n K \t alpha \t dv-err\t d \n");
[m, W] = pca(Xtr);
for d=D
	Wp=W(:,1:d); xtr_p = Xtr * Wp; xdr_p = Xdr * Wp;
	for i=1:length(a)
		for k=1:length(Ks)
			[ed]=mixgaussian(xtr_p,xltr,xdr_p,xldr,Ks(k),a(i));
		printf("%3d \t %.1e \t  %7.2f \t %3d\n",Ks(k),a(i),ed, d);
		endfor
	endfor
endfor