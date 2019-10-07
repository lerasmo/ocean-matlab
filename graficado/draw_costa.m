function [xy,h,x]=draw_costa(lims,res,varargin)
%funcion para graficar la linea de costa
% limites=[xmin xmax ymin ymax]
% xy=drawcosta(limites,res)
%       la resolucion puede ser: 'low','med' o 'high'

%
%
% erasmo feb-2011
% clear all
% close all
% clc
%
% %lims=[  -116.1164 -109.9068   17.4224   19.9968];
% lims =[ -117.7824 -115.4601   29.1788   32.2394]
%lims=[ -121.8616 -119.1675   33.2781   36.0924];
% %lims=[ -117.9339 -116.5708   32.0964   33.8413];
% res='med';

% marzo 2015, se agrega para completar el patch
switch lower(res)
    case 'low'
        load costaLowRes
    case 'med'
        load costaMedRes
    case 'high'
        load costaHighRes
    otherwise
        beep
        disp('la resolucion debe ser: ''low'', ''med'', o ''high''')
        return
end

I=xy(:,1)>=lims(1) & xy(:,1)<=lims(2) & xy(:,2)>=lims(3)& xy(:,2)<=lims(4) | isnan(xy(:,1));

xy=xy(I,:);
I1=find(~isnan(xy(:,1)),1,'first');
I2=find(~isnan(xy(:,1)),1,'last');
xy=xy(I1:I2,:);
I=[0;diff(isnan(xy(:,1)))==1] | ~isnan(xy(:,1));
xy=xy(I,:);
v=xy(:,1);
in = isnan(v);
ir=~in;
d(ir) = [all(diff(xy(~in,:))==0,2);0 ];
d2=[0 d(1:end-1)]';
I=~(in&d2 |d2 | (d2));
xy=xy(I,:);

%[xy n]=reducir_segmentos(xy);
%xy=[xy(find(max(xy(:,2))==xy(:,2),1),1),lims(4);lims(2),lims(4);lims(2),xy(1,2);xy];

%fillseg(xy,[1 1 0],[0 0 0]);
%
%if nargin ==2
%    h=fillseg(xy,[0.3 0.7 0.3],[0 0 0 ]);
%else
%    h=fillseg(xy,varargin{:});
%end
%keyboard
if nargin>2 && ismatrix(varargin{1}) && numel(varargin{1})==4;
    xy=xy*varargin{1};
    varargin=varargin(2:end);
    
end
if nargout~=1
    hold on
    
    %figure
    h=plot(xy(:,1),xy(:,2),varargin{:});
end
%axis(lims)


