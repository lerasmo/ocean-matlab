function [R, I]=filtrar_std(x,s,tol)
%[R, I]=filtrar_std(x,s,tol)
% filtrado por desviaciones estandar
% toma la serie de datos x y aplica un filtro de ventana de ancho w, retira
% los datos que se alejen mas de s desviaciones estandar y los marca como
% nans en la serie R.
% los datos que se alejen menos que el valor de tolerancia (tol) son
% retenidos.
% los datos se marcan con NAN y se indexan en el indice I.
% R sera de la misma longitud que x

x=x(:);

mu=nandetrend(x);
st=nanstd(mu);
m=nanmean(mu);
I=(abs(mu)/st>=s & (abs(mu)-m) >=tol );
%    keyboard




%I=unique(f);
R=x;
R(I)=nan;

function R=nandetrend(x)
I=(~isnan(x));
R=nan(size(x));
d=detrend(x(I));
R(I)=d;
