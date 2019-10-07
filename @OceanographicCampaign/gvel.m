function [ch ,Z]=gvel(R,linea,ref)





if iscell(R.linea)
    lin=[R.linea{:}]';
else
       lin=R.linea
 %   keyboard
end
if isnumeric(lin) &&isnumeric(linea)
    Il=find(lin==linea);
else
    keyboard
end

[D, a, b]=R.Lance(R.Lances(Il),{'Presion','Temperatura','Salinidad'});
n=numel(D);
nfo=R.info;

%% calculo de distancia a la costa
LL=cell2mat(nfo(Il+1,6:7));
%pr=LL(LL(:,1)==max(LL(:,1)),:);
%x=[LL(:,1),repmat(pr(1),n,1)]';
%x=x(:);
%y=[LL(:,2),repmat(pr(2),n,1)]';
%y=y(:);
%d=sw_dist(y,x,'km');
d=dist_30(LL(:,2),LL(:,1),linea);

 [d, Is]=sort(d);
 Il=Il(Is);
 D=D(Is);
%% pegar datos en X Y Z

XYZ=[];
mp=[];
for k=1:n
    nl=size(D{k},1) ;
    if max(D{k}(:,1))>= ref
        XYZ=[XYZ;repmat(d(k),nl,1),D{k}(:,1:end)];
        
        
        %if any(isnan(XYZ(:,3)))
        %   keyboard
        %end
        
        mp=[mp;max(D{k}(:,1))];
        
    else
        d(k)=nan;
    end
end
I=~isnan(d);
d=d(I);
Il=Il(I);
x=XYZ(:,1);
y=XYZ(:,2);
%z=XYZ(:,3);





f=0.5;
d2=interp1(d,1:f:n)';
di=d2(1:end-1)*.5+d2(2:end)*.5;
[X, P]=meshgrid(d2,0:max(y));
T=surferinterp(x,y,XYZ(:,3),X,P,1);
S=surferinterp(x,y,XYZ(:,3),X,P,1);
gpan=sw_gpan(S,T,P);
Z=sw_gvel(gpan,...%Z es velocidad geostrofica, 
    interp1(LL(:,2),1:f:n),...
    interp1(LL(:,1),1:f:n));


[X, Y]=meshgrid(di,0:max(y)); %ahora X y Y coinciden en Z
%Z=griddata(x,y,z,X,Y);

Z=Z-Z(ref,:);
[~,ch]=contourf(X,Y,Z);
colormap(jet);
%cb=colorbar;

hold on

set(gca,'XDir','reverse','YDir','reverse')
[ds Is]=sort(d);
set(gca,'XTick',ds,'XTickLabel',R.estacion(Il(Is)));
%


%poligono blanco
x=[d;d(end);0];
y=[mp(:);max(mp)+100;max(mp)+100];
%plot(x,y,'+-r')
fillseg([x,y],[1 1 1],[1 1 1]);

 