function n=dyn_round(n)
%redondeo dinamico

s=sign(n);
n=abs(n);
cd=10^floor(log10(n));
n=ceil(4*n/cd)*cd;
n=n*s/4;
%calcular limite superior, los logarimtos son para una forma de mas dinamica de redondear, por ejemplo 288 redonde a 300, pero 8 redondea a 10