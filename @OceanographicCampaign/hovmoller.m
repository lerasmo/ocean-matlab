function  [cf mp,out]=hovmoller(R,linea,prof,var);


% [T,hdr,linest]=R.capa(prof,lances,vars)
[D a b]=R.Capa(prof,[num2str(linea),'.x'],var,'presion');


D=cat(1,D{:});
E=[];
F=[];
B=[];
for k=1:numel(b)
    if isempty(b{k})
        continue
    end
    B=[B;b{k}{1}];
    E=[E;b{k}{3}];
    F=[F;b{k}{4}];
    
end

y=fecha2fixcr(F);
x=E;
z=D(:,3);
if nargout==3
    out=[{'Linea.estacion','estacion','año',var};B,num2cell([x y z])];
    %  out{2}=
    %keyboard
    cf=nan;
    mp=nan;
  return
end
%
[X, Y]=meshgrid(min(x):1:max(x),min(y):0.1:max(y));
vc=auto_level(z);
Z=surferinterp(x,y,z,X,Y,6);
%Z=griddata(x,y,z,X,Y);
[~,cf]=contourf(X,Y,Z,vc);
hold on
mp=plot(x,y,'.k');
%shading flat
%colormap jet
set(gca,'xdir','reverse')
%keyboard
