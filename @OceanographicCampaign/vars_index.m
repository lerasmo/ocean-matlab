function vind=vars_index(obj,vars)
if numel(obj)>1
    error('Funcion definida para un solo crucero')
end
vars=lower(vars);
syn={
    {'pressure','pres','presion','depth','profundidad','prof','prdM'}
    {'salt','salinity','salinidad','sal','sal00'}
    {'temp','temperature','temperatura','tv290C'}
    {'gpan','adin'}
    {'oxigeno','sbeox0ML/L'}
    {'densidad','sigma','\sigma-t','sigma-é00','sigma-é11'}
    {'Fluorescencia','Chl-a','flSP'}
    };
%syn=lower(syn);
switch class(vars)
    case 'char' %una sola
        vind=vars_index(obj,{vars});
    case 'cell' %varias
        
        
        %if any(~I)
        %warning(['No se encontraron las variables: '])
        %    disp(vars(~I));
        %vars=vars(~I);
        %end
        
        
       % [~, ~, vind]=intersect(lower(vars),lower(obj.Variables),'stable');
       vind=[];
       for k=1:numel(vars)
           [~, b]=ismember(vars{k},lower(obj.Variables));
           if b~=0
               vind=[vind;b];
           else %por sinonimos
               %ubicar el grupo
               g=1;
               while g
                   I=strcmp(lower(syn{g}),vars{k});
                   if any(I) %encontrado
                       dum=syn{g};
                       dum=[dum(I),dum(~I)];
                       %comparar con las variables de la BD
                       %if g==6
                       %    obj=dynamic_variable(obj,'sigma');
                       %end
                       [~,b,~]=intersect(lower(obj.Variables),lower(dum'),'stable');
                       if isempty(b)
                            warning(['No se encontro la variable ',vars{k}])
                            vind=[vind;-1];
                            %return
                       else
                           vind=[vind;b(1)];
                           g=0;
                       end
                   else
                       g=g+1;
                   end
                   if g>numel(syn)
                      % error(['No se encontro la variable ',vars{k}])
                      vind=[vind;-1];
                      g=0;
                   end
                       
                   
               end
           end
       end
        if numel(vind)<numel(vars) %se devolvieron menos de las solicitadas
            %keyboard
        end
    case 'double' %
        I=vars<=numel(obj.Variables);
        if any(~I)
            warning('Las variables a extraer exeden las disponibles')
        end
        vind=vars(I);
    otherwise
        disp(vars)
        error('No se pueden extraer las variables')
end


end