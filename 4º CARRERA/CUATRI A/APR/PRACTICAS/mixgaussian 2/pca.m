## Copyright (C) 2021 Elias
## Author: Elias Urios Alacreu
## Created: 2021-10-20

function [m, W] = pca(X)
	%Normalizamos la X
	m = mean(X);
	Xm = X - m;
	%Matriz de covarianza
	covar = (Xm'*Xm)/rows(Xm);
	[eigvec, eigval] = eig(covar);

	%Ordenamos los eigenvectors y los ordenamos
	[S, I] = sort(diag(eigval), "descend");
	W = eigvec(:, I);
endfunction
