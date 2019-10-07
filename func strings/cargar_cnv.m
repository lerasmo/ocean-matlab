function [DATA head hdr] =  cargar_cnv(file)
% USO
% [DATA nombre_columnas encabezado_entero]=cargar_cnv('archivo.cnv');
% DATA: todos los datos
% nombre_columnas: los nombres de cada columna %este argumento es opcional
% encabezado_entero: todo el encabezado del cnv %tambien es opcional
% NOTA: se requiere la funcion cargar_txt2.m

% Luis Erasmo M.B.
% luis.erasmo@gmail.com
% 10-Sep-2008

%file='X:\Trabajos con UTCAM\base de datos\RedMonitoreo\DATOS\ANCLAJES\CNK30\RECUPERACIONES\EP4-T3300-CNK30\MCTS\EP4-T3300-MCT-NS6163-Z119-INS27-REC30_RAW\EP4-T3300-MCT-NS6163-L.cnv';
TEX=cargar_txt2(file,'windows-1252');
TEX=strrep(TEX,'-9.990e-29','nan');
TEX=strrep(TEX,'%','');
%en=min([400 numel(TEX)]);
%I=cellfun(@strfind,lower(TEX(1:en)),repmat({'*end*'},en,1),'UniformOutput',false);
Ia=find(~cellfun(@isempty,strfind(lower(TEX),'end')));
Ib=find(~cellfun(@isempty,strfind(lower(TEX),'start sample')));
if numel(Ib) >1 %varias etiquetas start sample number
    TEX(Ib(2:end))=[];
    Ib=Ib(1);
elseif numel(Ib)==0  %Sin etiqueta de start sample number
    Ib=Ia;
end
I=max([Ia Ib]);
%keyboard
%I2=find(~cellfun(@isempty,I));
if isempty(I)
    warning('END flag not found')
    try
        DATA=load(file);
        return
    catch
        error('Imposible cargar')
    end
    
end
%keyboard
TEX2=TEX(I+1:end);

d=find(~cellfun(@isempty,TEX2));

strdata=char(TEX2(d));

d=~all(strdata==' ',2);
strdata=strdata(d,:);
DATA=str2num(strdata);%datos principales
if isempty(DATA)
    try 
        DATA=load(file);
    end
end
if isempty(DATA)
    
    cm=find([',',strdata(1,:),',']==','); %separado por comas?
    if numel(cm)==2

        dum=[',',regexprep(strdata(1,:),' ',','),','];
        cm=find(dum==',');
    end
    
    
    disp('cargando modo dificil')
    try 
        DATA=load(file);
    end
    t0=[];
    cnt=0;
    for k=1:numel(cm)-1;
        dtx=lower(strdata(:,cm(k):cm(k+1)-2));
        if isempty(dtx)
            continue
        end
        cnt=cnt+1;
        %keyboard
        if (any(dtx(:)=='a') ||any(dtx(:)=='e') ||any(dtx(:)=='j') ||any(dtx(:)=='m') ||any(dtx(:)=='o') ||any(dtx(:)=='s') || any(dtx(:)==':')) &~any(dtx(:)=='+')
            if  any(dtx(:)==':')
                
                dtx(dtx==':')=' ';
                t0(2)=k;
                dumy=str2num(dtx);
            else
                [dats, ~ , Idats]=unique(dtx,'rows','stable');
                
                dats=datenum(dats);
                dumy=dats(Idats);
                %dumy=nan(size(dtx,1),1);
                t0(1)=cnt;
            end
            
        else
            dumy=str2num(dtx);
        end
        fprintf('|')
        %if isempty(dumy)
        
        if size(dumy,2)==1
            D(:,cnt)=dumy;
        elseif size(dumy,2)==3
            
            D(:,t0(1))=D(:,t0(1))+dumy(:,1)/24+dumy(:,2)/1440+dumy(:,3)/86400;
            
            
        else
            keyboard
        end
        
        %    keyboard
        %end
        %keyboard
    end
    if size(t0,2)==2
        D=D(:,setdiff(1:size(D,2),t0(2)));
    end
    
    DATA=D;
end

%return

head=(TEX(1:I)); %encabezado completo del .cnv

%I=cellfun(@strfind,lower(TEX(1:en)),repmat({'name 0'},en,1),'UniformOutput',false);
I1=find(~cellfun(@isempty,strfind(lower(TEX),'name 0')));
%I1=find(~cellfun(@isempty,I));
%I=cellfun(@strfind,lower(TEX(1:en)),repmat({'span 0'},en,1),'UniformOutput',false);
I2=find(~cellfun(@isempty,strfind(lower(TEX),'span 0')));
%I2=find(~cellfun(@isempty,I));
hdr=TEX(I1:I2-1);
%varargout(2)={heads}; %solamente los encabezados de los nombres de las columnas


