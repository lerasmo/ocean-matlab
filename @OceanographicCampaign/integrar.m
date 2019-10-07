function R=integrar(R,vr,range,nm)
%calcular la integral
% vr: variable a integrar : 'Temperatura'
% range:[0 100]: Limites de la integral
% nm: numero minimo de datos necesarios para validar la integral.

if numel(R)>1
    for k=1:numel(R)
        R(k)=integrar(R(k),vr,range);
    end
    return
end

v0=R.vars_index(vr);
if isempty(v0)
    error(['Variable no encontrada: ',vr])
end
if ~exist('range','var')||isempty(range)
    range=[0 inf]; %integrar toda la columna de agua
end
if ~exist('nm','var')||isempty(nm)
    nm=2;
end
if numel(range)==1
    range=[0 range]; %integrara desde la superficie a la prof indicada
end

vint=[vr,'_integrada'];
vi=R.vars_index(vint);
if isempty(vi) %agregar la variable
    R.Variables=[R.Variables,vint];
end
vi=R.vars_index(vint);
vp=R.vars_index('presion');
for k=1:R.nLances
    P=R.data{k}(:,vp);
    D=R.data{k}(:,v0);
    I=P>=range(1) & P<=range(2);
    P=P(I);
    D=D(I);
    I=~isnan(P)&~isnan(D);
    P=P(I);
    D=D(I);
    [p ,I]=unique(P); %quitar repetidos
    D=D(I);
    R.data{k}(:,vi)=nan;
    if numel(p)>=nm
        dx=diff(p);
        ppi=sum( (D(1:end-1)+D(2:end)).*dx )/2; %integral de PP por trapecios
        R.data{k}(1,vi)=ppi;
    end
    
 
end
%keyboard
    
