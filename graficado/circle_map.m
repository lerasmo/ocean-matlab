function [handle_plot, handle_legend]=circle_map (X,Y,Z,clases,sizes, colores,extra,leyenda)

% circle_map: Dibuja sobre un mapa circulos donde su tamaño representa un
%           intervalo de magnitud. es ideal para el caso de representar
%           biomasa de plancton en una red de estaciones oceanograficas.
%
% USO     : [handle_plot, handle_legend]=circle_map (X,Y,Z,edges,tamaño, colores)
%
%           X Y: vectores con las coordenadas de las estaciones,
%             Z: Valores que se quieren graficar, de igual longitud que X y Y
%         edges: Son lo limites de clases en las cuales se agruparan los datos
%                 ( similar a histc), debe de ser de tamaño n+1
%        tamaño: Vector que contiene el tamaño de los circulos a dibujar, se
%                 aplica como la propiedad MarkerSize
%       colores: Debe ser una matriz de n x 3, conteniendo en cada renglon un
%                 color en la forma RGB (solo valores de 0 a 1)
%   handle_plot: Es un vector que contiene los handles de cada plot, (se hace
%                 un plot por cada clase)
% handle_legend: Devuelve el handle de la leyenda de los circulos.
%
% EJEMPLO:
%
% n=100;
% X=rand(1,n)*100;
% Y=rand(1,n)*100;
% Z=(1:n)*10;
% edges= [0  10  50  100  500  1000];
% size = [ 4   6   8    10   12];
% colores=[ %RGB
%     0.2000    0.6000    1.0000
%     1.0000    0.6000    0.2000
%     0.6000    0.2000    0.5000
%     0.8000    0.4000    0.4000
%     0.8000    0.0000    0.0000    ];
% %    R:red    G:green   B:blue
%
% [hp hl ]=circle_map(X,Y,Z,edges,size,colores)
%
% % para colocar la legenda en la parte inferior derecha
% set(hl,'Location','SouthEast')
%
% Luis Erasmo Miranda Bojorquez
% luis.erasmo@gmail.com
% 29-enero-2009
%
%   See also HISTC


[vx bin] = histc(Z,clases);%
dummie=[];
j=1;

for k=1:numel(sizes)
         hold on
         dummie(k)= plot(nan,nan,'o','MarkerSize',sizes(k),'MarkerFaceColor',colores(k,:),'MarkerEdgeColor','k');
         hold on
    string(k)={[sprintf('%d - %d',ceil(clases(k)),floor(clases(k+1)))]};
end
if exist('leyenda','var')
    string=leyenda;
end
%string= fliplr(string);
% if exist('extra')
%     if strcmp(extra,'NoLegend')
%         handle_leg=nan;
%     else
%         handle_leg = legend(string);
%     end
% else
%     handle_leg = legend(string);
% end
% delete(dummie)

jc=0;
for k=1:numel(clases);
    I=find(bin==k);
    if numel(I) >= 1
        hold on
        jc=jc+1;
        try
        handle_p(jc)= plot(X(I),Y(I),'o','MarkerSize',sizes(k),'MarkerFaceColor',colores(k,:),'MarkerEdgeColor','k');
        catch
            keyboard
        end
        hold on
        %     else
        %         hold on
        %         dummie(j)=m_plot(X(1),Y(1),'o','MarkerSize',sizes(k),'MarkerFaceColor',colores(k,:),'MarkerEdgeColor','k');
        %         hold on
        %         j=j+1;
        %         handle_p(k)=nan;
    end
end

handle_leg = legend(dummie,string);
%delete( dummie)


switch nargout
    case 1
        handle_plot=handle_p;
    case 2
        handle_plot=handle_p;
        handle_legend=handle_leg;
    otherwise
end
