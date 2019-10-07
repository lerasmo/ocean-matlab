function Zq=suavizado_pesado(Z,W,Mt)

[m n p]=size(Z);
Zq=Z;
for k=1:m
    
    
    for j=1:n
        if ~Mt(k,j) %mascara de interpolacion, solo afectar tierra?
            continue
        end
        Iy=j-1:j+1;
        Ix=k-1:k+1;
        Ic=zeros(3);Ic(5)=1;%eficiente?
        if k==1
            Ix=Ix(2:3);
            Ic=Ic(2:3,:);
            
        end
        if k==m
            Ix=Ix(1:2);
            Ic=Ic(1:2,:);
        end
        
        if j==1
            Iy=Iy(2:3);
            Ic=Ic(:,2:3);
        end
        if j==n
            Iy=Iy(1:2);
            Ic=Ic(:,1:2);
        end
        %clc
        
        P=W(Ix,Iy)+Ic;
        P=P-min(P(:));
        P=P./sum(P(:));
        if all(all(P==Ic))
            continue
        end
        for z=1:p
            Zq(k,j,z)=sum(sum(Z(Ix,Iy,z).*P));
        end
        
        
        
    end
end


%%