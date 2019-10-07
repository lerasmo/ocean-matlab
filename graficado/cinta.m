function hr=cinta(x,y,z)
x=x(:)';
y=y(:)';
z=z(:)';
d=[numel(x) numel(y) numel(z)];
if any(d(1)~=d)
    error('Los vectores son de diferentes longitudes')
end

hr=surface([x;x],[y;y],0*[x;x],[z;z],...
    'facecol','no',...
    'edgecol','interp',...
    'linew',5);