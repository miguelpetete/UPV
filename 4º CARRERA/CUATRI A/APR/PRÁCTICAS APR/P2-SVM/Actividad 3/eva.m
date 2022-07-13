#!/usr/local/bin/octave -qf
if (nargin!=11)printf("experiment.m X xl pcaKs cs ts ds gs tr%% dv%% Y yl\n"); exit(1);end;
arg_list=argv();
fX=arg_list{1};load(fX);fxl=arg_list{2};load(fxl);
pcaKs=str2num(arg_list{3})
cs=str2num(arg_list{4});ts=str2num(arg_list{5});
ds=str2num(arg_list{6});gs=str2num(arg_list{7});
tp=str2num(arg_list{8}); dp=str2num(arg_list{9});
fY=arg_list{10}; load(fY); fyl=arg_list{11}; load(fyl);
N=rows(X);seed=23; rand("seed",seed); p=randperm(N);
X=X(p,:); X=X/255; xl=xl(p,:);
Nt=round(tp/100*N);Nd=round(dp/100*N);
Xt=X(1:Nt,:); xlt=xl(1:Nt);
Xd=X(N-Nd+1:N,:); xld=xl(N-Nd+1:N);
addpath("svm_apr");
proyXd=Xdm*Wp;
[m W]=pca(Xt); Xt=Xt-m; Xd=Xd-m;
printf("\t T \t  C \t  D \t ac \n");
res = svmtrain(xlt, xtPCA, ["-q -t ", num2str(ts), " -c ", num2str(cs), " -d ", num2str(ds)]);
[pred, acc, d] = svmpredict(yl, Y, res, '-q');
ac = acc(1); confianza = 1.96* sqrt((ac * (1-ac))/N);
c1=ac+confianza; c2=ac-confianza;
printf("%d \t %d \t %d \t --- \t %3f \t [%3f-%3f]  \n",ts(j),cs(c),ds(i),ac,c1,c2);
