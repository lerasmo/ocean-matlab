function h=vline(x)
%dibuja una linea vertical en x

y=[];
v=[];
r=get(gca,'YLim');
r=r(:);
for k=1:numel(x)
    v=[v;nan;x(k);x(k)];
    y=[y;nan;r];
end

h=plot(v,y);;