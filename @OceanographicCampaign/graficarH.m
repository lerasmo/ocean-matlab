function [gax, hc, mrot, hl, cf, hf, vc, ct,xy,px]=graficarH(R,vs,dp,ax2,pm)
% vs: variables
% dp: profunidad
% gax: axes
% hf: contours
% hc: colorbar
%lims=[-120 -108 22 38]; %%%%%%%%%%%
%vc=[32:0.1:34];%%%%%%%%%

% [gax hc mrot hl cf hf vc ct]=R.graficarH(vs,dp,ax2,pm)
if ~exist('pm','var') || isempty(pm)
    pm=-1;
end


D=R.Lance([],{'Presion'}); %errores sinonimos
if all(cellfun(@isempty,D))
    disp('Sin datos')
    return
end
md=cellfun(@max,D,'UniformOutput',true);
I=find(md>=pm);
if iscell(vs)
    vs=vs{1};
    
end
if  ~strcmp(lower(vs),'mld')
    ct=R.Capa(dp,R.Lances(I),{vs});
else
    ct=R.Capa({'mld'});
end
if ~exist('ax2','var') || isempty(pm) || isempty(ax2)
    %   ax2=[min(ct(:,1:2)),max(ct(:,1:2))];
    %   ax2=round(ax2([1 3 2 4]),1)
    ax2=[   -75  -71   70  78.5];
end

I=isnan(ct(:,3));
ct2=ct;
ct2(I,:)=[];
if ~isfield(R.userdata,'contorno');
    R.userdata.contorno=[];
end
if isempty(ct2)
    warning('Sin datos para graficar')
    ct2=[nan(1,3)];
end
    
  
[gax, hc, mrot, hl, cf, hf, vc,xy,px]=graficado_general(ct2(:,end),ct2(:,1:2),ax2,'',R.userdata.contorno);

%hc: colorbar
%colormap(jet);
ct=[R.linest,num2cell(ct)];
