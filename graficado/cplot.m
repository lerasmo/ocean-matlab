function cplot(x,y,z,c)

if ~exist('c','var') | isempty(c)
    c=[min(z),max(z)];
end

if c(1)==c(2) 
    %todos los datos son iguales
    c=[c(1)-1 c(1)+1];
end
r=diff(c);
cm=colormap;

z=floor((size(cm,1)-1)*(z-min(z))./r)+1;

for k=1:size(cm,1)
    I=z==k;
    plot(x(I),y(I),'o','MarkerEdgeColor',cm(k,:),'MarkerFaceColor',cm(k,:),'markersize',2)
    hold on
end
caxis(c)



