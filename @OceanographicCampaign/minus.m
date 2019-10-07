function R=minus(A,B)
%R=minus(A,B)
%resta R=A - B
% la fecha de R es igual a la de A
%

a=numel(A);
b=numel(B);
if ~(a==1 && b==1);
    if a==b
        %no problema
        %iguales, restar
        for k=1:numel(a)
            R(k)=A(k)-B(k);
        end
        
    elseif  a==1 & b>1
        %A=1 B=[....]
        for k=1:b
            R(k)=A-B(k);
        end
    elseif  b==1 & a>1
        %B=1 A=[....]
        for k=1:a
            R(k)=A(k)-B;
        end
    else
        error('no se me ocurre')
    end
    
    return
end

%% empieza la verdadera funcion



R=OceanographicCampaign;

R.Crucero=[A.Crucero,' - ',B.Crucero];
[linest, Ia ,Ib]=intersect(A.linest,B.linest);
A=A.index(Ia);
B=B.index(Ib);

[R.Variables, Va ,Vb]=intersect(A.Variables,B.Variables,'stable');
c=1;
vpa=A.vars_index('presion');
vpb=B.vars_index('presion');
vpr=R.vars_index('presion');
for k=1:numel(Ia)
    
    Pa=A.data{k}(:,vpa);
    Pb=B.data{k}(:,vpb);
    [P, Ipa ,Ipb]=intersect(Pa,Pb);
    dum=A.data{k}(Ipa,Va)-B.data{k}(Ipb,Vb);
    dum(:,vpr)=nan;
    I=all(isnan(dum),2);
    dum(:,vpr)=P;
    dum(I,:)=[];
    if isempty(dum)
        continue
    end
    
    R.data{c,1}=dum;
    R.linest{c,1}=linest{c};
    R.lat(c,1)=A.lat(c);
    R.lon(c,1)=A.lon(c);
    R.fecha(c,1)=A.fecha(c);
    R.linea(c,1)=A.linea(c);
    R.estacion(c,1)=A.estacion(c);
    c=c+1;
end
R.Lances=[1:(c-1)]';
R.nLances=c-1;


















