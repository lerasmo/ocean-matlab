function r=mapa_ticks(ax,dx,dy,mdx,fmt);
if ~exist('ax') || isempty(ax)
    ax=gca;
end
lims=axis;
lm=round(axis);
if ~exist('dx','var') |~exist('dy','var')
    dx=2;
    dy=2;
    
end

%if dx>=1
%    mdx=1;
%    mdy=1;
%else
    
%end
if ~exist('fmt','var')
    fmt='%g';
end

set(gca,'FontName','Book Antiqua');
set(gca,'TickDir','out','XMinorTick','on','YMinorTick','on');
ax.XAxis.MinorTickValues=lm(1):mdx:lm(2);
ax.YAxis.MinorTickValues=lm(3):mdx:lm(4);
ax.XAxis.LineWidth=1;
ax.YAxis.LineWidth=1;
%ax.YAxis.MinorTick.Linewidth
ax.YAxis.MinorTick='on';
ax.XAxis.TickValues=lm(1):dx:lm(2);
ax.YAxis.TickValues=lm(3):dy:lm(4);
ax.XAxis.TickLength=[0.02 3];
ax.YAxis.TickLength=[0.02 3];
ax.YAxis.TickLabelFormat=[fmt,'° N'];
%ax.XAxis.TickLabelFormat=[fmt,' W'];
ax.XTickLabel=sprintf([fmt,'° W\n'],abs(ax.XTick));
ax.FontName='book antiqua';
ax.DataAspectRatio=[1/cosd(mean(ax.YLim)) 1  1 ];
ax.Layer='top';
box on
r=ax.DataAspectRatio;
r=r(2);
axis(lims)