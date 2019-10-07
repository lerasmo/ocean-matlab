function [s l h]=base_TS(lims)
%se grafica la linea base y las masas de agua


if ~exist('lims','var')| isempty(lims)
    lims=[32.8 35.2 0 27];
end

[Sm Tm]=meshgrid(lims(1):.01:lims(2),lims(3):0.1:lims(4));

sigm = sw_dens0(Sm,Tm) - 1000;
sp = rd_spice(Tm,Sm);
%figure('visible','on','paperposition',[0 0 8.5 11]);
hold on
[c h(1)]=contour(Sm,Tm,sigm,[-6:0.5:28.1],':','color',[0.5 0.5 0.5]);
clabel(c,h(1),[-6:1:28.1],'labelspacing',250,'color',[0.5 0.5 0.5],'BackgroundColor',[1 1 1],'fontname','times new roman')
[c h(2)]=contour(Sm,Tm,sp,[-2:0.5:7],'color',[0.5 0.5 0.5]);
clabel(c,h(2),[-2:1:7],'labelspacing',150,'color',[0.5 0.5 0.5],'BackgroundColor',[1 1 1],'fontname','times new roman')



L=[8.0	21	33.2	33.8
25	30	33	34
20	28	34.4	35
8	15	34.3	35
22	22	33.8	33.8];

lab={'SAW' 'TSW' 'StSW' 'ESsW' 'TrW'};

vx=[1 2 2 1 1];
vy=[3 3 4 4 3];
for k=1:numel(lab)
    x=L(k,:);
    s(k,1)= plot(x(vy),x(vx),'-k');
    l(k,1)=text(x(3),x(1),lab{k},'VerticalAlignment','bottom');
end
axis(lims)