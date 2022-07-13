#!/usr/bin/octave -qf

if (nargin!=5)
printf("Usage: pca+knn-eva.m <trdata> <trlabels> <tedata> <telabels> <k>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
k=str2num(arg_list{5});

load(trdata);
load(trlabs);
load(tedata);
load(telabs);

N=rows(X);
rand("seed",23); 
permutation=randperm(N);
X=X(permutation,:); 
xl=xl(permutation,:);

[m,W] = pca(X);
XpR = (X - m)*W(:,1:k);
YpR = (Y - m)*W(:,1:k);
error = knn(XpR, xl, YpR, yl, 1);
err1 = knn(X, xl, Y, yl, 1);
printf("Error PCA: %f. Error no PCA: %f \n",error,err1);


