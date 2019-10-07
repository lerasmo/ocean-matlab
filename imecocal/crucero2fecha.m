function crucero2fecha(cru)
ms=[12 1 2
    3 4 5
    6 7 8 
    9 10 11];
str={'Inv','Pri','Ver','Oto',};

qt=[15:365/4:365]/365;
%crucero, pronmedio, nmuestras, temporada,fecha(yr)
for k=1:numel(cru)
    I=find(T(:,9)==cru(k));
    P(k,2)=nanmean(T(I,6));
    P(k,3)=sum(~isnan(T(I,6)));
    st=find(any(ms==mode(T(I,4)),2));
    yr=mode(T(I,3));
    P(k,4)=st;
    P(k,5)=yr+qt(st);
    
    
    %return
end