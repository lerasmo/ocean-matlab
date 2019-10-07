function [S enc]=cargar_txt2(file,enc);

%file='X:\Trabajos con UTCAM\base de datos\RedMonitoreo\DATOS\ANCLAJES\CNK27\RECUPERACIONES\PER-T3500-CNK27\MCTS\PER-T3500-MCT-NS7949-Z119-INS24-REC27_RAW\PER-T3500-MCT-NS7949-L.cnv';
if ~exist(file,'file')
    error(['Archivo no existe: ',file])
end

if ~exist('enc','var') || isempty(enc)
   
   %enc='auto';
   %windows-1252
   fid =fopen(file,'rb','n','utf-8');
   if fid ==-1
       error('Error al abrir el archivo')
   end
       
       
   B=fread(fid,'uint8');
   if max(B)>=250
       enc='windows-1252';
   else
       enc='utf-8';
   end
   %disp('max val')
   %max(B)
   
   fclose(fid);
    
end
fid =fopen(file,'r','n',enc);
%fid =fopen(file,'rb','n');

if fid==-1
    error(['No se puede abrir el archivo ',file])
end
% cambio de linea == 10;
[M cnt]=fread(fid,'char');

fclose(fid);
if cnt>1
    
S=dechunkstr(M);
else
    S={''};
end


