function hc=cb_units(hc,str,k)

if nargin==1
    str=hc;
    if strcmp(get(gco,'Type'),'colorbar')
        hc=gco;
    else
        hc=colorbar;
    end
    k=false;
else
    if ~isempty(hc) &&  strcmp(hc.Type,'colorbar')
        %hc=dum;
        %ok
    else
        hc=colorbar;
    end
    if ~exist('k')||isempty(k)
        k=true;
    end
    
end
%hc=findobj('Type','colorbar');
%if isempty(hc)
%    hc=colorbar;
%elseif numel(hc>1)
%    hc=hc(1);
%end
if k
    
   
    L=hc.Limits;
    hc.TicksMode='auto';
    hc.TickLabelsMode='auto';
    hc.Limits=L;
    caxis(L)
end
L=hc.TickLabels;
L{end}=[L{end},' ',str];
hc.TickLabels=L;
hc.TicksMode='manual';

