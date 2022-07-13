#!/Users/miguel_petete/bin/octave -qf

if (nargin!=5)
    printf("Usage: pca+knn-exp.m <trdata> <trlabels> <ks> <%%trper> <%%dvper>\n")
    exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
ks=str2num(arg_list{3});
trper=str2num(arg_list{4});
dvper=str2num(arg_list{5});

load(trdata);
load(trlabs);

N=rows(X);
rand("seed",23); 
permutation=randperm(N);
X=X(permutation,:); 
xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); 
xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); 
xldv=xl(N-Ndv+1:N);

%error de clasificacion por el vecino mas cercano

err = knn(Xtr, xltr, Xdv, xldv, 1);
%-------------------------------------------

[m, W] = pca(Xtr);
for i = ks;
    XtrP = (Xtr - m) * W(:,1:i);
    XdvP = (Xdv - m) * W(:,1:i);
    err = knn(XtrP, xltr, XdvP, xldv, 1);
    printf("%d       %f\n",i,err);
end

%Funcion para ejecutar el codigo
% ./pca+knn-exp.m train-images-idx3-ubyte.mat.gz train-labels-idx1-ubyte.mat.gz "[1 2 5 10 20 50 100 200 500]" 90 10
