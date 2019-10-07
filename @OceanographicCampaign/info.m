function Tout=info(obj)
T={};

if numel(obj)>1
    for k=1:numel(obj)
        dum=info(obj(k));
        T=[T;dum];
    end
else
    
    if ~iscell(obj.Lances)
        T(:,1)=num2cell(obj.Lances(:));
    else
        T(:,1)=(obj.Lances(:));
    end
    
    T(:,2)=mat2cell(datestr(obj.fecha,'dd-mmm-YYYY HH:MM'),ones(obj.nLances,1),17);
    if ~iscell(obj.linest)
        T(:,3)=num2cell(obj.linest);
    else
        T(:,3)=(obj.linest);
    end
    if ~iscell(obj.linea)
        T(:,4)=num2cell(obj.linea);
    else
        
        T(:,4)=(obj.linea);
    end
    if ~iscell(obj.estacion)
        T(:,5)=num2cell(obj.estacion);
    else
        T(:,5)=(obj.estacion);
    end
    
    %obj.linea(:)
    %obj.estacion(:),
    T(:,[6 7])=num2cell([obj.lon(:),obj.lat(:)]);
    
    head={[obj.Crucero,': Lance'],'Fecha','Linea.Estacion','Linea','Estacion','Longitud','Latitud'};
    T=[head;T];
    
end
if nargout==0;
    disp(T);
else
    Tout=T;
end

end