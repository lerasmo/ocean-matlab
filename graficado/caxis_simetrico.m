function caxis_simetrico(v)

if ~exist('v') || isempty(v)
    caxis auto
    cb=caxis;
    v=max(abs(cb));
end 
caxis([-v v])

end