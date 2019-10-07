function [m r c cnt]=ajuste_1d(x,n)
% se ajustan los datos (x) a n multiples promedios (m)
% se calculan ademas el rms (r) y la matriz de contingencia(c)
%  ejemplo: Se requiere ajustar el tamaño del pantalon a un grupo de
%  estudiantes, se les tomo la medida de la cadera a todos (x),
% los pantalones se ajustaron a 3 tallas diferentes (n=3).
% se buscan las 3 tallas que mejor ajusten (que m-xi sea minimo)
%
%



x=sort(x(:));
L=round(linspace(0,numel(x),n+1));

for k=1:n
    I=L(k)+1:L(k+1);
    M1(k)=mean(x(I));
    
end


c1=abs(x-M1)==min(abs(x-M1),[],2);
cnt=0;
while 1
   
    m=ajuste(x,c1);
    m(1)=0; %forzar el primero a cero
    m=round(m/5)*5; %forzar a multiplos de 5
    
    cnt=cnt+1;
    c2=abs(x-m)==min(abs(x-m),[],2);
    if all(c2(:)==c1(:))
        %ok
        r=rmsn(x,m);
        c=c2;
        return
    end
    c1=c2;
    if cnt>100 
        keyboard
    end
   
    


end



end

function m=ajuste (x,c)
for k=1:size(c,2)
    v=x(c(:,k));
    m(k)=nanmean(v);
end


end
