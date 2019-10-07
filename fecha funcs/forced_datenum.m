function V=forced_datenum(f,fmt)
if ischar(fmt)
    fmt={fmt};
end



for k=1:numel(f) %solo celdas
    err=false;
    if isnumeric(f{k})
        V(k,1)=f{k}+693960; %formato de excel
        continue
    end
    for j=1:numel(fmt)+1
        if j>numel(fmt)
            err=true;
            break
        end
        try
            V(k,1)=datenum(f{k},fmt{j});
            break
            
        end
        
    end
    if err
        
        error(f{k})
    end
    
end