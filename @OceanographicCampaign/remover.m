function out=remover(R,a,b)
%ejemplo:
% crucero = 1710;
%
% Ir=R.linea == 117 | R.linea==113;
% B=remover(R,'est',find(Ir))
if numel(R)>1 %paso a paso
    for k=1:numel(R)
        out(k)=R(k).remover(a,b);
    end
    return
end

switch    nargin
    case 1 %nulo
        out=R;
        return
    case 2 %autodetectar
        
    case 3 %tipo valor
        if ~isnumeric(b)
           b=R.vars_index(b);
           if isempty(b)
               warning(['variable ',b,' no encontrada. Sin cambios'])
               out=R;
               return
           end
        end
        switch a
            case 'vars'
                R.Variables(b)=[];
                
                for k=1:numel(R.data)
                    R.data{k}(:,b)=[];
                    
                    % return
                end
                out=R;
                %keyboard
            case 'est'
                R.Lances(b)=[];
                R.linest(b)=[];
                R.fecha(b)=[];
                
                R.lat(b)=[];
                R.lon(b)=[];
                R.linea(b)=[];
                R.estacion(b)=[];
                R.data(b)=[];
                R.nLances=numel(R.Lances);
                out=R;
            otherwise
                error('vars y est')
                
        end
        
end

