function s=fecha2fixcr(f)

qt=[15:365/4:365]/365;
qt=qt(:);
fe=fecha2epoca(f);
s=floor(date2yr(f))+qt(fe);
[~,mn]=datevec(f);
I=find(fe(:)==1 & mn(:)==12);
s(I)=s(I)+1;