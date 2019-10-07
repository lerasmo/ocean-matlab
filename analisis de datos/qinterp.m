function [yi xi]=qinterp(x,y,xi);

%quick interp, lineal, un solo vector
%quita nansy repeticiones.

if iscell(x)
    %modo celdas
    g=x;
    xi=y;
    xo=[];
    for k=1:size(g,1)
        x=g{k,1};
        Ie=x>=min(xi) & x<=max(xi);
        if k==1
            Is= xi<=max(x);
        elseif k==size(g,1)
            Is=xi>=min(x);
        else
            
            Is=xi>=min(x) & xi<=max(x);
        end
        r=interp1(x(Ie),g{k,2}(Ie,:),xi(Is));
        xo=[xo;xi(Is)];
        if  k~=size(g,1)
            r(end,:)=nan;
            xo=[xo;nan];
        end
        
    end
    yi=r;
    xi=xo;
    return
    
end


x=x(:);
%y=y(:);
I=~isnan(x)&~isnan(y); %huecos
I=all(I,2);
x=x(I);
y=y(I,:);

%unicos
[x, I]=unique(x);
y=y(I);
if isempty(x) |isempty(y); %vacias.
    yi=nan(size(xi));
    return
end
[ x y]=insertar_nans(x,y);
I=[0;find(isnan(x));numel(x)+1];
yi=nan(size(xi));
for k=1:numel(I)-1 %con huecos
    v=I(k)+1:I(k+1)-1;
    if numel(v)<=1
        continue
    end
    
    q=xi>=x(v(1))&xi<=x(v(end));
    try
        dum=interp1(x(v),y(v),xi(q));
    catch
        keyboard
    end
    yi(q)=dum;
end
%yi=interp1(x,y,xi);
%plot(x,y,'-+',xi,yi,'-.r')
%keyboard