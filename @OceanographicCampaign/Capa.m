function [T,hdr,linest]=capa(R,prof,lances,vars,vsp)
%Funcion para extraer una capa de profunidad
% [T,hdr,linest]=R.capa(prof,lances,vars)
%  T Matriz de datos, las primeras dos columnas son latitud y longitud, el
%  resto de las columnas se especifica en hdr.
%  linest: lista de las estaciones correspondientes a los renglones de T
%  lances: usar numero de lances, o nombre de las estaciones, default:  todos
%  vars: variables a extraer: default, [], todos.
%  prof: profundidad a extraer, puede ser una sola profundiad, o un rango
%  de profunidades (promedio) o multiples profunidades.
%
%  ejemplos:
%   % extraer de todos los lances, los datos de  temperatura y  salinidad a 10m
%    T=R.capa(10,[],{'Temp1','Salt1'})
%   % Hacer el promedio de superficie a 30m, de los primeros 20 lances
%    T=R.capa([0 30],1:20,{'Temp1','Salt1'})
%
%   % Extraer multiples profunidades
%    T=R.capa([20 50 100],[],{'Depth','Temp1','Salt1'})
%
%   % Promedio en la MLD
%    [T, hdr, info]=R.Capa({'MLD'},[],{'Temp','Salt'},'pres');
%
%    Aqui se agrega una columna extra en la salida, la columna 3 es la
%       profundidad de la capa de mezcla (MLD), el resto de las columnas
%       corresponden a las variables solicitadas.
%    Los titulos de la tabla T se especifica en la variable hdr.
%
%
%




if numel(R)>1
    T={};hdr={};linest={};
    for k=1:numel(R)
        % Var-id de referencia, default profunidad
        if ~exist('vsp','var')||isempty(vsp)
            
            vsps=R(k).vars_index('depth');
           % if ~exist('vsp','var')||isempty(vsps)
           %     vsps=R(k).vars_index('pres');
           % end
        else
            if ~isnumeric(vsp)
                vsps=R(k).vars_index(vsp);
                if isempty(vsps)
                    R=R.dynamic_variable(vsp);
                    vsps=R(k).vars_index(vsp);
                end
            else
                vsps=vsp;
            end
        end
       if isempty(vsps)
           error('sin variable de referencia')
       end
       
        empty_defaults  prof lances vars vsps
        [T{k,1},hdr{k,1},linest{k,1}]=Capa(R(k),prof,lances,vars,vsps);
    end
    
    return
end %del multiciclo para varios R
if ~exist('vsp','var')||isempty(vsp)
    
    dum=R.vars_index('depth');
    if isempty(dum)
        vsps=R.vars_index('Presion');
        if isempty(vsps)
            error('Presion no encontrada')
        end
    else
        vsps=dum;
        
    end
else
    if ~isnumeric(vsp)
        
            vsps=R.vars_index(vsp);
            if isempty(vsps)
                %% inyectar la nueva variable
                keyboard
            end
    else
        vsps=vsp;
    end
end



if ~exist('lances','var') || isempty(lances)
    lances=R.Lances;
end
if ~exist('vars','var')||  isempty(vars)
    vars=R.Variables;
end

if ~exist('prof','var')||  isempty(prof)
    help capa
    return
    %   error('as')
end
R.Variables=R.Variables(:);
if iscell(vars) && ~ismember('gpan',lower(R.Variables)) && ismember('gpan',vars)
    R=R.gpan;
end

   
ivars=R.vars_index(vars);
if isempty(ivars)
    warning('No se encontraron las variables')
    T=[];
    hdr=[];
    linest=[];
    return
end
ilances=R.lances_index(lances); %son los indices directos sobre R.data
c=0;
if ~isnumeric(prof) && (ischar(prof) | iscell(prof))
    if ischar(prof)
        prof={prof};
    end
    prof=upper(prof);
    %prof=prof(:);
    
    
    
    %prof=-1;
    modo='MLD';
    c=1;
    Pi=find(~cellfun(@isempty,strfind(lower(R.Variables),'dep')),1);
    
    if isempty(Pi)
        Pi=find(~cellfun(@isempty,strfind(lower(R.Variables),'pres')),1);
        % error('Buscando el vector de profundidad')
    end
    
    if isempty(Pi)
        error('Buscando el vector de profundidad')
    end
    Si=find(~cellfun(@isempty,strfind(lower(R.Variables),'sal')),1);
    if isempty(Pi)
        error('Buscando el vector de salinidad')
    end
    Ti=find(~cellfun(@isempty,strfind(lower(R.Variables),'tem')),1);
    if isempty(Pi)
        error('Buscando el vector de temperatura')
    end
    
    f=1;
else
    if numel(prof)==1
        modo='sencillo';
        f=1;
    elseif numel(prof) ==2
        modo='promedio';
        disp('Haciendo promedio')
        prof=sort(prof);
        f=1;
    elseif numel(prof) >2
        modo='multiple';
        disp('Extrayendo multiples profunidades')
        prof=unique(prof);
        f=numel(prof);
    end
    T=nan(numel(ilances)*f,numel(ivars)+2+c);
end
%T=nan(numel(ilances)*f,numel(ivars)+2+c);


T(:,1)=reshape(repmat(R.lon(ilances)',f,1),[],1);
T(:,2)=reshape(repmat(R.lat(ilances)',f,1),[],1);

%keyboard
linest{:,1}=reshape(repmat(R.linest(ilances)',f,1),[],1);
linest{:,2}=reshape(repmat(R.linea(ilances)',f,1),[],1);
linest{:,3}=reshape(repmat(R.estacion(ilances)',f,1),[],1);
linest{:,4}=reshape(repmat(R.fecha(ilances)',f,1),[],1);


py=-1;
%
for k=1:numel(ilances)
    switch modo
        case {'sencillo','multiple'}
           
                x=R.data{ilances(k)}(:,vsps);
                if all(isnan(x))
                    py=nan(numel(prof),numel(ivars));
                else
                    
                    [xu, Iu]=unique(x,'stable');
                    In=~isnan(xu);
                    if numel(x)==1
                        if x==prof
                            py=R.data{ilances(k)}(Iu(In),ivars);
                        end
                    else
                        py=interp1(xu(In),R.data{ilances(k)}(Iu(In),ivars),prof);
                    end
                end
            
            I=-1;
            Ip=1:size(py,1);
            %I=R.data{ilances(k)}(:,vsp)==prof;
            %R.data{ilances(k)}(I,ivars)
            
            %             I=find(I);
            %             if isempty(I)
            %                 continue
            %             end
            %             I=I(1);
            %             Ip=1;
            hacer_promedio=false;
            %case 'multiple'
            %    [~,I,Ip]=intersect(R.data{ilances(k)}(:,vsp),prof);
            
            %    hacer_promedio=false;
        case 'promedio'
            I=R.data{ilances(k)}(:,vsp)>=prof(1)&R.data{ilances(k)}(:,vsp)<=prof(2);
            if isempty(I)
                continue
            end
            I=find(I);
            Ip=1;
            hacer_promedio=true;
        case 'MLD'
            %dum=lower(prof);
            val={'MLD','RA_ILD','RA_MLD'};
            [dum2]=intersect(val,prof);
            if isempty(dum2)
                error(['No se reconoce la opcion:',cell2str(dum)])
            end
            [Ip,Iv]=ismember(prof,val);
            
            STP=R.data{ilances(k)}(:,[Si,Ti,Pi]);
            S=STP(:,1);t=STP(:,2);P=STP(:,3);
            pmld=[];
            for m=1:numel(Ip)
                dum=[];
                I=[1];
                switch Iv(m)
                    case 1 %MLD
                        dum=mld(S,t,P); %se calcula la profundidad de mld
                        %I=R.data{ilances(k)}(:,1)>=0&R.data{ilances(k)}(:,1)<=dum; %donde se hara al promedio
                        %I=find(I);
                        
                    case 2 %RA_ILD
                        dum=ra_ild(t,P,0.5);
                    case 3 %RA_MLD
                        dum=ra_mld(S,t,P,0.5);
                    case 0 %cero
                        warning(['No se reconoce la opcion: ',prof{m}])
                        
                end
                
                pmld=[pmld,dum];
                if dum==0
                    keyboard
                end
            end
            I=R.data{ilances(k)}(:,1)>=0&R.data{ilances(k)}(:,1)<=max(pmld);
            I=find(I);
            prof=prof(Ip);
            Insrt=[3:3+numel(prof)-1];
            
            
            
            if isempty(I)
                %   continue
                % keyboard
            end
            I=find(I);
            hacer_promedio=true;
            Ip=1;
    end
    
    
    if isempty(I)
        %continue
    end
    
    
    if hacer_promedio
        py=R.data{ilances(k)}(I,ivars); % carga de datos
        py=nanmean(py);
    else
        
    end
    %Insrt2=max(Insrt)+1:max(Insrt)+size(py,2);
    
    
    vc=f*(k-1)+1:k*f;
    vc=vc(Ip);
    if strcmp(modo,'MLD')
        Insrt2=max(Insrt)+1:max(Insrt)+size(py,2);
        T(vc,Insrt)=pmld;
        T(vc,Insrt2)=py;
    else
        T(vc,3:numel(py)+2)=py;
    end
    
    
    
    
end
if strcmp(modo,'MLD')
    hdr=['Lon';'Lat';prof(:);R.Variables(ivars)];
else
    hdr=['Lon';'Lat';(R.Variables(ivars))];
end
