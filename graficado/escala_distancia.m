function [hp ,ht]=escala_distancia(x,y,d,dy,mn,g2km)

if ~exist('x','var')
    [x y ]=ginput(1);
end
    if ~exist('dy','var') || isempty(dy)
    dy=diff(get(gca,'ylim'))/100;%lo ancho de la caida de la barra
end
if ~exist('d','var')
    d=[0 20 650 100]
end
if d(1)~=0
    d=[0,d(:)'];
end

cm=mean(get(gca,'ylim'));
if ~exist('mn','var') || isempty(mn)
    R=6371*2*pi;% diametro de la tierra en Km
    mn=0;
elseif strcmpi(mn,'mn')
    R=21600;% diametro de la tierra en Mn
    mn=1;
else
    disp('error')
end

if ~exist('g2km','var') || isempty(mn)
    g2km=R/(360)*cosd(cm);
end
%d=[0 100 200 500]; % Largo de la barrita que pondre
L=[d./g2km]; %largo de la barra en grados
vx=[];vy=[];
for k=1:numel(L)
    vx=[vx,x+L(k) x+L(k) x+L(k) ];
    vy=[vy,y y-dy y];
    txt{k}=num2str(d(k));
end
hp=plot(vx,vy,'r','linewidth',2);

ht=text(x+L,repmat(y-2.5*dy,1,numel(L)) ,txt,'HorizontalAlignment','center');
if mn==0
    hk=text(x+L(end),[y-2.5*dy],'    km','HorizontalAlignment','left');
else
    hk=text(x+L(end),[y-2.5*dy],'    mn','HorizontalAlignment','left');
end
ht=[ht ;hk];