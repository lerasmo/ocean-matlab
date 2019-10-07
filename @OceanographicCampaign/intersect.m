function  [A,B]=intersect(A,B)
% [Af Bf]=intersect(A,B)
%intersecta A y B, de tal manera que Af contiene los lances de A que
%tambien estan en B y Bf contienen los lances de B que tambien estan en A

a=numel(A);
b=numel(B);
if ~(a==1 && b==1);
    if a==b
        %no problema
        %iguales, comparar
        for k=1:a
            [A(k),B(k)]=intersect(A(k),B(k));
        end
        
    elseif  a==1 & b>1
        %A=1 B=[....]
        for k=1:b
            %R(k)=A-B(k);
            [B(k),A]=intersect(B(k),A);
            %error('No implementado')
        end
    elseif  b==1 & a>1
        %B=1 A=[....]
        for k=1:a
            %R(k)=A(k)-B;
            [~,A(k)]=intersect(B,A(k));
            %error('No implementado')
        end
    else
        error('no se me ocurre')
    end
    
    return
end

[~,Ia,Ib]=intersect(A.linest,B.linest);
A=A.index(Ia);
B=B.index(Ib);
