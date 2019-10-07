function [arrow h]=contour2arrows(hf,px,fflip)
% dibuja las flechas a partir de los contornos

LM=10;
Lm=2;

if ~exist('fflip') | isempty(px)
    fflip=true;
end
if ~exist('px') | isempty(px)
    px=[-inf -inf
        -inf inf
        inf inf
        inf -inf ];
end

S=contourdata(hf.ContourMatrix);
cnt=0;
cnth=0;
arrow=[];
for kk=1:numel(S)
    x=S(kk).xdata;
    y=S(kk).ydata;
    
    if fflip
        x=flip(x);
        y=flip(y);
        
    end
    x(x==0)=[];
    y(y==0)=[];
    
    I=inpolygon(x,y,px(:,1),px(:,2));
    x(~I)=nan;
    y(~I)=nan;
    
    I=[false;I;false];
    
    %plot(x,y,'r')
    
    if all(isnan(x))
        continue
    end
    B=find(diff(I)==1)+1;
    C=find(diff(I)==-1)-1;
    for j=1:numel(B)
        xi=x(B(j):C(j));
        yi=y(B(j):C(j));
        if numel(xi)<=15 %dibujar lineas con mas de 20 puntos
            
            %continue
        end
        %numel(xi)
        if S(kk).level/LM==ceil(S(kk).level/LM) %cada 10
            lw=2; %LineWidth
            hs=14;
        else
            lw=0.5; %LineWidth
            hs=8;
        end
        
        if numel(xi)>0
            cnth=cnth+1;
            h(cnth,1)=plot(xi,yi,'-k','LineWidth',lw);
            uistack(h(cnth),'bottom')
        end
        
        if numel(xi)>=4 %dibujar lineas con mas de 20 puntos
            
            %arrow(cnt,1)=line2arrow(h(cnth),'color',0*[0.5 0.5 0.5],'HeadWidth',hs,'HeadLength',hs);
            dum=splitline(h(cnth));
            
            cnt=cnt+numel(dum);
            %for a=1:nume
            
            arrow=[arrow,line2arrow(dum,'color',0*[0.5 0.5 0.5],'HeadWidth',hs,'HeadLength',hs)];
            
            
           
        end
        
        
        if hs==8
            %   delete(h)
        end
        %return
    end
    
    
end