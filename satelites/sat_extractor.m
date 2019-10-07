function [D fc]=sat_extractor(fn,ax,It,vs)
%archivo, limites, tiempos: [start count], first It
%D: estructura de salida
%fc: [fecha pivote, unidades(fracciones de dias)]
%It: intervalo de tiempo (counts) [start end] 
if ~exist('It','var') || isempty(It);
    It=[1 inf];
end
if numel(It)==1
    It=[1 It];
end


%fn='\\158.97.15.180\Satelite data\Mur mensuales\Mur Temp mensuales\2018040120180430-GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc';

%ax=[-126  -114    28    38];
if ~exist('ax')||isempty(ax)
    ax=[-inf inf -inf inf];
    warning('Sin limites definidos, cargando todo')
end
D=ncinfo(fn);

vars={D.Variables.Name};
Ic=strcmp('char',{D.Variables.Datatype}); %variables char
vars=vars(:);
sz={D.Variables.Size};
%sz=cellfun(@sum,sz,'UniformOutput',false)';
sz=cellfun(@numel,sz);

vx=filter_text(vars(:),'lon');
vy=filter_text(vars(:),'lat');
x=ncread(fn,vx{1});
x=wrapTo180(x);

Ix=x>=ax(1) & x<=ax(2);
sx=find(Ix,1);
nx=sum(Ix);
x=x(Ix);


y=ncread(fn,vy{1});
Iy=y>=ax(3) & y<=ax(4);
sy=find(Iy,1);
ny=sum(Iy);
y=y(Iy);
%para datos puntuales: boyas
if numel(x)==1 & numel(y)==1
    sx=1;
    sy=1;
    nx=inf;
    ny=inf;
end
x=wrapTo180(double(ncread(fn,vx{1},sx,nx)));
y=double(ncread(fn,vy{1},sy,ny));

Nic=find(~Ic);
[vt,it]=filter_text(vars(Nic),'time ~encoded');
it=Nic(it);

%% fallos de la variable tiempo, buscarla
if isempty(vt)
    [vt,it]=filter_text(vars(~Ic),'MT'); %filtrar variables non-char
end
if numel(vt)>1
    dum=find(strcmp(vt,'time'));
    if dum
        vt=vt(dum);
        it=it(dum);
    end
    
end
    
    %vt=vt(3);%adoc
    %it=it(3);
if numel (vt)~=1
    error('variable tiempo no detectada')
end
jd=double(ncread(fn,vt{1}));
dum={D.Variables(it).Attributes.Name};
[un,ui]=filter_text(dum(:),'unit'); %buscar las unidades
clear dum
if numel(un) ~=1
    error('fecha del tiempo')
end
%valo=D.Variables(it).Attributes(ui).Value;
val=lower(D.Variables(it).Attributes(ui).Value);
tf= ['yyyy-mm-ddTHH:MM:ssZ   '
     'yyyy-mm-dd HH:MM:ss    '
     'yyyy-mm-dd HH:MM:ss UTC'
     'yyyy-mm-dd HH:MM       '];%formatos ya conocidos
if strfind(val,'seconds')
    %tienen unidades de segundos
    val=strrep(val,'seconds since','');
    val=strtrim(val);
    dum(1:23)=' ';
    dum(1:numel(val))=val;
    % determinar el formato del tiempo
    [~,d]=max(sum(dum==tf,2));
    
    
    t0=datenum(upper(val),tf(d,:));
    jd=jd/86400+t0;
    %datestr(jd)
    fc(2)=1/86400;
elseif strfind(val,'days')
    val=strrep(val,'days since ','');
    val=strtrim(val);
    dum(1:23)=' ';
    dum(1:numel(val))=val;
    % determinar el formato del tiempo
    dum=repmat(dum,size(tf,1),1);
    [~,d]=max(sum(dum==tf,2));
    t0=datenum(val,tf(d,:));
    jd=jd+t0;
    fc(2)=1;
elseif strfind(val,'hours')
    val=strrep(val,'hours since ','');
    val=strrep(val,' +0:00','');
    val=strtrim(val);
    clear dum
    dum(1:23)=' ';
    dum(1:numel(val))=val;
    % determinar el formato del tiempo
    % por matlab2014
    dum=repmat(dum,size(tf,1),1);
    %
    [~,d]=max(sum(dum==tf,2));
    t0=datenum(val,tf(d,:));
    jd=jd/24+t0;
    fc(2)=1/24;
else
    error('calcular tiempo')
end

fc(1)=[t0 ];



%vars=vars(sz>1 & ~strcmp({D.Variables.Datatype},'char'));
I=sz>1 & ~strcmp({D.Variables.Datatype},'char');
vars=vars(I);
sz=sz(I);
%select vars
if exist('vs') && ~isempty(vs)
    if ischar(vs)
        vs={vs};
    end
    [vars ,~,I]=intersect(vars,vs);
    sz=sz(I);
    if numel(vs)<numel(vars)
        warning('No se encontraron todas las variables')
    end
end
vi=find(sz>1);
D.jd=jd;
D.x=x;
D.y=y;
for k=1:numel(vars)
    disp(vars{k})
    if numel(D.Variables(vi(k)).Size) ==2
        try
            D.(vars{k})=ncread(fn,vars{k},[sx sy],[nx ny]);
        catch
             D.(vars{k})=ncread(fn,vars{k});
        end
        
    else
        D.(vars{k})=ncread(fn,vars{k},[sx sy It(1)],[nx ny It(2)]);
    end
    
    
end

[D.Y, D.X]=meshgrid(y,x);

