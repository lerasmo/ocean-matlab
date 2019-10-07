function Is=detectar_huecos(d,sz)
%subrutina para encontrar los huecos/nans mayores o iguales {sz} numero de datos.
d=d(:)';

I=isnan(d);
I=[false,I,false];
in=[find(diff(I)==1);
    find(diff(I)==-1)];
len=diff(in);

b=len>=sz;
in=in(:,b);
Is=false(size(d));

for k=1:size(in,2)
    Is(in(1,k):in(2,k)-1)=true;
end