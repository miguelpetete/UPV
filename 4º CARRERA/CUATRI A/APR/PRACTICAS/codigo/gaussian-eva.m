#!/usr/bin/octave
if (nargin!=7) printf("mge.sh X xl Y yl Ks as Ds\n"); exit(1);end
arg_list=argv(); fX=arg_list{1}; load(fX); fxl=arg_list{2}; fY = arg_list{3}; load(fY); fyl = arg_list{4}; load(fyl);
load(fxl); K=str2num(arg_list{5}); a=str2num(arg_list{6});D=str2num(arg_list{7});
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
	for i=1:length(a)
		for k=1:length(K)
			ed = [ed mixgaussian(proyXt,xl,proyXd,yl,K(k),a(i))];
		#printf("%3d %.1e %7.2f %3d\n",K(k),a(i),ed, d);
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

