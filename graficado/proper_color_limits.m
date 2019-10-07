function proper_color_limits(hc,hf,L)
%hc colorbar
%hf contour
%L levels
V=auto_level(L);
L=[min(V) max(V)];
hc.Limits=L;
hc.Ticks=V;
hf.LevelList=[-inf V inf];
colormap(hf.Parent,jet(numel(V)-1))
caxis(L)


