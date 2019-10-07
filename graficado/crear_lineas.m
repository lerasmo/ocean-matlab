function [gax,mrot,hl,isnew]=crear_lineas(lims,Lx,Ly)
%crea las lineas para los mapas rotados de imecocal
% set(gax(1),'XTick',[]) %abajo
% set(gax(1),'yTick',[]) %izquierda
% set(gax(2),'XTick',[]) %arriba
% set(gax(2),'yTick',[]) %derecha

if ~isempty(get(gcf,'userdata'))
    ud=get(gcf,'UserData');
    gax=ud{1};
    mrot=ud{2};
    hl=ud{3};
    isnew=false;
    return
end
fmt='%3.0f';
%a=30
a=30.1443; %angulo de rotacion

rot=[cosd(a) -sind(a)
    sind(a) cosd(a)];
st=[cosd(30) 0
    0  1];
mrot=st*rot;

%ax=[-120 -108 22 38];
%ax2=[   -74.3  -71   74  79.1]
if ~exist('lims','var');
    ax2=[   -74.3  -71   73.4  78.5];
else
    ax2=lims;
end
if ~exist('Lx') || isempty(Lx)
    Lx=-121:1:-110;
end

if ~exist('Ly') || isempty(Lx)
    Ly=22:33;
end



by=[];bx=[];
for k=1:numel(Lx) %X para paralelas
    bx=[bx;
        Lx(k) 0
        Lx(k) 80
        nan  nan];
    
end


for k=1:numel(Ly) %y para meridianos
    by=[by;
        -160 Ly(k)
        -100 Ly(k)
        nan  nan];
end


bx2=bx*mrot; %paralelos
by2=by*mrot; %meridianos
m=[];

k=((1:numel(Lx))-1)*3+1;
m=(bx2(k+1,2)-bx2(k,2))./(bx2(k+1,1)-bx2(k,1));
b=bx2(k,2)-m.*bx2(k,1);
xlow=(ax2(3)-b)./m; %posiciones de x donde interesctan los meridianos al eje de abajo
xtop=(ax2(4)-b)./m; %posiciones de x donde interesctan los meridianos al eje de arriba
hl(1)=plot(bx2(:,1),bx2(:,2),'color',[0.6 0.6 0.6]);
gax=gca;
set(gax,'XTick',xlow,'XTickLabel',num2str(abs(Lx'),[fmt,'\\circ W']),'XTickLabelRotation',90-a);
axis(gax,ax2)
set(gca,'Layer','bottom')


k=((1:numel(Ly))-1)*3+1;
m=(by2(k+1,2)-by2(k,2))./(by2(k+1,1)-by2(k,1));
b=by2(k,2)-m.*by2(k,1);
yleft=m*ax2(1)+b; %posiciones y donde los pararelos intersectan el margen izquierdo del mapa
yright=m*ax2(2)+b;%posiciones y donde los pararelos intersectan el margen derecho del mapa


%set(gca,'Ytick',[])
%return

set(gax,'YTick',yleft,'YTickLabel',num2str(abs(Ly'),[fmt,'\\circ N']),'YTickLabelRotation',-a,'TickDir','both','box','off');

hold on
hl(2)=plot(gax(1),by2(:,1),by2(:,2),'color',[0.6 0.6 0.6]);
%set(gca,'XTick',[],'ytick',[])
gax(2)=axes('position',gax.Position,'dataAspectRatio',gax.DataAspectRatio,'xlim',gax.XLim,...
    'ylim',gax.YLim,'color','none','XAxisLocation','top','YAxisLocation','right','TickDir','both');
axis(gax,ax2)
set(gax(2),'XTick',xtop,'XTickLabel',num2str(abs(Lx'),[fmt,'\\circ W']),'XTickLabelRotation',90-a);
set(gax(2),'YTick',yright,'YTickLabel',num2str(abs(Ly'),[fmt,'\\circ N']),'YTickLabelRotation',-a,'TickDir','both');
gax(1).FontWeight='bold';
gax(2).FontWeight='bold';

set(gax,'dataAspectRatio',[ 1  1   1]);
axis(gax,ax2);
linkaxes(gax)
set(gcf,'userdata',{gax,mrot,hl})
isnew=true;;
%%