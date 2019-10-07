function text_write(file,data)
%sirve para guardar text
f=fopen(file,'w+','n','windows-1252');
if f==-1
    error('no se abre')
end

if iscell(data)
    c=true;
    n=numel(data);
elseif isstr(data)
    c=false;
    n=size(data,2);
elseif isnumeric(data)
    error(' solo texto')
end

%keyboard
try
    
    for k=1:size(data,1)
        fmt=[];
        for j=1:size(data,2)
           if isnumeric(data{k,j})
               fmt=[fmt,'%4.4f'];
           else
               fmt=[fmt,'%s'];
           end
           if j<size(data,2)
               fmt=[fmt,'\t'];
           else
                fmt=[fmt,'\r\n'];
           end
        end
        
        fprintf(f,fmt,data{k,:});
    end
catch
    keyboard
end
% for k=1:n
%     if c
%         fprintf(f,'%s\r\n',data{k});
%     else
%         fprintf(f,'%s\r\n',data(k,:));
%     end
% end
fclose all;
