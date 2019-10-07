function etiquetas_fecha(dm,ax,eje)
% etiquetas_fecha()
%   Sin argumentos, Coloca ticks en cada dia primero de mes en el rango del
%   axis presente.
%   etiquetas_fecha(n), coloca un tick cada n meses
%keyboard
if ~exist('dm','var') || isempty(dm)
    dm=1;
end
if ~exist('ax','var') || isempty(ax)
    ax=gca;
end
if ~exist('eje','var') || isempty(eje)
    eje='xlim';
    ej='x';
else
    switch lower(eje)
        case {'xlim','x'}
            eje='xlim';
            ej='x';
        case {'ylim','y'}
            eje='ylim';
            ej='y';
        otherwise
            error('eje')
    end
end
L=get(ax(1),eje);
L  =datevec(L);
if L(6) ~=1
    L(4)=L(4)+1;
end


L(:,3)=1;

set(ax,eje,datenum(L)');
ysap=L(2,1)-L(1,1);
m=L(1,2):dm:(ysap*12+L(2,2));
% c=1;
% ny=L(2)-L(1);
% if ny >0
%     m=[L(3):dm:12,repmat(1:12,1,ny-1) ,1:dm:L(4)];
%     y=[(L(3):dm:12)*0+L(1) reshape( repmat(L(1)+1:L(2)-1,12,1) ,1,[]) (1:dm:L(4))*0+L(2)] ;
% else
%     m=L(3):dm:L(4);
%     y=m*0+L(1);
% end



ticks =datenum(L(1,1),m,1,0,0,0);
set(ax,[upper(ej),'Tick'],ticks);
%xlabel(ax,'Fecha')
datetick(ax,ej,'mmm-yy','keeplimits','keepticks')
