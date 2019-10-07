function auto_map(ax)

if nargin==0
    ax=axis;
end
set(gca,'XLimMode','manual','yLimMode','manual')
load costa_med_gm.mat
fillseg(xy,[0.7 0.7 0.7],[ 0 0 0]);
load 'Linea de costa gc v2.mat' xy
fillseg(xy,[0.7 0.7 0.7],[ 0 0 0]);
axis(ax)
mapa_ticks(gca,2,2,0.5)