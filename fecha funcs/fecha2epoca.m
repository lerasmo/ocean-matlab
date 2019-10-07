function [e ep]=fecha2epoca(d)


%d=datenum({'14 jan 2017','14 ago 2017','14 sep 2017','14 jan 2017','14 ago 2017','14 sep 2017'});
d=d(:);
v={'Invierno','Primavera','Verano','Otoño'};

M=[12 1 2 %Dic
    3 4 5 %Mar
    6 7 8 %Jun
    9 10 11]; %Sep
[~,m]=datevec(d);
for k=1:4
    I=any(M(k,1)==m | M(k,2)==m | M(k,3)==m,2 );
    e(I,:)=k;
    ep(I,:)=v(k);
end
