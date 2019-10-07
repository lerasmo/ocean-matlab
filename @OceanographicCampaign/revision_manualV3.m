function revision_manualV3(R,file_name)
%Version 3 de la revision manual. Se usa la clase oceanographiccampaing
%
% Erasmo Jan-2017

% Funcion para limpiar lances cualquiera de cualquier  que se me
% ocurra, fue algo dificil de hacer, pero bueno, ahi va
% data = R.revision_manualV3(MATRIZ,lance_col,vars_col,vars_name)
% MATRIZ: Matriz de datos cualquiera, con 1 columna de id de lance (numero
% de lance p.e.), 1 columna de presion, y al menos una columna de datos
% lance_col: numero de columna que identifica al lance
% vars_col: vector con numero de las columnas de varibles, el primer
% elemento debe ser la columna de presion: [4 5 6 7], signfica que la
% columna 4 es la presion y 5,6 y 7 son variables
% vars_name: vector de celdas conteniendo el nombre de las variables.
%
%
% luis erasmo miranda bojorquez
% luis.erasmo@gmail.com
% sept-2009


empty k fig1 nvar  axh1 axh2    existe   vars_name handles % I lance_col  vars_col lances_id%%globales
%empty  in ph t p auto_interp int id  hs  ht st h%file_name% variables %globales
i=[];ph=[]; t=[]; p=[];auto_interp=[]; int=[]; id=[];  hs=[]; ht=[]; st=[];h=[];in=[];


var_salida=inputname(1);



%% INICIAR INTERFACE GRAFICA


% function crear_gui

if isempty(existe) %& exist('fig1') && ~isempty(;
    k=1;
    % [lances_id, I]= unique(MATRIZ(:,lance_col));
    
    nd=1;
    est_string=R.linest;
    vars_name=R.Variables(2:end);
    
    
    %pos_ini=[1 49 1920 1080-80];
    pos_ini=get(0,'ScreenSize');
    %pos_ini=[1537          -3        1536         836];%izquierda
    
    fig1=figure('DeleteFcn',@salida_gui,'DockControls','off',...
        'Resize','off','menubar','none','Name','Revision de lances de CTD','NumberTitle','off',...
        'position',pos_ini,'Interruptible','off','visible','off',...
        'WindowKeyPressFcn',@keypressfnc);
    hphoto=uicontrol('Parent', fig1,'position',  [    11   800   127    32],'string','Guardar Imagen','callback',@ftake_photo);
    hcritic=uicontrol('Parent', fig1,'position', [    11   760   127    32],'string','Marcar como critico','callback',@ftake_critic);
    % hprev_cr=uicontrol('Parent', fig1,'position',[   500    40   90    38],'string','<<Crucero','callback',@fprev_cr);
    hprev_st=uicontrol('Parent', fig1,'position',[   600    40   90    38],'string','<Estacion','callback',@fprev_st);
    hnext_st=uicontrol('Parent', fig1,'position',[   710    40   90    38],'string','Estacion>','callback',@fnext_st);
    % hnext_cr=uicontrol('Parent', fig1,'position',[   810    40   90    38],'string','Crucero>>','callback',@fnext_cr);
    hst_list=uicontrol('Parent', fig1,'position',[    11   720   127    16],...
        'style','popupmenu','string',est_string,'callback',@fst_list,'backgroundcolor',[1 1 1]);
    % hcr_list=uicontrol('Parent', fig1,'position',[    11   690   127    16],...
    %     'style','popupmenu','string',cr_string,'callback',@fcr_list,'backgroundcolor',[1 1 1]);
    hdum=uibuttongroup('Parent', fig1,'units','pixels','position',[  11   550   140   100],'Title','Variables','SelectionChangeFcn',...
        @fselect_var,'backgroundcolor',[0.8 0.8 0.8]);
    
    
    hvar= uicontrol('Parent', hdum,'units','normalized','style','popupmenu','string',vars_name,'position',[0.1 1.3-0.6 0.8 0.3],'userdata',...
        1,'backgroundcolor',[0.8 0.8 0.8],'Callback',@fselect_var);
    
    
    
    axh1=axes('ydir','reverse');
    axh2=axes('ButtonDownFcn','','color','none','xtick',[],'ytick',[],'ydir','reverse','box','on');
    linkaxes([axh1,axh2],'xy')
    set(fig1,'WindowButtonDownFcn',@frecortar,'WindowButtonMotionFcn', @move,	'WindowButtonUpFcn', @up)
    
    hgrid=uicontrol('parent',fig1,'position',[  25   520   127    16],'style','checkbox','String','   Grid','backgroundcolor',[0.8 0.8 0.8],'callback',@fgrid);
    hdelete=uicontrol('parent',fig1,'position',[  11   470   127    32],'style','pushbutton','String','Eliminar Seleccion',...
        'backgroundcolor',[0.8 0.2 0.2],'callback',@fdelete);
    %         hproc=uicontrol('parent',fig1,'position',[  11   420   127    32],'style','pushbutton','String','Deshacer cambios del lance',...
    %             'backgroundcolor',[0.2 0.8 0.8],'callback',@fprocesar);
    
    hpbaj=uicontrol('parent',fig1,'position',[  11   420   62    32],'style','pushbutton','String','Pri baj',...
        'backgroundcolor',[0.2 0.8 0.8],'callback',@fprocesar,'tag','pbaj');
    hpsub=uicontrol('parent',fig1,'position',[  94   420   62    32],'style','pushbutton','String','Pri sub',...
        'backgroundcolor',[0.2 0.8 0.8],'callback',@fprocesar,'tag','psub');
    hsbaj=uicontrol('parent',fig1,'position',[  11   370   62    32],'style','pushbutton','String','Sec baj',...
        'backgroundcolor',[0.2 0.8 0.8],'callback',@fprocesar,'tag','sbaj');
    hssub=uicontrol('parent',fig1,'position',[  94   370   62    32],'style','pushbutton','String','Sec sub',...
        'backgroundcolor',[0.2 0.8 0.8],'callback',@fprocesar,'tag','ssub');
    
    %hproc_subida=uicontrol('parent',fig1,'position',[  11   385   127    32],'style','pushbutton','String','Lance de subida ',...
    %    'backgroundcolor',[0.2 0.8 0.8],'callback',@fprocesar_subida);
    %hproc_bajada=uicontrol('parent',fig1,'position',[  11   350   127    32],'style','pushbutton','String','Lance de bajada',...
    %    'backgroundcolor',[0.2 0.8 0.8],'callback',@fprocesar_bajada);
    %hcomentario=uicontrol('parent',fig1,'position',[  11   250   127    32],'style','pushbutton','String','Añadir Comentario',...
    %    'callback',@fcomment);
    hinterpol=uicontrol('parent',fig1,'position',[  11   290   127    32],'style','pushbutton','String','Auto Interpolar',...
        'callback',@finterpol);
    hinter_lock=uicontrol('parent',fig1,'position',[  140   290   32    32],'style','checkbox','String','LCK',...
        'callback',@lock_interpol);
    nvar=1; % primera variable seleccionada, presion es 0, temp 1;..
    set(fig1,'visible','on') % ya se creo se pone como visible
    %        handles.hcomentario=hcomentario;
    handles.hcritic=hcritic;
    handles.hgrid=hgrid;
    handles.hpbaj=hpbaj;
    handles.hsbaj=hsbaj;
    handles.hpsub=hpsub;
    handles.hssub=hssub;
    
    %        handles.hnext_cr=hnext_cr;
    %    handles.hoxy=hoxy;
    %        handles.hprev_cr=hprev_cr;
    %     handles.hproc=hproc;
    %       handles.hproc_subida=hproc_subida;
    handles.hst_list=hst_list;
    %        handles.hcr_list=hcr_list;
    handles.hdelete=hdelete;
    handles.hinterpol=hinterpol;
    handles.hnext_st=hnext_st;
    handles.hphoto=hphoto;
    handles.hprev_st=hprev_st;
    %      handles.hproc_bajada=hproc_bajada;
    %   handles.hsal=hsal;
    handles.hvar=hvar;
    handles.all=[hcritic,hgrid,...
        hst_list,hdelete,hinterpol,...
        hnext_st,hphoto,hprev_st];
    existe =1;
    
    dibujar_lance
end %existe, crear gui


    function dibujar_lance(varargin)
        %% GRAFICADO PRINCIPAL
        if k<=1 %control de botones
            k=1;
            set(handles.hnext_st,'enable','on')
            set(handles.hprev_st,'enable','off')
        elseif k>=R.nLances;
            set(handles.hnext_st,'enable','off')
            set(handles.hprev_st,'enable','on')
        else
            set(handles.hnext_st,'enable','on')
            set(handles.hprev_st,'enable','on')
        end
        set(handles.hst_list,'value',k) % se ponen las listas de las estaciones disponibles
        
        %I = find(MATRIZ(:,lance_col) == lances_id(k));
        fplot='+-r';
        p=R.data{k}(:,1);
        t=R.data{k}(:,nvar+1); %se suma 1 por la presion
       
        if isempty(ph)
            ph=plot(axh1,t,p,fplot, 'MarkerSize',2); %Se grafica el perfil
            set([axh1 axh2],'ydir','reverse')
            linkaxes([axh1 axh2],'xy')
            ph.XDataSource='t';
            ph.YDataSource='p';
            hold on
        else
            refreshdata(axh1,'caller');
        end
        try
            axis(axh1,[min(t)-5 max(t)+5 min(p) max(p) ]);
        catch
        end
        
        if get(handles.hgrid,'value') % rejilla on/off
            grid(axh1,'on')
        else
            grid(axh1,'off')
        end
        %nvar
        
         if auto_interp
            finterpol
        end
        
    end


%% Funcion de seleccionar y recortar
    function frecortar(varargin) % cuando baja el click
        % Sirve para poder seleccionar los puntos de nuestro interes:
        % seleccionando con el click izquierdo se añaden puntos a la seleccion
        % con el click derecho se quitan puntos de la seleccion
        % con el click central se invierte la seleccion
        %global axh1 axh2 in t p h hs id
        if numel(in)~=numel(t)
            in=zeros(size(t));
        end
        
        button = get(gcf, 'SelectionType');
        if strcmp(button,'open')
            button = 1;
        elseif strcmp(button,'normal')
            button = 1;
        elseif strcmp(button,'extend')
            button = 2;
        elseif strcmp(button,'alt')
            button = 3;
        else
            error('MATLAB:ginput:InvalidSelection', 'Invalid mouse selection.')
        end
        
        M=get(axh2,'currentPoint');
        cpx=M(1,1);
        cpy=M(1,2);
        x=[cpx cpx cpx cpx cpx];
        y=[cpy cpy cpy cpy cpy];
        hs=plot(x,y,'-','color',[0.5 0.5 0.5]);
        id=1;
        
    end
    function move(varargin)% cuando se mueve el cursor con el boton abajo, marca el cuadro y selecciona sobre el poligono
        %global axh1 axh2 t p  hs id st int ht
        if ~exist('id') || isempty(id) || id==0
            return
        end
        M=get(axh2,'currentPoint');
        axis manual
        cpx=M(1,1);
        cpy=M(1,2);
        x=get(hs,'xdata');
        y=get(hs,'ydata');
        x([2 3])=cpx;
        y([3 4])=cpy;
        
        set(hs,'Xdata',x,'Ydata',y)
        st= get(gcf,'selectionType');
        %return
        int=inpolygon(t,p,x,y);
        
        %in=logical(in);
        %if numel(h)==1
        %    try
        %        delete (h);
        %    end
        %h=[];
        %end
        hold(axh1,'on')
        if isempty(ht)
            ht= plot(axh1,t(int),p(int),'.','markeredgecolor',[0.4 .8 .8]); % se grafican con otro colos los puntos seleccionados
        else
            set(ht,'xdata',t(int),'ydata',p(int))
        end
        %h= plot(axh1,t(in),p(in),'.','markeredgecolor',[0.4 .8 .4]); % se grafican con otro colos los puntos seleccionados
        hold(axh1,'off')
        
    end

    function up(varargin) %sucede cuando se suelta el click
        %global axh1 axh2 in t p h hs id st int ht R
        id=0;
        if isempty(int) | isempty(in)
            return
        end
        if strcmp(st,'normal')  %se identifica el boton del raton y se añaden o quitan puntos
            %keyboard
            try
                in= in |   int;
            catch
                in=[];
                int=[];
                dibujar_lance
                return
            end
        elseif strcmp(st,'alt')
            %in(in & int)=false;
            %disp('at')
            in= in & ~int;
            
        elseif strcmp(st,'extend')
            in=xor( in , int);
        end
        int(:)=false;
        delete(hs)
        delete(ht); ht=[];
        hold(axh1,'on')
        %keyboard
        
        if  isempty(h)
            h= plot(axh1,t(in),p(in),'+','markeredgecolor',[0 0 1]); % se grafican con otro colos los puntos seleccionados
        else
            set(h,'xdata',t(in),'ydata',p(in))
            
        end
        hold(axh1,'off')
        return
        
    end
%% FUNCIONES DE CONTROL


    function fprev_st(varargin)
        % Boton de la estacion anterior
        
        if numel(h)==1
            try
                delete (h);
                h=[];
                in=[];
            end
        end
        k=k-1;
        if k<=1; %control de botones
            k=1;
            set(handles.hprev_st,'enable','off')
        end
        dibujar_lance
    end
    function fnext_st(varargin)
        % Boton de la siguiente estacion
        
        
        if numel(h)==1
            delete (h);
            h=[];
            in=[];
        end
        k=k+1;
        if k>=R.nLances; %control de botones
            k=R.nLances;
            set(handles.hnext_st,'enable','off')
        end
        dibujar_lance
    end

    function fst_list(varargin)
        % Seleccionar desde la lista/scroll de estaciones
        
        if numel(h)==1
            delete (h);
            h=[];
            in=[];
        end
        k=get(handles.hst_list,'value');
        dibujar_lance
    end

    function fcr_list(varargin)
        % Seleccionar desde la lista/scroll de cruceros
        
        if numel(h)==1
            delete (h);
            h=[];
            in=[];
        end
        nd=get(handles.hcr_list,'value');
        est=get(handles.hst_list,'string');
        k=str2double(est(k,end-6:end));
        R.revision_manualV3
    end

    function ftake_photo(varargin)
        
        
        set(handles.all,'enable','off')
        drawnow
        name=[vars_name{nvar},num2str(est),'.jpg'];
        F=getframe(fig1);
        
        imwrite(F.cdata,['REVISION\',name],'jpg','quality',100)
        set(handles.all,'enable','on')
    end
    function ftake_critic(varargin)
        % Se toma una instantanea del todo el GUI y se guarda en \revision\criticos
        
        set(handles.all,'enable','off')
        drawnow
        F=getframe(fig1);
        imwrite(F.cdata,['REVISION\criticos\',xlb],'jpg','quality',100)
        set(handles.all,'enable','on')
    end
    function fselect_var(varargin)
        % Radio Button para seleccionar entre salinidad temperatura y oxigeno
        
        if numel(h)==1
            delete (h);
            h=[];
            in=[];
        end
        nvar=varargin{1}.Value;
        dibujar_lance
    end
    function fgrid(varargin)
        % Poner/Quitar rejilla
        %global axh1
        grid(axh1)
    end
    function fdelete(varargin)
        
        if isempty(h);
            return
            
        else
            
            
            R.data{k}(in,nvar+1)=nan;
            if numel(h)==1
                delete (h);
                h=[];
            end
            in=[];
            %save(file_crucero,'MATRIZ');
            %    set(handles.all,'enable','on')
            
            dibujar_lance
        end
    end
    function fprocesar(varargin)
        % Boton para reprocesar el lance que se esta mostrando
        %global h handles in crucero est MATRIZ file_name
        %eval(['%global MATRIZ; B = MATRIZ; save ',file_name,' B; '])
        save(file_name(2:end-1),'MATRIZ')
        set(handles.all,'enable','off')
        
        
        
        if numel(h)==1
            delete (h);
            h=[];
            in=[];
        end
        drawnow
        %keyboard
        val= get(handles.hst_list,'value');
        I=find((MATRIZ(:,2)-MATRIZ(1,2)+1)==val);
        lan=MATRIZ(I(1),1)-MATRIZ(1,3)*1000;
        S.cruceros=MATRIZ(1,3);
        S.archivos_entrada={sprintf('lan%03d.dat',lan)};
        S.sobreescribir=0; % 1: se borra toda la matriz. 0 se sustituye solo los lances
        S.nlances=lan;
        %S.rev='rev';
        
        switch get(varargin{1},'tag')
            
            case 'pbaj'
                
                S.source='bajada';
                S.sensores='primarios';
                
                %MATRIZ=rebanador(MATRIZ(1,3),val,'actualizar','bajada','primarios','rev');
            case 'psub'
                S.source='subida';
                S.sensores='primarios';
                
                %MATRIZ=rebanador(MATRIZ(1,3),val,'actualizar','subida','primarios','rev');
            case 'sbaj'
                S.source='bajada';
                S.sensores='secundarios';
                
                %MATRIZ=rebanador(MATRIZ(1,3),val,'actualizar','bajada','secundarios','rev');
            case 'ssub'
                S.source='subida';
                S.sensores='secundarios';
                
                %MATRIZ=rebanador(MATRIZ(1,3),val,'actualizar','subida','secundarios','rev');
            otherwise
                error('Mmmta ma con este programaitor')
        end
        R=rebanador(S);
        
        R(:,1)=MATRIZ(I(1),1);
        R(:,2)=MATRIZ(I(1),2);
        %keyboard
        
        MATRIZ(I,:)=[];
        MATRIZ=[MATRIZ;R];
        clear I
        
        set(handles.all,'enable','on')
        
        R.revision_manualV3
    end

    function logger(arbol,eliminar)
        return
        %global log_n LOG
        k=find_log(arbol.crucero,arbol.est,arbol.variable);
        log_n=size(LOG,1);
        if exist('eliminar','var')
            if strcmp(eliminar,'eliminar')
                LOG=LOG((1:log_n)~=k,: );
                save('log_de_revision.mat','LOG','log_n')
                log_n=size(LOG,1);
                return
            end
        end
        
        if k==0
            k=log_n+1;
        end
        
        
        
        
        
        field=isfield(arbol,{'crucero'	'est'	'lance'	'variable'		'quit'	'sentido'	'prof_interp'	'comentarios'});
        if field(1)
            LOG(k,1)={arbol.crucero};
        end
        if field(2)
            LOG(k,2)={arbol.est};
        end
        if field(3)
            LOG(k,3)={arbol.lance};
        end
        if field(4)
            LOG(k,4)={arbol.variable};
        end
        if field(5)
            if isempty(arbol.quit)
                LOG(k,5)={arbol.quit};
            else
                LOG(k,5)={unique([LOG{k,5}; arbol.quit])};
            end
        end
        if field(6)
            LOG(k,6)={arbol.sentido};
        elseif isempty(LOG{k,6})
            LOG(k,6)={'Normal'};
        end
        if field(7)
            if isempty(arbol.prof_interp)
                LOG(k,7)={arbol.prof_interp};
            else
                LOG(k,7)={unique([LOG{k,7}; arbol.prof_interp])};
            end
        end
        if field(8)
            LOG(k,8)={arbol.comentarios};
        end
        log_n=size(LOG,1);
        LOG
        save('log_de_revision.mat','LOG','log_n')
    end
    function keypressfnc(varargin)
        %controles del teclado
        
        cc=double(lower(get(gcf,'currentCharacter')));
        if ~isnumeric(cc) | isempty(cc)
            return
        end
        switch cc
            case 127 %suprimir, borrar
                fdelete
            case 29 %avanzar
                fnext_st
            case 28 %retroceder
                fprev_st
        end
    end

    function finterpol(varargin)
        K = find(~isnan(t));
        if isempty(K)
            return
        end
        
        set(handles.all,'enable','off')
        in = [];
        int=[];
        try
            t = interp1(p(K),t(K),p);
        catch
            keyboard
        end
        
        
        
        R.data{k}(:,nvar+1)=t;
        
        set(handles.all,'enable','on')
        
        refreshdata(axh1,'caller');
        
    end

    function salida_gui(varargin)
        if ~exist('file_name','var') & ~isempty(var_salida)
            assignin('base',var_salida,R);
            return
        end
        if ~exist('file_name') || isempty(file_name)
            warning('No se especifico archivo de salida, no se guardaron los cambios')
            return
        end
        [~,base,ext]=fileparts(file_name);
        if strcmp(lower(ext),'.mat') %guardar a archivo
            disp(['Se guardo la variable R en el archivo ',file_name]);
            save(file_name,'R');
            clear all
            
            return
        elseif ~isempty(ext)
            warning(['Se omitio la extension ',ext])
            
        end
        disp(['Se creo la variable ',base]);
        assignin('base',base,R);
        clear all
    end


    function lock_interpol(varargin)
        
        slf=varargin{1};
        if slf.Value
            hinterpol.Value=1;
            hinterpol.Enable='off';
            auto_interp=1;
        else
             hinterpol.Value=0;
            hinterpol.Enable='on';
            auto_interp=0;
        end
    end
end



