function diagrama_ts(F,ax,base)
%dibujar el diagrama TS

if numel(F)~=1
    error('No implementado para multiples cruceros')
end



if ~exist('base','var') %default imecocal
    load capas_st_calcofi_OC.mat %C cruceros de legado de calcofi
    
    load imecocal_data_oc_class.mat;
    [d ,I]=select(R,F.Crucero)
    
    R(I)=[];
    C=[C(:);R(:)];
    
   
elseif strcmp(class(base),'OceanographicCampaign')
    [d ,I]=select(base,F.Crucero)
    base(I)=[];
    
    C=base;
end

 R=F;



ep=fecha2epoca(R);


Ce=fecha2epoca(C);
C=C(Ce==ep);


C=intersect(C,R);

D=R.Lance([],{'temp','salt'}); %datos del crucero en curso
D=cat(1,D{:});
Sa=D(:,2);
Ta=D(:,1);

C=C.Lance([],{'temp','salt'}); %datos  %historicos
C=cat(1,C{:});
S=C(:,2);  %historicos
T=C(:,1); %historicos


crucero=R.Crucero;



%S(:)=nan;



sig = sw_dens0(S,T) - 1000;
siga = sw_dens0(Sa,Ta) - 1000;

if ~exist('ax','var') || isempty(ax)
    lims=[32.8 35.2 0 27];
else
    lims=ax;
end
base_TS(lims)
% [Sm Tm]=meshgrid(lims(1):.01:lims(2),lims(3):0.1:lims(4));
%
% sigm = sw_dens0(Sm,Tm) - 1000;
% sp = rd_spice(Tm,Sm);
% %figure('visible','on','paperposition',[0 0 8.5 11]);
% hold on
% [c h]=contour(Sm,Tm,sigm,[-6:0.5:28.1],':','color',[0.5 0.5 0.5]);
% clabel(c,h,[-6:1:28.1],'labelspacing',250,'color',[0.5 0.5 0.5],'BackgroundColor',[1 1 1],'fontname','times new roman')
% [c h]=contour(Sm,Tm,sp,[-2:0.5:7],'color',[0.5 0.5 0.5]);
% clabel(c,h,[-2:1:7],'labelspacing',150,'color',[0.5 0.5 0.5],'BackgroundColor',[1 1 1],'fontname','times new roman')

plot(S,T,'.','markersize',eps)
plot(Sa,Ta,'.r','markersize',2)
box on
ds=0.1;
Tmean=[];Smean=[];
Tdesv=[];Sdesv=[];
Tamean=[];Samean=[];
Tadesv=[];Sadesv=[];
for s = 19:ds:29
    I=find(sig>=s & sig<(s+ds));
    if numel(I)>30
        
        Tmean=[Tmean;mean(T(I))];
        Smean=[Smean;mean(S(I))];
        Tdesv=[Tdesv;std(T(I))];
        Sdesv=[Sdesv;std(S(I))];
        
    end
    I=find(siga>=s & siga<(s+ds));
    if numel(I)>24
        
        Tamean=[Tamean;mean(Ta(I))];
        Samean=[Samean;mean(Sa(I))];
        Tadesv=[Tadesv;std(Ta(I))];
        Sadesv=[Sadesv;std(Sa(I))];
        
    end
    
end

h(1)=plot(Smean,Tmean,'color',[0 0 0.8],'linewidth',1.5);
h(2)=plot(Smean+Sdesv*2,Tmean+Tdesv,'--','color',[0 0 0.8],'linewidth',1.5);
plot(Smean-Sdesv*2,Tmean-Tdesv,'--','color',[0 0 0.8],'linewidth',1.5);
h(3)=plot(Samean,Tamean,'linewidth',2,'color',[0.8 0 0 ]);
h(4)=plot(Samean+Sadesv*2,Tamean+Tadesv,'--','color',[0.8 0 0],'linewidth',1.5);
plot(Samean-Sadesv*2,Tamean-Tadesv,'--','color',[0.8 0 0],'linewidth',1.5);
uistack(h(3),'top');

axis(lims)
xlabel('Salinidad gr/kg ','fontsize',32,'fontname','times new roman')
ylabel('Temperatura °C','fontsize',32,'fontname','times new roman')
title(sprintf('Crucero %s',crucero),'fontsize',38,'fontname','times new roman')
%masas_agua
hl=legend(h,'Media climatologica','Climatologia ±2\sigma',...
    sprintf('Media crucero %s',crucero),sprintf('Crucero %s ±2\\sigma',crucero),'location','southwest');
%hl=legend(h([3,4]),    sprintf('Media crucero %0.4d',crucero),sprintf('Crucero %0.4d ±2\\sigma',crucero),'location','southwest');

set(hl,'fontname','times new roman','fontsize',16);

set(gcf,'PaperSize',[ 10 10.35],'PaperPosition',[0 0 10 10.35])
axis(lims)
%print('-depsc2',sprintf('TS%04d.eps',crucero))
%str=sprintf('magick convert -density 350 TS%04d.eps TS%04d.png',crucero,crucero);
%dos(str);

%copyfile(sprintf('TS%04d.png',crucero),sprintf('..\\..\\procesado D\\reporte\\%04d\\TS%04d - %s.png',crucero,crucero,temporada))

%print('-dpng',sprintf('TS%04d.png',crucero),'-r450')
%print('-dpng',sprintf('D:\\IMECOCAL\\reporte\\%04d\\TS%04d - %s.png',crucero,crucero,temporada),'-r450')

%close all






