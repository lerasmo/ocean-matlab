function R=rellenar_datos_superficie(R);
% clear all
% close all
% clc
% 
% %load temp.mat	
% load('c:\work\calcofi\calcofi_datos_subida_v28marzo17.mat','R')

for c=1:numel(R)
    %disp(R(c).Crucero)
    for k=1:numel(R(c).data)
        
        p=R(c).data{k}(:,1);
        I=p>=1;
        R(c).data{k}=R(c).data{k}(I,:);
        p=p(I);
        
        [p ,I]=sort(p);
        R(c).data{k}=R(c).data{k}(I,:);%ordenar los datos
         %R(c).revision_manualV3
        if numel(p)/1.2 < max(p)
            [p I]=unique(p);
             R(c).data{k}=R(c).data{k}(I,:);%quitar profunidades repetidas
             P=1:max(p);
             dum=nan(numel(P),numel(R(c).Variables));
             dum(:,1)=P;
             try
                 dum(p,2:end)=R(c).data{k}(:,2:end);
             catch
                 keyboard
             end
             R(c).data{k}=dum;
             p=P;
        end
        
        %return
        for v=2:numel(R(c).Variables)
            t=R(c).data{k}(:,v);
            t(t==-99)=nan;
            In=isnan(t);
            
           % if all(~In(1:10))%no hay nans en los primeros 10m
           %     continue
           % end
            if sum(In)*4>numel(t)
                continue %es de botella
            end
            
            if sum(In)>0 & ~all(In) %que haya al menos un nan, pero que no todos sean nan
                r=find(~In,1);
                %disp(R(c).Variables(v))
                %disp(t(1:10))
                %disp(t(r))
                t(1:r-1)=t(r);
                
            end
            In=isnan(t);
            if any(In) & numel(p)/1.2 < max(p)%en caso de haber huecos, rellenarlos
                
                t=interp1(p(~In),t(~In),p);%#ok<SAGROW>
                %plot(t2,-p,'b')
                %hold on
                %plot(t2(~In),-p(~In),'+r')
                %pause
                %clf
            end
             R(c).data{k}(:,v)=t;
        end
         R(c).data{k}(:,1)=p;
         if any(isnan(R(c).data{k}(1,:)))
          %   keyboard
         end
         
    end
end

%save('c:\work\calcofi\calcofi_datos_subida_v28marzo17.mat','R')