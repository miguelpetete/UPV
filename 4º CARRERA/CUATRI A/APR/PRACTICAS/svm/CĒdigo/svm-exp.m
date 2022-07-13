#!/usr/bin/octave -qf
if (nargin!=7)printf("svm-exp.m X xl cs ts ds tr%% dv%%\n"); exit(1);end;
arg_list=argv();
fX=arg_list{1};load(fX);fxl=arg_list{2};load(fXl);
cs=str2num(arg_list{3});ts=str2num(arg_list{4});ds=str2num(arg_list{5});
tp=str2num(arg_list{6}); dp=str2num(arg_list{7});
N=rows(X);seed=23; rand("seed",seed); p=randperm(N);
X=X(p,:); xl=xl(p,:);
Nt=round(tp/100*N);Nd=round(dp/100*N);
Xt=X(1:Nt,:); xlt=xl(1:Nt);
Xd=X(N-Nd+1:N,:); xld=xl(N-Nd+1:N);
addpath("svm_apr");
printf("\n------- --- ------\n");
N=rows(Xd);
for k=1:length(cs)
    for j=1:length(ts)
        if ts(j) == 1
            for i=1:length(ds)
                res = svmtrain(xlt, Xt, ["-q -t ", num2str(ts(j)), " -c ", num2str(cs(k)), " -d ", num2str(ds(i))]);
                [pred, acc, d] = svmpredict(xld, Xd, res, '-q');
                p = acc(1) / 100;
	            int = 1.96* sqrt((p * (1-p))/N);
                printf("%d \t %d \t %d \t %3f \t %3f   \n",ts(j),cs(k),ds(i),p,int);
            end
        else
            res = svmtrain(xlt, Xt, ["-q -t ", num2str(ts(j)), " -c ", num2str(cs(k))]);
            [pred, acc, d] = svmpredict(xld, Xd, res, '-q');
            p = acc(1) / 100;
	        int = 1.96* sqrt((p * (1-p))/N);
            printf("%d \t %d \t %3f \t %3f   \n",ts(j),cs(k),p,int);
        endif
    end
end
%cs = [1 10 100 1000 10000]; 
%ts = [0 1 2 3];
%ds = [1 2 3 4 5];