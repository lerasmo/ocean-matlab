function  Y=interp_huecos(t,y)
%t=t(~isnan(t));
%se interpolan los huecos derecho y sin preguntas.
n=numel(t);
[t I]=unique(t);
n2=numel(t);
if n2<n
    warning('Se reducen el numero de puntos en el tiempo')
end
y=y(I);

I=~isnan(y);
%y=y(I);

Y=interp1(t(I),y(I),t);
