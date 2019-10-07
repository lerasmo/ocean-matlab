function c=corr_taylor(x,y)

x=x(:);
y=y(:);
if numel(x)~=numel(y)
    error('tamaños diferentes')
end
I=~isnan(x)&~isnan(y);
x=x(I);
y=y(I);
if numel(x)==0
    c=nan;
    return
end
if all(x==y)
    c=1;
    return
end
c=mean((x-mean(x)).*(y-mean(x)))/(std(x).*std(y));