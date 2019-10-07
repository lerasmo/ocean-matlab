function xf = lnz_fi(x,h)



if isvector(x)
    xf = conv (x , h,'valid');
else
    
    [a, b]=size(x);
    flip=false;
    if b>a
        flip=true;
        x=x';
        [a, b]=size(x);
    end
    xf=nan(a-numel(h)+1,b);
    for k=1:b
        xf(:,k)=conv(x(:,k),h,'valid');
    end
    if flip
        xf=xf';
    end
end
