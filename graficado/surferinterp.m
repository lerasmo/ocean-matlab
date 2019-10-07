function [ZI]=surferinterp(x,y,z,XI,YI,r)
%suferinterp: interpola usando el metodo krigding, hace una llamada al programa de surfer para interpolar
% ZI=surferinterp(x,y,z,XI,YI)
% Luis Erasmo Miranda Bojorquez
% febrero 2009
% luis.erasmo@gmail.com

%scripter =  '"G:\program files\Golden Software\Surfer8\Scripter\Scripter.exe"';
%scripter=ruta_scripter;

B=[x(:) y(:) z(:)];
I=all(~isnan(B),2);
B=B(I,:)';

base=['E',dec2hex(randi(500000000))];
comando = ['start /B /wait scripter -x ','"',pwd,'\',base,'.bas"'''];

fid =fopen([base,'.dat'],'wt');
disp('Guardando datos')
fprintf(fid,'%03.5f \t %3.5f \t %3.5f \n',B);
fclose(fid);
% fclose all;

fid =fopen([base,'.bas'],'wt');
fprintf(fid,'%s\n','Sub Main');
fprintf(fid,'%s\n','Dim SurferApp As Object');
fprintf(fid,'%s\n','Dim InFile, GridFile, BaseName As String');

fprintf(fid,'%s\n','Dim VarioComponent As Object');
fprintf(fid,'%s\n','Set SurferApp = CreateObject("Surfer.Application")');
fprintf(fid,'Set VarioComponent = SurferApp.NewVarioComponent(srfVarLinear, AnisotropyRatio:=%f, AnisotropyAngle:=0)\n',r);

fprintf(fid,'%s\n',['SurferApp.DefaultFilePath = "',pwd,'"']);
fprintf(fid,'%s\n','SurferApp.Visible = False ');
fprintf(fid,'%s\n',['InFile ="',base,'.dat"']);
fprintf(fid,['%s\n','GridFile ="',base,'.nc"']);
%OutFmt:srfGridFmtRaw
%, BlankOutsideHull:=1
fprintf(fid,'%s','SurferApp.GridData3 (DataFile:=InFile, Algorithm:=srfKriging,OutFmt:=18');
fprintf(fid,',DupMethod:=srfDupNone, ShowReport:=false, OutGrid:=GridFile, KrigVariogram:=VarioComponent, xmin:=%f,xmax:=%f',[min(XI(:)),max(XI(:))]);
fprintf(fid,', ymin:=%f, ymax:=%f, numcols:=%d,numrows:=%d )\n',[min(YI(:)),max(YI(:)),size(XI,2),size(XI,1)]);
fprintf(fid,'%s\n','End Sub');
fclose(fid);
fclose all;

%!type temp.bas
%error('1')
%disp(comando)
%return
dos(comando);

%data=load('temp.grd');
%x=hdfread([base,'.grd'],'-Dim[2]');
%y=hdfread([base,'.grd'],'-Dim[2]');
ZI=hdfread([base,'.grd'],'DataSet');
nc=hdfinfo([base,'.grd']);
fv=nc.SDS.Attributes.Value;
%ZI(ZI==fv)=nan;
%plot(XI,YI ,'.k')
%plot(x,y,'.r')



%fid=fopen([base,'.grd']);
%D=fread(fid,inf,'double');
%ZI=reshape(D,fliplr(size(XI)))';
% error('b')
fclose all;
%delete([base,'.bas'])
%delete([base,'.grd.gsr2'])
%delete([base,'.grd'])
%delete([base,'.dat'])
str=['del ',base,'*.*'];
dos(str);
%ZI=reshape(data(:,3),fliplr(size(XI)))';
%ZI(isnan(XI) | isnan(YI)) = nan;
ZI=flipud(ZI);
%ZI=fliplr(ZI);


