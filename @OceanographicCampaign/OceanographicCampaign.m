classdef OceanographicCampaign
    %Se define la clase para manejar los datos oceanograficos de IMECOCAL
    % cada objeto contiene toda una campaña
    %
    % [M head]=obj.Lances(in) %sirve para extraer los datos
    %    in: Puede introducirse:
    %           el numero de lance (numerico)
    %           linea.estacion  numerico
    %           linea.estacion  En texto o celdas con texto
    %    M{i} es la matriz correspondiente de in{i}, con p renglones y nvar
    %    columnas
    %    head nombre de las variables (nvar)
    %
    %  Ejemplos
    % R =
    %
    %   OceanographicCampaign with properties:
    %
    %       Crucero: '1407'
    %        Lances: [186x1 double]
    %       nLances: 186
    %     Variables: {5x1 cell}
    %           lat: [186x1 double]
    %           lon: [186x1 double]
    %         fecha: [186x1 double]
    %        linest: {186x1 cell}
    %         linea: [186x1 double]
    %      estacion: [186x1 double]
    %          data: {186x1 cell}
    %
    % [M, h]=R.Lance({'117.30','110.45'})
    % [M, h]=R.Lance([47 71]) %Equivalente usando los numero de lance
    % M =
    %     [508x5 double]
    %     [ 91x5 double]
    % h =
    %     'Presion'
    %     'Temperatura'
    %     'Salinidad'
    %     'Oxigeno'
    %     'Chl-a'
    
    % version 0
    properties %(SetAccess = immutable)
        Crucero
        Lances %cada lance que se realizo, puede haber huecos
        nLances %numero de lances en total %autogenerado
        %Variables %variables disponibles
        
        %metadatos
        
        
         %autogenerado
        
        
        
    end%
    properties
        linest
        fecha
        lat
        lon
        linea
        estacion
        data
        Variables
        userdata
    end
    %properties (Hidden = true,GetAccess =?test_rev );data;end
    %properties (GetAccess =?test_rev );data;end
    %%
    methods
        %% constructor del objeto
        function obj=OceanographicCampaign(M) % A partir de una matriz ya conocida
            
            if nargin ==0 %vacia
                return
            end
            %% calcofi
            if isstruct(M) && isfield(M,'type') && strcmp(lower(M.type),'calcofi')
                
                % Metadata
                obj.Crucero=M.crucero;
                % variables/datos
                % remover vacias
                
                In=find(all(isnan(M.payload)));
                M.payload(:,In)=[];
                M.header(In)=[];
                
                if isfield(M,'cast_id')
                    dumid=unique(M.cast_id);% se buscan las etiquetas cast_id, los lances se numeran consecutivamente sin importar la numeracion orignal de calcofi
                    obj.Lances=1:numel(dumid);
                    [~,~,I]=intersect(dumid,M.cast_id);
                else
                    obj.Lances=unique(M.payload(:,1));
                    [~,~,I]=intersect(obj.Lances,M.payload(:,1));
                end
                obj.nLances=numel(obj.Lances);
                
                
                
                uid=find(~cellfun(@isempty,strfind(lower(M.header),'utc')),1);%id tiempo
                obj.fecha=M.payload(I,uid);
                
                tid=find(~cellfun(@isempty,strfind(lower(M.header),'line')),1);%line
                obj.linea=M.payload(I,tid);
                obj.estacion=M.payload(I,tid+1);
                
                tid=find(~cellfun(@isempty,strfind(lower(M.header),'lat')),1);%id lat
                if ~isempty(tid)
                    obj.lat=M.payload(I,tid);
                    obj.lon=M.payload(I,tid+1);
                else
                    warning('No se identifico los datos de latitud longitud')
                    [lat ,lon]=cc2lat(obj.linea,obj.estacion);
                    Itn=obj.linea <60 | obj.linea >100 | obj.estacion > 150 | obj.estacion<10;
                    if any(Itn)
                        error('Lineas/estaciones fuera de rango')
                    end
                    lat(Itn)=nan;
                    lon(Itn)=nan;
                    obj.lat=lat;
                    obj.lon=lon;
                end
                
                
                
                did=find(~cellfun(@isempty,strfind(lower(M.header),'depth')),1);%prof
                vvar=unique([uid,did:size(M.header,2)]);
                vvar=[did,setdiff(vvar,did)];%poner la profundidad al principio.
                obj.Variables=M.header(vvar)';
                %obj.data{}
                %obj.
                for k=1:obj.nLances
                    if isfield(M,'cast_id')
                        if iscell(M.cast_id)
                            I=strcmp(M.cast_id,dumid(k));
                        else
                            if ~isnan(dumid(k))
                                I=find(M.cast_id==dumid(k));
                            else
                                I=find(isnan(M.cast_id))
                            end
                        end
                    else
                        I=M.payload(:,1)==obj.Lances(k);
                    end
                    if sum(I) ==0
                        keyboard
                    end
                    obj.data{k,1}=M.payload(I,vvar);
                    try
                        obj.linest{k,1}=sprintf('%g.%g',obj.linea(k),obj.estacion(k));
                    catch
                        keyboard
                    end
                end
                % disp(obj.data);
                return
            end
            %% SBE
            if isstruct(M) && isfield(M,'type') && strcmp(lower(M.type),'sbe-files')
                obj.Crucero=M.crucero;
                obj.Lances=M.Lances;
                obj.lat=M.lat;
                obj.lon=M.lon;
                obj.linea=M.linea;
                obj.estacion=M.estacion;
                obj.Variables={};
                if isfield(M,'linest')
                    obj.linest=M.linest;
                    
                    
                end
                for k=1:numel(M.files);
                    fprintf('|')
                    [A B C]=cargar_cnv(M.files{k});
                    vf={};
                    for j=1:numel(C)-1
                        dum=regexp(C{j},'= [a-z,A-Z,\,/,0-9,\-,é]{0,20}:','match');
                        if isempty(dum)
                            keyboard
                        end
                        vf{j}=dum{1}(3:end-1);
                        if strcmp(vf{j},'timeJ')
                            continue
                        end
                        if ~ismember( vf{j},obj.Variables);
                            obj.Variables=[obj.Variables;vf{j}];
                        end
                        
                        
                    end
                    %A=A(:,1:end-1);
                    [~ ,If,Ir ]=intersect(vf,obj.Variables);
                    [~,In]=setdiff(obj.Variables,vf);
                    %  if k==55
                    %      keyboard
                    %  end
                    
                    obj.data{k,1}(:,Ir)=A(:,If);
                    obj.data{k,1}(:,In)=nan;
                    if ~isfield(M,'linest' )
                        [~,obj.linest{k,1}]=fileparts(M.files{k});
                        
                    end
                    
                    fc=filter_text(B,'start_time');
                    fc=regexp(fc{:},'= [a-z,A-Z,\,/,0-9,\-,:, ]{0,40}[','match');
                    obj.fecha(k,1)=datenum(fc{1}(3:end-1));
                    
                    %obj.fecha
                end
                obj.nLances=numel(M.files);
                
                % keyboard
                return
            end
            % revisar tamaños
            if size(M,2)~=20 & size(M,2)~=22;
                error('tamaño incorrecto');
                
            end
            
            %% extraer metadatos
            %base=min(M(:,1));
            obj.Crucero=num2str(M(1,3),'%04d');
            obj.Lances=unique(M(:,1));%-M(1,3)*1000;
            if all(isnan(M(:,1)))
                DU=unique(M(:,[9 10]),'rows');
                obj.nLances=size(DU,1);
                obj.Lances=1:obj.nLances;
                for k=1:obj.nLances
                     I=all(DU(k,:)==M(:,[9 10]),2); %solo disponible en versiones 2018> de matlab
                     M(I,1)=k;
                 end
            else
                obj.nLances=numel(unique(M(:,1)));
            end
            
            
            [~,~,I]=intersect(obj.Lances,M(:,1));
            obj.fecha=datenum(M(I,4),M(I,5),M(I,6),M(I,7),M(I,8),0);
            obj.lat=M(I,12);
            obj.lon=M(I,11);
            obj.linea=M(I,9);
            obj.estacion=M(I,10);
            dum=obj.estacion/100;
            dum(dum>=1)=dum(dum>=1)/10;
            
            
            %% extraer variables
            obj.Variables={'Presion','Temperatura','Salinidad','Oxigeno','Chl-a'}';
            for k=1:obj.nLances
                I=M(:,1)==obj.Lances(k);
                %for j=1:5%13:17;
                obj.data{k,1}=M(I,13:17);
                %end
                obj.linest{k,1}=sprintf('%g.%g',obj.linea(k),obj.estacion(k));
            end
            
        end
        
        
       
        
        
      
       
        function vind=lances_index(obj,lances)
            if numel(obj)>1
                error('Funcion solo para escalares')
            end
            switch class(lances)
                case 'char' %una sola
                    vind=lances_index(obj,{lances});
                case 'cell' %varias
                    %% notacion .x
                    I=find(~cellfun(@isempty,strfind(lower(lances),'.x'))); %notacion 100.x
                    if numel(I)>0
                        %  disp('Modo extendido linea.x')
                    end
                    in2={};
                    for k=1:numel(I)
                        dum=strrep(lower(lances{I(k)}),'.x','');
                        J=obj.linea==str2num(dum);
                        if sum(J)==0
                            disp(['No se encontraron datos de la linea ',lances{I(k)},' crucero:',obj.Crucero])
                        end
                        in2=[in2;obj.linest(J)];
                    end
                    lances(I)=[];
                    lances=[lances;in2];
                    %% 
                    
                    I=ismember(lower(lances),lower(obj.linest));
                    if any(~I)
                        warning(['No se encontraron los lances: '])
                       % disp(lances(~I));
                        %vars=vars(~I);
                    end
                    
                    
                    [~, ~, vind]=intersect(lower(lances),lower(obj.linest),'stable');
                case 'double' %
                    [~, ~, vind]=intersect(lances,obj.Lances,'stable');
                    
                    if numel(vind)<numel(lances)
                        %if any(~I)
                        I=~ismember(lances,obj.Lances);
                        disp(lances(I))
                        warning('Algun(os) de los lances solicitados no fueron encontrados ')
                    end
                    
                otherwise
                    disp(lances)
                    error('No se pueden extraer las variables')
            end
            
            
        end
    end % End de Methods
    %     methods (static)
    %         revision_manualV3
    %     end
end

