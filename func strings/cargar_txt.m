function M=cargar_txt(file,mem,flag)
% carga un archivo txt
% Erasmo Miranda Bojorquez 2009
% luis.erasmo@gmail.com
%file='data\T1_1183545_-_UABC_14246792.csv';

%el cambio de linea es [13 10]
fid =fopen(file);
if fid==-1
    error(['No se puede abrir el archivo ',pwd,'\',file])
end
M=cell(1);
k=0;
if ~exist('mem','var')
    mem=2000;
end
while 1
    lin=fgetl(fid);
    if lin==-1
        M=M(1:k);
        break
    else
        
        k=k+1;
        M(k,1)={lin};        
        
    end
    if ~mod(k,mem )
        
        M(end+1:end+mem,:)={''};
%          clc
%         disp(k)
    end
    
    
end
fclose (fid);
if ~exist('flag','var')
M=char(M);
else
    
end

