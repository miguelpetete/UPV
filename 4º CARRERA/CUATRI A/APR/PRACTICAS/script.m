addpath("svm_apr");

%load "../data/mini/trSep.dat"; load "../data/mini/trSeplabels.dat"
load"../data/mini/tr.dat"; load "../data/mini/trlabels.dat"

res=svmtrain(xl,X,'-t 0 -c 1');

lagrange = res.sv_coef;
vector_soporte = res.SVs;

theta=lagrange' * vector_soporte;
theta0=sign(res.sv_coef(1)) - theta*res.SVs(1,:)';


x1 = [0:6];
x2 = -theta(1)/theta(2)*x1 - theta0/theta(2);
x3 = -theta(1)/theta(2)*x1 - (theta0-1)/theta(2);
x4 = -theta(1)/theta(2)*x1 - (theta0+1)/theta(2);
margen = 2./sqrt(theta*theta');

toler = zeros(length(xl), 1);
toler_sv = zeros(length(res.sv_indices), 1);

for i = 1:length(res.sv_indices)
        toler(res.sv_indices(i)) = abs( (abs(res.sv_coef(i))==1000)*(1 - ( sign(res.sv_coef(i)) * (theta*X(res.sv_indices(i),:)' + theta0) )) );
        toler_sv(i) = toler(res.sv_indices(i));
end

plot(
    X(xl==1,1),X(xl==1,2),"sg","markerfacecolor","g",
    X(xl==2,1),X(xl==2,2),"or","markerfacecolor","r",
    x1,x2,"-k",
    x1,x3,"-r",
    x1,x4,"-b",
    res.SVs(toler_sv == 0, 1), res.SVs(toler_sv == 0, 2), "+k", "markersize", 15
);
set(gca, "xgrid", "on");
set(gca, "ygrid", "on");
axis([0, 5, 0, 6],"square");

