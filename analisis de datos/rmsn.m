function r=rmsn(x,v)

x=x(:);
v=v(:)';

d=abs(x-v);
c=d==min(d,[],2); %matriz de contingencia

for k=1:numel(v)
    
    r(k)=rms(x(c(:,k))-v(k));
end
