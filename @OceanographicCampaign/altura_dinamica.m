function altura_dinamica(R,h)
%Dibuja los contornos de altura dinamica con lineas y flechas



R=R.gpan;

if h==0
    hs=1;
    LM=10;
    Lm=2;
else
    hs=h;
    LM=2;
    Lm=1;
end


if 0 %para cuando se exedan las dimensiones estandar > integrara a graficado general
    ax2=[-77   -71    67    79];
    I=convhull(R.lon,R.lat);
    R.userdata.contorno=[R.lon(I),R.lat(I)];
else
    ax2=[];
    R.userdata.contorno=[];
end

[gax, hc, mrot, hl, cf, hf, vc, ct,xy,px]=R.graficarH('gpan',hs,ax2);
plot(xy(:,1),xy(:,2),'.k')

%delete(hc)

gax(2).XTickLabel='';
htit=title(gax(2),[R.Crucero,': Altura Dinamica ',num2str(h),'m ref: 500m']);
htit.Position=htit.Position+[0 0.2 0]
%gax(1).Position=gax(1).Position-[0 .02 0 0 ];
%gax(2).Position=gax(1).Position;
%        hc.Position=hc.Position-[0 .02 0 0 ];
str=[R.Crucero,' Altura Dinamica ',num2str(h),'m ref 500m.png'];


%hf.Fill='off';
hf.LevelList=0:Lm:180;
hclabel=clabel(hf.ContourMatrix,'backgroundcolor','none','margin',2);
%hf.LineColor='r';
%hf2=copyobj(hf,hf.Parent);
%uistack(hf2,'bottom');
%hf2.LevelList=[0:10:180];
%hf2.LineWidth=2;

%% Kernel del dibujo de flechas
contour2arrows(hf,px);

% S=contourdata(hf.ContourMatrix);
% cnt=0;
% for kk=1:numel(S)
%     x=flip(S(kk).xdata);
%     y=flip(S(kk).ydata);
%     x(x==0)=[];
%     y(y==0)=[];
%     
%     I=inpolygon(x,y,px(:,1),px(:,2));
%     x(~I)=nan;
%     y(~I)=nan;
%     
%     I=[false;I;false];
%     
%     
%     
%     if all(isnan(x))
%         continue
%     end
%     B=find(diff(I)==1)+1;
%     C=find(diff(I)==-1)-1;
%     for j=1:numel(B)
%         xi=x(B(j):C(j));
%         yi=y(B(j):C(j));
%         if numel(xi)<=15 %dibujar lineas con mas de 20 puntos
%             
%             continue
%         end
%         %numel(xi)
%         if S(kk).level/LM==ceil(S(kk).level/LM) %cada 10
%             lw=2; %LineWidth
%             hs=14;
%         else
%             lw=0.5; %LineWidth
%             hs=8;
%         end
%         h=plot(xi,yi,'-k','LineWidth',lw);
%         uistack(h,'bottom')
%         cnt=cnt+1;
%         arrow(cnt,1)=line2arrow(h,'color',0*[0.5 0.5 0.5],'HeadWidth',hs,'HeadLength',hs);
%         
%         if hs==8
%          %   delete(h)
%         end
%         %return
%     end
%     
%     
% end

for k=1:numel(hclabel)
    if strcmp(hclabel(k).Type,'text')
        pos=hclabel(k).Position;
        I=~inpolygon(pos(1),pos(2),px(:,1),px(:,2)); %fuera de poligono
    else
        
        I=true;
    end
    if I  %fuera de poligono
        delete(hclabel(k))
    else
        uistack(hclabel(k),'top')
    end
end


%delete (hf)

