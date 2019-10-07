function [p,Imld]=mld(S,T,P,dt)
%calcula la profundidad de la capa de mezcla Mix Layer Depth

if ~exist('dt','var')
    dt=0.5;% default 0.5C
end
if nargin==1 & size(S,2)==3;
    T=S(:,2);
    P=S(:,3);
    S=S(:,1);
end
P=P(:);S=S(:);T=T(:);
I=~isnan(P)&~isnan(S)&~isnan(T);

P=P(I);
S=S(I);
T=T(I);
[P I]=unique(P);
S=S(I);
T=T(I);
sigt= sw_pden(S,T,P,0)-1000;
if any(isnan(sigt)) |~isreal(sigt)
    error('Revisar datos de salinidad')
end

I10=find(P>10,1,'first')-1;% indice con 10m
if isempty(I10) | min(P) >10 | isnan(sigt(I10))
    disp('Lance menos de 10m')
    Imld=nan; % no se puede calcular porque el lance no tiene mas de 10m
    p=nan;
    %keyboard
    %error('calc')
    return
end

dsigt=abs(sw_pden(S(I10),T(I10),P(I10),0)-sw_pden(S(I10),T(I10)+dt,P(I10),0));
% dsigt: diferencia entre la densidad a 10m y la "densidad" que tuviera con
% +0.5 degC


%keyboard;
x=sigt-sigt(I10);
%x: diferencia del perfil de densidad menos la densidad a 10m
I=P>=10;
if all(x(I)<dsigt)
    p=max(P); %en caso de que todo el perfil sea menor que dsigt
else
    try
    p=interp1(x(I),P(I),dsigt); % se interpola para buscar la profundiad
    
    catch
        keyboard
    end
end
Imld=find(p<=P,1,'last');% el dato mas profundo que esta dentro de la capa de mezcla
if isnan(p)
   % keyboard
end
