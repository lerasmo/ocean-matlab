function [ch ,XYZ]=graficarV(R,linea,var)





if iscell(R.linea)
    lin=[R.linea{:}]';
else
    lin=R.linea;
    %keyboard
end
if isnumeric(lin) &&isnumeric(linea)
    Il=find(lin==linea);
else
    keyboard
end



nfo=R.info;
%varo=vars_index(R,var)
%if varo==-1
%    warning('Sin datos ')
%    return
%end
[D, a, b]=R.Lance(R.Lances(Il),{'presion',var});
n=numel(D);
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
c=0;
for k=1:n
    nl=size(D{k},1);
    if max(D{k}(:,1))<500
        %Inv(k)=true;
        %continue
        
    end
    Inv(k)=false;
    XYZ=[XYZ;repmat(d(k),nl,1),D{k}(:,1:2)];
    
    %if any(isnan(XYZ(:,3)))
    %   keyboard
    %end
    
    mp(k)=max(D{k}(:,1));
end
Il(Inv)=[];
mp(Inv)=[];
d(Inv)=[];
x=XYZ(:,1);
y=XYZ(:,2);
z=XYZ(:,3);




%plot(x,y,'+k')
hold on
[X, Y]=meshgrid(interp1(d,1:0.5:n)',0:max(y));
%plot(X,Y,'.r')
Z=surferinterp(x,y,z,X,Y,3);
%Z=griddata(x,y,z,X,Y);
ch=contourf(X,Y,Z);
colormap(jet);
%cb=colorbar;

hold on

set(gca,'XDir','reverse','YDir','reverse')
%[ds Is]=sort(d);
set(gca,'XTick',d,'XTickLabel',R.estacion(Il));
%


%poligono blanco
x=[d;d(end);0];
y=[mp(:);max(mp)+100;max(mp)+100];
%plot(x,y,'+-r')
fillseg([x,y],[1 1 1],[1 1 1]);
%keyboard
 