function S=nc2struct(file,flag,varT,It)
%file: archivo
%flag: valor bandera de los datos

%archivo, bandera nans, variables a cargar, intervalo de tiempo
%file='timesailjplsss.nc';
if ~exist('flag','var')
    flag=[];
end
if ~exist('It','var')
    It=[inf];
end

S=ncinfo(file);
vars={S.Variables.Name};
vars=vars(:);
sz={S.Variables.Size};
if ~exist('varT') | isempty(varT);
    varsi=vars;
    varso=vars;
else
    [C b c]=intersect(vars,varT(:,1));
    r=~ismember(vars,varT(:,1));
    vars(r)
    varso=[varT(c,2);vars(r)];
    varsi=[vars(b);vars(r)];
    
    
end
c=0;
for k=1:numel(vars)
    if vars{k}(1)=='_'
        continue
    end
    c=c+1;
    S.vars{c,1}=vars{k};
    if numel(sz{k})==3
        if ~isempty(It)
            S.(varso{k})=ncread(file,varsi{k},[1 1 1],[inf inf It]);
        end
    else
        S.(varso{k})=ncread(file,varsi{k});
    end
    
    
    if ~isempty(flag)
        S.(varso{k})(S.(varso{k})==flag)=nan;
    end
    
    
end
%S=copyfields(S,info)

%S.vars={S.Variables.Name}';

end
function S=copyfields(S,info)
f=fieldnames(S);
for k=1:nu
    S.(f{k})=info.(f{k});
end
end