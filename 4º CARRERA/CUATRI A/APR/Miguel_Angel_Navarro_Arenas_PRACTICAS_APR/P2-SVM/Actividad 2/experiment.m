#!/usr/bin/octave -qf
if (nargin!=9)printf("experiment.m X xl pcaKs cs ts ds gs tr%% dv%%\n"); exit(1);end;
arg_list=argv();

fX=arg_list{1};load(fX);fxl=arg_list{2};load(fxl);
pcaKs=str2num(arg_list{3})
cs=str2num(arg_list{4});ts=str2num(arg_list{5});
ds=str2num(arg_list{6});gs=str2num(arg_list{7});
tp=str2num(arg_list{8}); dp=str2num(arg_list{9});
N=rows(X);seed=23; rand("seed",seed); p=randperm(N);
X=X(p,:); X=X/255; xl=xl(p,:);
Nt=round(tp/100*N);Nd=round(dp/100*N);
Xt=X(1:Nt,:); xlt=xl(1:Nt);
Xd=X(N-Nd+1:N,:); xld=xl(N-Nd+1:N);
addpath("svm_apr");
[m W]=pca(Xt); Xt=Xt-m; Xd=Xd-m;
printf("\n------- --- ------\n");
N=rows(Xd);
for k=1:length(pcaKs)
    printf("DIMENSION DE PCA: %3d\n", pcaKs(k));
    printf("T \t C \t D \t G \t Ac \t Int.Confianza \n ");
    xtPCA=Xt*W(:,1:pcaKs(k)); xdPCA=Xd*W(:,1:pcaKs(k));
    for c=1:length(cs)
        for j=1:length(ts)
            switch (ts(j))
                case 1
                    for i=1:length(ds)
                        res = svmtrain(xlt, xtPCA, ["-q -t ", num2str(ts(j)), " -c ", num2str(cs(c)), " -d ", num2str(ds(i))]);
                        [pred, acc, d] = svmpredict(xld, xdPCA, res, '-q');
                        ac = acc(1) / 100; confianza = 1.96* sqrt((ac * (1-ac))/N);
                        printf("%d \t %d \t %d \t --- \t %3f \t %3f   \n",ts(j),cs(c),ds(i),ac,confianza);
                    end
                case 0 
                    res = svmtrain(xlt, xtPCA, ["-q -t ", num2str(ts(j)), " -c ", num2str(cs(k))]);
                    [pred, acc, d] = svmpredict(xld, xdPCA, res, '-q');
                    ac = acc(1) / 100; confianza = 1.96* sqrt((ac * (1-ac))/N);
                    printf("%d \t %d \t --- \t --- \t %3f \t %3f   \n",ts(j),cs(k),ac,confianza);
                otherwise 
                    for i=1:length(gs)
                        res = svmtrain(xlt, xtPCA, ["-q -t ", num2str(ts(j)), " -c ", num2str(cs(k))," -g ", num2str(gs(i))]);
                        [pred, acc, d] = svmpredict(xld, xdPCA, res, '-q');
                        ac = acc(1) / 100; confianza = 1.96* sqrt((ac * (1-ac))/N);
                        printf("%d \t %d \t --- \t %d   \t %3f \t %3f   \n",ts(j),cs(c),gs(i),ac,confianza);
                    end
            endswitch
        end
    end
end