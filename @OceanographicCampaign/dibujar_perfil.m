function fname = dibujar_perfil(R,k);
%ax=[];
%close all
%load 1710.mat


%k=1;
if numel(R)>1
    error('Funcion solo para escalares')
end
j=R.lances_index(k);
if numel(j)>1
    for k=1:numel(j)
        [ fname]=dibujar_perfil(R,j(k));
    end
end


[D a z]=R.Lance(k,{'Presion','Temperatura','Salinidad','Oxigeno','sigma'});
if isempty(D)
    warning('Sin datos')
    fname=-1;
end
%return
if ~isnumeric(k)
    k=R.lances_index(k);
end

M=D{1}(:,2:end);
P=D{1}(:,1);
% M= [T S O ST];6

%return


% M= [T S O ST];
T=M(:,1);
S=M(:,2);
O=M(:,3);
ST=M(:,4);
lims=[0 10 %o2
    22 max([33 max(ST)]) %st
    33 35.5 %salt
    0 25]; %temp
figure('color',[1 1 1],'menubar',...
    'none','visible','off','paperposition',[0 0 8.5 11],'units','normalized')

pstd = [100 500 800 1100 round(max(P),-2)+50];
try
    ylim=[0 pstd(find(max(P) < pstd,1,'first'))];
catch
    keyboard
end
if max(P)>max(pstd)
    ylim=[0 max(pstd)];
end
x1=0.07;
wdt=.82;

b=[0.04 0.07 0.10 0.13 0.13];
hght=0.58;

ax(1)=axes('position',[x1  b(1) wdt hght-b(1)],'xlim',lims(1,:),'yColor',[1 1 1],'ylim',ylim*((hght-b(1))/(hght-b(4))));
ax(2)=axes('position',[x1  b(2) wdt hght-b(2)],'xlim',lims(2,:),'yColor',[1 1 1],'ylim',ylim*((hght-b(2))/(hght-b(4))));
ax(3)=axes('position',[x1  b(3) wdt hght-b(3)],'xlim',lims(3,:),'yColor',[1 1 1],'ylim',ylim*((hght-b(3))/(hght-b(4))));
ax(4)=axes('position',[x1  b(4) wdt hght-b(4)],'xlim',lims(4,:),'yColor',[1 1 1],'ylim',ylim);
ax(5)=axes('position',[x1  b(4) wdt hght-b(4)],'xlim',lims(4,:),'yColor',[1 1 1]*0,'ylim',ylim,'box','on','xtick',[]);
set(ax,'color','none','ydir','reverse','nextplot','add');
%axT=axes('position',[0 0 1 1],'xcolor',[1 1 1],'ycolor',[1 1 1],'color','none','xtick',[],'ytick',[]);
plot(ax(1),O,P,'-k','linewidth',2)
plot(ax(2),ST,P,'-','color',[0.5 1 0.5],'linewidth',2)
plot(ax(3),S,P,'-r','linewidth',2)
plot(ax(4),T,P,'-b','linewidth',2)
hyl=ylabel(ax(5),'Profundidad (db)','HorizontalAlignment','left');


text(O(end)*1 +.1 ,max(P),'O','parent',ax(1))
text(ST(end)*1 + .1 ,max(P),'\sigma{_t}','parent',ax(2))
text(S(end)*1 + 0.01 ,max(P),'S','parent',ax(3))
text(T(end)*1 + 0.3,max(P),'T','parent',ax(4))

%set(gcf,'currentAxes',axT)
txt={'T ^{\circ}C','S g kg^-^1','\sigma{_t} kg m^-^3','O{_2} ml l^-^1'};
annotation('textbox',...
    [0.90 0.03 .06 0.1],...
    'FitBoxToText','on',...
    'LineStyle','none',...
    'fontsize',10,...
    'fontname','courier',...
    'string',txt);

%delta=.0120;
%c=-0.038;
%text(wdt+delta,.04-c,'O{_2} ml l^-^1','FontName','courier')
%text(wdt+delta,.07-c,'\sigma{_t} kg m^-^3','FontName','courier')
%text(wdt+delta,.10-c,'S g kg^-^1','FontName','courier')
%text(wdt+delta,.135-c,'T ^{\circ}C','FontName','courier')
%PRES TEMP SALI OXI SIG?T
% 13    14  15  16   18

prof_std=[ 10 20 30 50 75 100 125 150 200 250 300 400 500 600 700 800 900 1000];
prof_std = prof_std(prof_std <= max(P));
if prof_std(1) ~= 1
    prof_std = [1, prof_std];
end
if prof_std(end) ~= max(P)
    prof_std = [prof_std, max(P)];
end


TAB = nan(numel(prof_std),5);
for C=1:4
    I=find(~isnan(M(:,C)));
    if sum(I)>1
        
        TAB(:,C+1)=interp1(P(I),M(I,C),prof_std);
    end
end
TAB(:,1)=prof_std';

%
%set(gcf,'visible','on')
%keyboard
h2= sprintf('% 5d     %06.3f    %06.3f    % 6.2f    %06.3f     \n',TAB');
set(ax,'fontname','courier');
head1 = 'ESTACIÓN LANCE LATITUD   LONGITUD  DDMMAAAA H[GMT] PROFLAN';
head2= ['PRES(db) TEMP(°C) SA(gr/kg) OXI(ml/l) SIGMA-T(kg/m^3)'
    '-----------------------------------------------------'];
h1=sprintf('%s   %03d   %s %s %s   %04d',z{2},k,deg2str(R.lat(j)),deg2str(R.lon(j)),datestr(z{5},'ddmmyyyy hh:MM'),max(P));
%return
textdata1=strvcat(head1,h1);
textdata2=strvcat(head2,h2);

%th2= annotation(gcf,'textbox',[0.1 0.62 1 0.32],...
th2= annotation(gcf,'textbox',[0.0 0.0 1 0.97],...
    'String',textdata2,...
    'FitBoxToText','off',...
    'FontName','courier',...
    'fontsize',9,...
    'edgeColor',[ 1 1 1],...
    'Interpreter','tex',...
    'LineStyle','none',...
    'margin',5,...
    'verticalAlignment','top',...
    'horizontalAlignment','center');
%th1= annotation(gcf,'textbox',[0 0.916 1 0.08],...
th1= annotation(gcf,'textbox',[0 0.8 1 0.2],...
    'String',textdata1,...
    'FitBoxToText','on',...
    'FontName','courier',...
    'fontsize',9,...
    'edgeColor',[ 1 1 1],...
    'LineStyle','none',...
    'margin',0,...
    'verticalAlignment','top',...
    'horizontalAlignment','center');


%imprimir a PDF

set(gcf,'paperPosition',[1 0.0 7 10.4])
set(gcf,'position',[1 0 0.6730 1])
if ~exist('fname','var')||isempty(fname)
    fname=sprintf('%s\\lance_%03d.pdf',R.Crucero,k);
end

dir=fileparts(fname);
if ~exist(dir,'dir')
    mkdir(dir)
end
%return
try
    print ('-dpdf',fname )
catch
    warning(['No se pudo imprimir el archivo ',fname])
end
if exist(fname,'file')
    %open(fname)
end
end
