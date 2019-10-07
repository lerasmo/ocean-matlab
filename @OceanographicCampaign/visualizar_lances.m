function visualizar_lances(R)



persistent  k   fig1 nvar ph axh1 axh2  t p  existe   vars_name % I lance_col  vars_col lances_id%%globales
persistent handles h %file_name% variables %globales


%persistent LOG log_n   variable

%% INICIAR INTERFACE GRAFICA


% function crear_gui

if isempty(existe);
    k=1;
    % [lances_id, I]= unique(MATRIZ(:,lance_col));
    
    nd=1;
    est_string=R.linest;
    vars_name=R.Variables(2:end);
    
    
    %pos_ini=[1 49 1920 1080-80];
    pos_ini=get(0,'ScreenSize');
    %pos_ini=[1537          -3        1536         836];%izquierda
    
    fig1=figure('DeleteFcn','','DockControls','off',...
        'Resize','on','menubar','none','Name','Revision de lances de CTD','NumberTitle','off',...
        'position',pos_ini,'Interruptible','off','visible','on',...
        'WindowKeyPressFcn',@keypressfnc);
    hprev_st=uicontrol('Parent', fig1,'position',[   600    40   90    38],'string','<Estacion','callback',@fprev_st);
    hnext_st=uicontrol('Parent', fig1,'position',[   710    40   90    38],'string','Estacion>','callback',@fnext_st);

    hst_list=uicontrol('Parent', fig1,'position',[    11   720   127    16],...
        'style','popupmenu','string',est_string,'callback',@fst_list,'backgroundcolor',[1 1 1]);
 
    hdum=uibuttongroup('Parent', fig1,'units','pixels','position',[  11   550   140   100],'Title','Variables','SelectionChangeFcn',...
        @fselect_var,'backgroundcolor',[0.8 0.8 0.8]);
    
    
    hvar= uicontrol('Parent', hdum,'units','normalized','style','popupmenu','string',vars_name,'position',[0.1 1.3-0.6 0.8 0.3],'userdata',...
        1,'backgroundcolor',[0.8 0.8 0.8],'Callback',@fselect_var);
    
    
    
    axh1=axes('ydir','reverse');
    axh2=axes('ButtonDownFcn','','color','none','xtick',[],'ytick',[],'ydir','reverse','box','on');
    linkaxes([axh1,axh2],'xy')
    
    hgrid=uicontrol('parent',fig1,'position',[  25   520   127    16],'style','checkbox','String','   Grid','backgroundcolor',[0.8 0.8 0.8],'callback',@fgrid);
    %hdelete=uicontrol('parent',fig1,'position',[  11   470   127    32],'style','pushbutton','String','Eliminar Seleccion',...
    %    'backgroundcolor',[0.8 0.2 0.2],'callback',@fdelete);
    %         hproc=uicontrol('parent',fig1,'position',[  11   420   127    32],'style','pushbutton','String','Deshacer cambios del lance',...
    %             'backgroundcolor',[0.2 0.8 0.8],'callback',@fprocesar);
    
     
    handles.hgrid=hgrid;
    handles.hst_list=hst_list;

    
    
    handles.hnext_st=hnext_st;
    handles.hprev_st=hprev_st;
    handles.hvar=hvar;
    existe =1;
    nvar=1;
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
            title(axh1,R.Variables(nvar+1))
            ylabel(axh1,['Profunidad ',R.Variables{1}])
        else
            refreshdata(axh1,'caller');
            title(axh1,R.Variables(nvar+1))
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
   
    function keypressfnc(varargin)
        %controles del teclado
        
        cc=double(lower(get(gcf,'currentCharacter')));
        if ~isnumeric(cc) | isempty(cc)
            return
        end
        switch cc
            
            case 29 %avanzar
                fnext_st
            case 28 %retroceder
                fprev_st
        end
    end

    
end



