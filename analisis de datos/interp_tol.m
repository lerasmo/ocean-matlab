function [yq D]=interp_tol(x,y,xq,tol)
%function interpolar con tolerancia
% tol en unidades de x
x=x(:);
y=y(:);
xq=xq(:);


D=min(abs(x(:)-xq(:)'));%distancia
I=D>tol;
if all(I)
    warning('Todos los datos no cumplen con la tolerancia')
    yq=nan(size(I));
    return
end


yq=interp1(x,y,xq);
yq(I)=nan;



