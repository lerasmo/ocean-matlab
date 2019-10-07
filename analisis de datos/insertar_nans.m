function [Th ,Ph,n,dt]=insertar_nans(T ,P,dt,full)
% function [T ,P,n]=instertar_nans(T ,P,dt);
% Funcion para insertar Nans donde hay huecos (o saltos) en la serie de
% Tiempo T
% dt: opcional, se indica cada cuanto tiempo estan los datos (autodetecta)
% P: opcioanl, inserta los mismos nans en la serie de tiempo P
% % n: opcional: numero de segmentos que se tienen
% 
% MODOS DE USO:
% a)
%     Th=insertar_nans(T)
% Inserta 1 solo nan en cada salto de tiempo del vector T, se autodetecta el dt en base a la moda de la derivada de T: mode(diff(T))
% 
% b)
%  [ Th Ph]=insertar_nans(T,P)
% inserta los mismos nans en la serie P
% 
% c)
%  [ Th Ph n]=insertar_nans(T,P)
% Cuenta el numero de saltos con 'n'
% 
% d)
%  [ Th Ph]=insertar_nans(T,P,dt)
% preestablece el dt del tiempo en lugar de calcularlo
% 
% b)
%  [ Th Ph]=insertar_nans(T,P,[dt],'full')
% Th ahora es un vector de tiempo monotonicamente creciente con dt preestablecido, para calcular automaticamente se puede usar simplemente [] como dt
% Ph incluye nans en todos los huecos por cada tiempo faltante,
% Esta forma es util para usarse en el t_tide




% Luis Erasmo Miranda
% Septiembre-2011
% Luis.Erasmo@gmail.com

% v1.0: Solo funciona con series de tiempo, despues sera con matrices.

T=T(:);
dT=diff(T);
if ~exist('dt','var') ||isempty(dt)
    dt=mode(dT);
end
if exist('P','var')
   % P=P(:);
end


if ~exist('full','var')
    
    I=[0; find(dT>=dt*1.2); numel(T)];
    Th=[];Ph=[];
    for  k=2:numel(I)
        v=I(k-1)+1:I(k);
        Th=[Th;T(v);nan;];
        if exist('P','var')
           % P=P(:);
            % keyboard
            Ph=[Ph;P(v,:);nan(1,size(P,2));];
        end
    end
    n=numel(I)-1;
    
elseif exist('full','var') & strcmp(full,'full')
    
    %pv=fix(nanmin(T)*24);
    %Th=[pv:1:fix(max(T)*24)]/24;
    Th=[T(1):dt:T(end)];
    
    [~,It,Ith]=intersect(fix(T/dt),fix(Th/dt));
    
    %Ph=nan(size(Th));
    %   [C,IA,IB] = INTERSECT(A,B) also returns index vectors IA and IB
    %   such that C = A(IA) and C = B(IB).
    
    
    try
        Ph=nan(size(Th));
        Ph(Ith)=P(It);
    catch
      %  keyboard
    end
else
    error('Erasmo programo algo mal.. ')
  % web('http://www.youtube.com/watch?v=uX_481DATmI&NR=1&feature=fvwp')
end
