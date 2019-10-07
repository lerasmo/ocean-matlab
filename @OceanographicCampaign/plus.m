function R=plus(varargin)


R=OceanographicCampaign; %vacio
R.Crucero=varargin{1}.Crucero;
vars={};
for k=1:numel(varargin)
    vars=[vars;varargin{k}.Variables(:)];
end
vars=unique(vars,'stable');
for k=1:numel(varargin)
    R.Lances=[R.Lances;varargin{k}.Lances(:)];
    R.linest=[R.linest;varargin{k}.linest(:)];
    R.fecha=[R.fecha;varargin{k}.fecha(:)];
    R.lat=[R.lat;varargin{k}.lat(:)];
    R.lon=[R.lon;varargin{k}.lon(:)];
    if ~iscell(varargin{k}.linea(:))
        varargin{k}.linea=num2cell(varargin{k}.linea);
    end
    if ~iscell(varargin{k}.estacion(:))
        varargin{k}.estacion=num2cell(varargin{k}.estacion);
    end
    R.linea=[R.linea;varargin{k}.linea(:)];
    R.estacion=[R.estacion;varargin{k}.estacion(:)];
    
    %R.data=[R.Lances,varargin{k}.Lances(:)];
    [~, Ib,Ic ]=intersect(varargin{k}.Variables,vars);
    
    for j=1:numel(varargin{k}.data)
        dum=nan(size(varargin{k}.data{j},1),numel(vars));
        try
            dum(:,Ic)=varargin{k}.data{j}(:,Ib);
        catch
            keyboard
        end
        R.data=[R.data;{dum}];
    end
    %dum=nan(
    
    
end
R.nLances=numel(R.Lances);
R.Variables=vars;
%keyboard
