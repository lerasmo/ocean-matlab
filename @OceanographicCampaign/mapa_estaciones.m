function [xy,mrot,gax]=mapa_estaciones(R,ax2,ct)
if numel(R)>1
    error('Funcion definida para un solo crucero')
end
    
if ~exist('ax2','var') || isempty('ax2')
    ax2=[   -75  -71   70  78.5];
end

c=load('Linea de costa gc v2.mat');
xyc=c.xy;

if ~exist('ct','var') || isempty(ct)
    
    ct=load('contorno_est_imecocal.dat'); %arreglar
end
Lx=-132:1:-110;
Ly=20:1:50;
Lx=-132:2:-110;
Ly=20:2:50;

[gax,mrot,hl]=crear_lineas(ax2,Lx,Ly);
gax(2).Layer='top';
xycr=xyc*mrot;
fillseg(xycr,[0.7 0.7 0.7],[0 0 0]);
[ct(:,1),ct(:,2)]=poly2cw(ct(:,1),ct(:,2));
xy=[R.lon,R.lat]*mrot;
hold on
plot(xy(:,1),xy(:,2),'.k')
