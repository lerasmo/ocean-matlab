function [cor,np,tao]=correl_wnans2(s1,t1,s2,t2,lag)

% Tao  positvass S1 antecede a S2
%%  se cortan para que inicien y terminen al mismo tiempo


ti=max(min(t1),min(t2));
tf=min(max(t1),max(t2));

A=t1 >=ti & t1 <=tf;
B=t2 >=ti & t2 <=tf;

T=ti:1/24:tf; % vector de tiempo comun a ambas series
if isempty(T)
    keyboard
    error('Series no coinciden')
end
s1n=nan(size(T));  %series rellenas con nans donde hay huecos
s2n=nan(size(T));

[~,ia,ib] = intersect(t1*24,T*24);
if isempty(ia)
    keyboard
end% busco las intersecciones entre la...
%serie de tiempo del cañon y el tiempo en comun. multiplico x24 para evitar
%errores de redondeo
s1n(ib)=s1(ia); %serie de tiempo del cañon rellenas con nans

[~,ia,ib] = intersect(t2*24,T*24); % busco las intersecciones entre la...
%serie de tiempo del cañon y el tiempo en comun. multiplico x24 para evitar
%errores de redondeo
s2n(ib)=s2(ia); %serie de CB rellena con nans

[cor,np]=correl_wnans(s2n,s1n,lag); %correlacion de las dos series, con +/- 100 horas de lag
tao=-lag:lag;