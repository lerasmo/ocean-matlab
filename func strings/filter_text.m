function [G I]=filter_text(input,str2,mode2);
%close all
% clear all
% clc
% load('D:\IMP\Revisar DB\Conteo de datos\files_recuperacion_otros.mat')
global string hd he hs  hg hc ig  str mode

if ~exist('input','var')
    input='';
end
if ~exist('str','var')
    str='';
end
if any(size(input))==1
    if ischar(input)
        if isdir(input)
            disp('Modo Directorio')
            %modo directorio
            input=dir(input);
            I=~[input.isdir];
            input={input(I).name}';
        else
            
            if exist(input,'file')
                [~,~,ext]=fileparts(input);
                
                switch lower(ext)
                    case {'.xls','.xlsx'}
                        [~,~,M]=xlsread(input);
                        input=[];
                        % keyboard
                        for k=1:size(M,2)
                            input=[input,strvcat(M{:,k})];
                        end
                        input=mat2cell(input,ones(1,size(input,1)),size(input,2));
                    case '.txt'
                        input=cargar_txt(input,[],1);
                end
            end
        end
        
        
        
    end
    if iscell(input)
    end
end

string=(input);
%string=sort(input);
clear input;
%string = files_recuperacion_otros;
%string=repmat(string,1000,1);

%[ {pushbutton} | togglebutton | radiobutton | checkbox | edit | text | slider | frame | listbox | popupmenu ]
if ~exist('mode2') || isempty(mode2)
    mode2=@all; %| @any
end
mode=mode2;
if ~exist('str2','var')
    str2='';
end
str=str2;
%mode=eval(['@',mode2]);

if nargout==0
    %visible='on';
     ig=true;
    crear_gui
   
else
    ig=false;
    I=find(buscar);
    G=string(I);
    %G=get(hd,'string');
    %visible='off';
    
end
%%
function crear_gui(varargin)
global string hd he hs  hg hc str
p=get(0,'ScreenSize')+[0 48 0 -75];
%  hfig=figure('toolBar','none','menubar','none','position',p,'units','normalized',...
%      'keyPressFcn','','keyReleaseFcn','','WindowButtonupFcn','','WindowButtonDownFcn','',...
%      'visible',visible);
hfig=figure('toolBar','none','menubar','none','units','pixels',...
    'keyPressFcn',@press_tecla,'keyReleaseFcn','','WindowButtonupFcn','','WindowButtonDownFcn','',...
    'visible','on');
set(hfig,'units','normalized')

hl=20/p(end); %pixeles 7x20
%ventana principal
hd=uicontrol('units','normalized','style','listbox',...
    'position',[1/100 2/100+hl .98 97/100-hl  ],'BackgroundColor',[1 1 1],...
    'string',string,'fontname','monospaced','HorizontalAlignment','left',...
    'min',0,'max',numel(string),'callback',@abrir,'KeyPressFcn',@press_tecla);
%ventana de escribir
he=uicontrol('units','normalized','style','edit','position',...
    [1/100 1/100 .50 hl],'BackgroundColor',[1 1 1],'fontname','monospaced',...
    'HorizontalAlignment','left','KeyPressFcn',@buscar,'callback',@buscar,...
    'ButtonDownFcn',@buscar,'string',str);


%modificadores
% sensitive
hs=uicontrol('units','normalized','style','togglebutton','position',...
    [52/100 1/100 .11 hl],'BackgroundColor',[1 1 1],'fontname','monospaced',...
    'HorizontalAlignment','left','KeyPressFcn',@buscar,'callback',...
    @buscar,'ButtonDownFcn',@buscar,'string','Sensible A/a');
set(hs,'units','pixels')
hg=uibuttongroup('units','normalized','position',...
    [64/100 1/100 .15 hl],'BackgroundColor',[1 1 1],'SelectionChangeFcn',@buscar);

hr(1)=uicontrol('units','normalized','style','radiobutton','position',...
    [0/100 0/100 0.3 1],'BackgroundColor',[1 1 1],'fontname','monospaced',...
    'HorizontalAlignment','left','KeyPressFcn',@buscar,'string','Todo',...
    'ButtonDownFcn',@buscar,'parent',hg,'userdata',@all);
hr(2)=uicontrol('units','normalized','style','radiobutton','position',...
    [40/100 0/100 0.6 1],'BackgroundColor',[1 1 1],'fontname','monospaced',...
    'HorizontalAlignment','left','KeyPressFcn',@buscar,'string','Cualquiera',...
    'ButtonDownFcn',@buscar,'parent',hg,'userdata',@any);
%contador de la lista
hc=uicontrol('units','normalized','style','text','position',...
    [80/100 1/100 .09 hl],'BackgroundColor',[1 1 1],'fontname','monospaced',...
    'HorizontalAlignment','center','KeyPressFcn',@buscar,'callback',...
    @buscar,'ButtonDownFcn',@buscar,'string',num2str(numel(string)));
%boton para exportar
hex=uicontrol('units','normalized','style','pushbutton','position',...
    [90/100 1/100 .09 hl],'BackgroundColor',[1 1 1],'fontname','monospaced',...
    'HorizontalAlignment','center','KeyPressFcn',@exportar,'callback',...
    @exportar,'ButtonDownFcn',@exportar,'string','exportar');
% todas las palabras
% cualquier palabra
hg.SelectedObject=hr(1);
buscar;


%if nargout~=0
%    G=get(hd,'string');
%    close(hfig);
%    return
%end

%%

function I=buscar(varargin)
global string hd he hs  hg hc ig str mode
I=[];
if ig
    set(hc,'string','~filtrando~');
    str=deblank(get(he,'string'));
else
end

%drawnow

str(str==9)=32; %cambiar tabuladores por espacios.
if isempty(str) && ig
    
    set(hd,'string',string,'value',1);
    set(hc,'string',num2str(numel(string)));
    
    return
else
    str=eval(['{''',strrep(str,' ',''','''),'''};']);
    str=str(~cellfun(@isempty,str));
    if ig
        sensitive = get(hs,'value');
        mode = get(get(hg,'selectedObject'),'userdata'); % any o alls
    else
        sensitive=false;
        %mode=@and;
        
    end
    
    %if mode(1,0)
    %    I=false(numel(string),1);
    %else
    %    I=true(numel(string),1);
    %end
    if ~sensitive
        strT=upper(string);
        strf=upper(str);
    else
        strT=string;
        strf=str;
    end
    I=true(size(strT));
    for k=1:numel(str)
        if strcmp(strf{k}(1),'~')
            strf{k}=strf{k}(2:end);
            I=mode([I, cellfun(@isempty,strfind(strT,strf{k}))],2);
        elseif strcmp(strf{k}(1),'|')
            
            %keyboard
            %mode=@any;
            strf{k}=strf{k}(2:end);
            I=I | ~cellfun(@isempty,strfind(strT,strf{k}));
        else
            I=mode([I, ~cellfun(@isempty,strfind(strT,strf{k}))],2);
            %I=mode(I,~cellfun(@isempty,strfind(strT,strf{k})));
        end
       %strT(I)
    end
%  I=mode(I,2);
    %keyboard
    if all(~I) & ig
        set(hd,'string','','value',1);
        set(hc,'string','0');
    elseif ig
        
        set(hd,'string',string(I),'value',1);
        set(hc,'string',num2str(sum(I)));
    else
    end
end


function exportar(varargin)
global hd
assignin('base','filter_list',get(hd,'string'));
evalin('base','whos filter_list');

function abrir(varargin)
global hd

if strcmp(get(gcf,'selectionType'),'open')
    str=get(hd,'string');
    v=get(hd,'value');
    file=str{v};
    [~,filename,ext]=fileparts(file);
    if strcmpi(ext,'.mat')
        %       graficar_datos(file);
        D=load(file);
    else
        winopen(file);
    end
end


function press_tecla(varargin)

r=varargin{2};
if strcmp(lower(r.Key),'d') & strcmp(r.Modifier,'control') %open dir
    global hd
    str=get(hd,'string');
    v=get(hd,'value');
    str=str{v};
    [dir ,file, ext]=fileparts(str);
    dos(['explorer ',dir]);
    % keyboard
end
if strcmp(lower(r.Key),'x') & strcmp(r.Modifier,'control') %exit
    close(gcf)
end
