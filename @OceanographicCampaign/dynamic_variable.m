function  R=dynamic_variable(R,vsp)


%% array de entradas
if numel(R)>1
    for k=1:numel(R)
        R(k)=dynamic_variable(R(k),vsp);
    end
    return
end

switch lower(vsp)
    case 'sigma'
        D=R.Lance([],{'salinidad','temperatura','presion'});
        for k=1:R.nLances
            
            dum=sw_dens(D{k}(:,1),D{k}(:,2),D{k}(:,3))-1000;
            R.data{k}=[R.data{k},dum];
        end
        R.Variables=[R.Variables;'Sigma'];
    otherwise
        error(['definir ',vsp])
end
  