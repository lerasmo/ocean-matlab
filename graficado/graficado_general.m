function    [gax hc mrot hl cf hf vc xy,px]=graficado_general(V,xy,ax2,func,ct)
%[axes,colorbar,matriz_rot,[?], contour, [?],
%ax=[-120 -108 22 38];
f=gcf;
%if ~strcmp(f.UserData,'rotmap') %para no sobreescrbir

ax=[  -119  -108    24    33];
%ax=[  -126  -108    24    50];
if ~exist('ax2','var') || isempty('ax2')
    ax2=[   -75  -71   70  78.5];
end
%xyc=draw_costa(ax,'med');
c=load('Linea de costa gc v2.mat');
xyc=c.xy;


Lx=-132:1:-110;
Ly=19:1:50;
[gax,mrot,hl,isnew]=crear_lineas(ax2,Lx,Ly);
gax(2).Layer='top';
xycr=xyc*mrot;
if isnew
    fillseg(xycr,[0.7 0.7 0.7],[0 0 0]);
end
if ~exist('ct','var') || isempty(ct)
    
    ct=load('contorno2.dat'); %arreglar; es el contorno general de imecocal
else
    %ct=ct%*mrot;
end
[ct(:,1),ct(:,2)]=poly2cw(ct(:,1),ct(:,2));


if exist('xy','var') && ~isempty(xy)
    datar=xy*mrot;
    xy=datar;
    chi=convhull(datar(:,1),datar(:,2));
    chi=datar(chi,:);
    [chi(:,1),chi(:,2)]=poly2cw(chi(:,1),chi(:,2));
    
    [Px, Py] = polybool('intersection', chi(:,1), chi(:,2), ct(:,1),ct(:,2));
    [Px,Py]=poly2cw(Px,Py);
end
dt=0.05;
sp=abs( max(datar)-min(datar));
np=ceil(sp/dt);

%linspace(min(datar(:,1)),max(datar(:,1)),np(1))

[X ,Y]=meshgrid(linspace(min(datar(:,1)),max(datar(:,1)),np(1)),...
    linspace(min(datar(:,2)),max(datar(:,2)),np(2)));
if isempty(X) || isempty(Y)
    error('Meshgrid mal hecho')
end
%[X ,Y]=meshgrid(min(ct(:,1)):dt:max(ct(:,1)),min(ct(:,2)):dt:max(ct(:,2)));
%Z=griddata(datar(:,1),datar(:,2),V,X,Y,'v4');


hold on
% contourf(gax(1),X,Y,Z);
%% contornos

P1x=ax2([1 2 2 1 1]);
%P1x=ax2([1 1 2 2 1]);
P1y=ax2([3 3 4 4 3]);
%P1y=ax2([3 4 4 3 3]);



%fill(Px(:), Py(:),'r')

%ax=axis;
%S=[[ax([2 2  1 1 2]);ax([4 3 3 4 4 ])]';S];

try
    f.CurrentAxes=gax(1);
catch
    keyboard
end


%%
if exist('V','var') && ~isempty(V)
    if all(V)==V(1) %todos iguales
        warning('Datos coplanares')
    else
        
        Z=surferinterp(datar(:,1),datar(:,2),V,X,Y,1);
        %Z=griddata(datar(:,1),datar(:,2),V,X,Y);
    end
    
    hfill=fillseg([P1x(:), P1y(:);Px(:), Py(:)],'w','none');%fondo blanco
    px=[Px Py];
    % I=inpolygon(X,Y,Px,Py);
    % cax=[min(Z(I)),max(Z(I))];
    vc=auto_level(V);
    
    %M=~inpolygon(X,Y,S(:,1),S(:,2));
    %Z(M)=nan;\
    if ~exist('func','var') || isempty(func)
        
        func=@contourf;
    end
    try
        [cf ,hf]=func(gax(1),X,Y,Z,vc);
    catch
        hf=func(gax(1),X,Y,Z);
        cf=[];
    end
    
    caxis(vc([1 end]))
    uistack(hf,'down')
    %if ~isempty(cf)
    
    uistack(hl,'top')
    hc=colorbar(gax(1));
    proper_color_limits(hc,hf,V)
    hc.Ticks=vc;
    hc.Position=hc.Position+[0.06 0 0 0];
    colormap(gca,jet(numel(vc)-1))
else
    hc=[];
    cf=[];
    hf=[];
    vc=[];
end



gax(1).Layer='top';
%hfill.FaceAlpha=0.8
%gax(2).Layer='top'
%return
linkaxes(gax)
p=gax(1).Position;

gax(1).Position=p;
gax(2).Position=p;
fig=gcf;
%fig.UserData='rotmap'



