function  [A ,M]=anomaly(R,n)
%se calcula la anomalia
%default, climatologica

if ~exist('n','var') ||isempty(n)
    n=6;
end


for k=1:numel(R)
    f(k)=nanmean(R(k).fecha);
end


Fx=fecha2fixcr(f);
E=fecha2epoca(yr2date(Fx));
v={'Invierno','Primavera','Verano','Otoño'};
for k=1:4
    I=E==k;
    M(k)=mean(R(I),'cruceros',6);
    M(k).Crucero=['Climatologia ',v{k}];
    A(I)=R(I)-M(k);
end

