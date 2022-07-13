S#!/usr/bin/octave -qf

function [m,W]=pca(X)
  m = mean(X);
  xm = X - m;
  cov = xm' * xm;
  [vecPropSinORden, valPropSinORden] = eig(cov);
  [valPropConORden, Index] = sort(diag(valPropSinORden), "descend");
  W = vecPropSinORden(:,Index);
end