function find_in_files(str,dr)
%find_in_files(str,dir)
 clc
if ~exist('str') || isempty(str)
    return
end
if ~exist('dr') || isempty(dr)
    dr=pwd;
end

disp('cargando .m')
f=cargar_dir(dr,'.m');

%disp('<a href="matlab:opentoline(''test.m'',5)">go</a>')

disp(['buscando en ',num2str(numel(f)),' archivos..'])
for k=1:numel(f)
    try
    d=cargar_txt2(f{k},'windows-1252');
    catch
        disp(['Error cargando',f{k}])
        continue
    end
    
    
    %disp(f{k})
    r=strfind(lower(d),lower(str));
    I=~cellfun(@isempty,r);
    if any(I)
        fprintf('\n')
        disp([f{k}])
        I=find(I);
        for e=1:numel(I)
            %s=();
            %s=strrep(s,'<html>','');
            %s=strrep(s,'</html>','');
            
            disp(['<a href="matlab:opentoline(''',f{k},''',',num2str(I(e)),')">',strtrim(d{I(e)}),'</a>'])
        end
        disp('')
        %return
        %edit(f{k})
    end
    
    %return
end