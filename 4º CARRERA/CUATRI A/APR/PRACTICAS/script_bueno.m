addpath("svm_apr");
load "/Users/miguel_petete/Desktop/svm/CĒdigo/data/mini/trSep.dat"; 
load "/Users/miguel_petete/Desktop/svm/CĒdigo/data/mini/trlabels.dat"
%load"/Users/miguel_petete/Desktop/svm/CĒdigo/data/mini/tr.dat"; 
%load "/Users/miguel_petete/Desktop/svm/CĒdigo/data/mini/trlabels.dat"
res=svmtrain(xl,X,'-t 0 -c 1000');
mult_lag = res.sv_coef; indices = res.SVs;
z=mult_lag' * indices; z_ini=sign(res.sv_coef(1)) - z*res.SVs(1,:)';
x1 = [0:6]; x2 = -z(1)/z(2)*x1 - z_ini/z(2); x3 = -z(1)/z(2)*x1 - (z_ini-1)/z(2); x4 = -z(1)/z(2)*x1 - (z_ini+1)/z(2);
margin = 2./sqrt(z*z');
c = zeros(length(xl), 1); t = zeros(length(res.sv_indices), 1);
for i = 1:length(res.sv_indices)
    c(res.sv_indices(i)) = abs( (abs(res.sv_coef(i))==1000)*(1 - ( sign(res.sv_coef(i)) * (z*X(res.sv_indices(i),:)' + z_ini) )) );
    t(i) = c(res.sv_indices(i));
end
plot(
    X(xl==1,1),X(xl==1,2),"sg","markerfacecolor","g",
    X(xl==2,1),X(xl==2,2),"ob","markerfacecolor","b",
    %Representación de las fronteras y los márgenes
    x1,x2,"-k",
    x1,x3,"-m",
    x1,x4,"-c",
    res.SVs(t == 0, 1), res.SVs(t == 0, 2), "+k", "markersize", 15
);
set(gca, "xgrid", "on");
set(gca, "ygrid", "on");
axis([0, 5, 0, 6],"square");


