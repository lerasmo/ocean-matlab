function [vc hb]=auto_level(Z,an)

cax=[min(Z(:)),max(Z(:))];
f=10^round(log10(diff(cax)/10)); % tomala pawh pawh!!

cax=[floor(cax(1)/f),ceil(cax(2)/f)]*f;
vc=cax(1):f:cax(2);
if numel(vc)>=16
    vc=cax(1):f*2:cax(2);
    f=f*2;
end
if numel(vc)<8
    vc=cax(1):f/2:cax(2);
    f=f/2;
end
vc=round(vc./f,1)*f;
if exist('an','var') && ~isempty(an)
    
    if any(vc==0)
        L=max(abs(vc))+f/2;
    else
        L=max(abs(vc));
    end
    
    vc=-L:f:L;
    if numel(vc)>16
        %vc=-L:2*f:L;
        vc=sort([[f:2*f:L],-[f:2*f:L]]);
    end
    hb=0.5*(vc(1:end-1)+vc(2:end));
    
    
    
    
end