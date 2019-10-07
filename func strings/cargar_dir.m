function b=cargar_dir(base,ext)
if isempty(base);
    base=pwd;
end
fs=filesep;

if ~exist(base,'dir')
    if exist(base) & ~isdir(base)
        error([base,' No es un directorio valido'])
    end
    error(['No se encontro: ',base])
end
if isempty(base)
    base=pwd;
end
%str=['dir "',base,'" /S /B'];
%[~,b]=dos(str);
%b=sort(dechunkstr(b));
if base(end)~=fs
    base=[base,fs];
end

str=[base,'**',fs,'*',ext];
d=dir(str)';
if isempty(d)
    b={};
    warning(['Sin archivos ',ext,' en ',base])
end
f={d.folder}';
n={d.name}';

for k=1:numel(n)
    b{k,1}=[f{k},fs,n{k}];
end