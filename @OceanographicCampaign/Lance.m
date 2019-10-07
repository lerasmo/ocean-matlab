function [R, head,nfo]=Lance(obj,in,vars) %funcion para extraer la matriz de datos
head={};nfo={};
R=[];
if ~exist('vars','var')
    vars=[];
end
if ~exist('in','var')
    in=[];
end
if numel(obj)>1 %para multiples cruceros
    R={};
    nfo={};
    for k=1:numel(obj)
        try
            
            [dum1, head{k,1},nf]=Lance(obj(k),in,vars);
        catch
            keyboard
        end
        nfo=[nfo;nf];
        R=[R;dum1];
        %keyboard
        
    end
    %head=head{1};
    return
end
%% comprobacion de las entradas
if ~exist('vars','var') | isempty(vars);
    vars=1:numel(obj.Variables);%todas
    
else
    
    if ~ismember('gpan',lower(obj.Variables)) & ismember('gpan',vars)
        obj=obj.gpan;
    end
    if ~ismember('sigma',lower(obj.Variables)) & ismember('sigma',vars)
        obj=obj.dynamic_variable('sigma');
    end
    
    vars=vars_index(obj,vars);
    if any(vars==-1)
        warning('Sin datos')
        return
        
        
    end
    in=in(:);
if isempty(in)
    in=obj.Lances;
end
if isnumeric(in) && all(in==round(in)) % Por numero de lance
    if numel(obj)>1
        
        error('Al indicar el numero de lance solo se puede usar en un solo crucero')
    end
    n=find(ismember(obj.Lances,in));
    
elseif isnumeric(in) && all(~isinteger(in)) %por linea.estacion desde numerico
    in=num2str(in,'%3.2f');
    in=mat2cell(in,ones(1,size(in,1)),size(in,2));
end
if all(ischar(in)) | iscell(in) %por linea.estacion desde texto
    
    %keyboard
    I=find(~cellfun(@isempty,strfind(lower(in),'.x'))); %notacion 100.x
    if numel(I)>0
        %  disp('Modo extendido linea.x')
    end
    in2={};
    for k=1:numel(I)
        dum=strrep(lower(in{I(k)}),'.x','');
        J=obj.linea==str2num(dum);
        if sum(J)==0
            disp(['No se encontraron datos de la linea ',in{I(k)},' crucero:',obj.Crucero])
        end
        in2=[in2;obj.linest(J)];
    end
    in(I)=[];
    in=[in;in2];
    I=ismember(obj.linest,in);
    n=find(I);
    
    
end
% if numel(n)~=numel(in)
% %    warning('No se encontraron todos los lances solicitados')
%     %disp(in(~I))
% end
%%
%


for k=1:numel(n)
    try
        dum=obj.data{n(k)}(:,vars);
    catch
        
        keyboard
    end
    %I=all(isnan(dum),1);
    %dum(:,I)=[];
    R{k,1}=dum;
    
    nfo(k,1)={obj.Crucero};
    nfo(k,2)=obj.linest(n(k));
    nfo{k,3}=obj.linea(n(k));
    nfo{k,4}=obj.estacion(n(k));
    nfo{k,5}=obj.fecha(n(k));
    nfo{k,6}=datestr(obj.fecha(n(k)));
end
%if numel(n)==1
%    R=obj.data{n}(:,vars);
%end

%end
head=obj.Variables(vars);

end