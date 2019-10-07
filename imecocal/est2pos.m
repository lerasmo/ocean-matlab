function [Lon,Lat]=est2pos(varargin)
% Devuelve la posicion a partir de la linea-estacion
% [Lon Lat]=est2pos()

est_data=load('X:\Respaldo IMECOCAL\IMECOCAL3 31-Marzo-2009\estaciones.dat');
info=load('X:\Respaldo IMECOCAL\IMECOCAL3 31-Marzo-2009\info_lances.txt'); %cargar info para backup

if numel(varargin)==1% Lin.est
    if size(varargin{1},2)==2
        linest=varargin{1}(:,1)+varargin{1}(:,2)/100;
    else
        
        linest=varargin{1};
    end
elseif numel(varargin)==2 %lin,est
    linest=varargin{1}+varargin{2}/100;
end


for k=1:numel(linest);
    [~,Ie,Iv]=intersect(est_data(:,5),linest(k));
    if ~isempty(Ie)
        Lon(k,1)=est_data(Ie,3);
        Lat(k,1)=est_data(Ie,4);
    else
        Ie=find(ismember(info(:,3)+info(:,4)/100,linest(k)));
        
        if ~isempty(Ie)
            Lon(k,1)=nanmean(info(Ie,6));
            Lat(k,1)=nanmean(info(Ie,5));
        else
            
            keyboard
        end
    end
end