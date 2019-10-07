function d=dist_30(lat,lon,lin);
%calcula la distancia a la estacion 30
e30=load('estacion30.txt');
I=find(e30(:,1)==lin);
if isempty(I) || numel(I)>1
    disp(lin);
    error('no se encontro la linea o se metieron lineas de mas');
end
e30=e30(I,:);
n=numel(lat);
y30=repmat(e30(3),n,1);
x30=repmat(e30(2),n,1);

neg=lon>x30(1);

LAT(1:2:(n*2-1))=lat;
LAT(2:2:(n*2))=y30;

LON(1:2:(n*2-1))=lon;
LON(2:2:(n*2))=x30;

d=(sw_dist(LAT,LON,'km'));
d=d(1:2:end);
d=d(:);
d(neg)=-d(neg);




