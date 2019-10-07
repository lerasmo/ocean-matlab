function [Ix Iy]= interecte(x,y,tol)
% ajusta los datos para que x y se acercen con cierta tolerancia
% profunidades

x=x(:);
y=y(:);
% x=[1:5]+.3;
% y=[0:10];

c=0;
Ix=[];
Iy=[];
for k=1:numel(x)
    if isnan(x(k))
        continue
    end
    
    d=abs(x(k)-y);
    if d>tol
        continue
    end
    c=c+1;
    try
        Iy(c)=find(nanmin(d)==d,1);
    catch
        keyboard
    end
    Ix(c)=k;
end


