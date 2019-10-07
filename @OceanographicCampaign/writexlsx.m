function writexlsx(R,xfile,vars)
if ~exist('vars','var')
    vars=R.Variables;
    vars=vars';
end
%return
if numel(R)>1
    for k=1:numel(R)
        R(k).writexlsx
    end
    
else
    if ~exist('xfile','var')||isempty(xfile)
        xfile=[R.Crucero,'.xlsx'];
    end
    
    
    %if ~exist(xfile,'file')
    xlswrite(xfile,R.info,'info') %escribir el info
    if exist(xfile)
        [~,prev]=xlsfinfo(xfile);

        
    else
        prev={''}; %no previos
    end
    
    for k=1:R.nLances
         
        if ~ismember(R.linest{k},prev);%las hojas no se sobreescriben
            
            dum=[vars;  num2cell(R.data{k})]; %escribir los datos
            fprintf('|')
            xlswrite(xfile,dum,R.linest{k});
        end
        fprintf('|')
    end
    fprintf('\n')
    %end
end