function snapper(base,tipo,)

%tipo='anual';
switch    lower(tipo)
    case 'anual'
        SR=[1,0,0,0,0,0]==1;
        S1=[0,1,1,0,0,0]==1;
        S0=[0,0,0,1,1,1]==1;
    case 'mensual'
        SR=[0,1,0,0,0,0]==1;
        S1=[0,0,1,0,0,0]==1;
        S0=[0,0,0,1,1,1]==1;
    case 'custom'
    otherwise
        error('no definido')
end

XL=get(gca,'XLim');
xl=XL;%backup;
XL=datevec(XL);
XL(:,S1)=1;
XL(:,S0)=0;


vl=[XL(1,SR):XL(2,SR)]';
vl(:,S0)=0;
vl(:,S1)=1;
fix=vl(:,1);

v=datenum(vl);

for k=1:(numel(v)-1)
    set(gca,'XLim',[v(k) v(k+1)])
    
    print('-dpng',[base,'_',num2str(vl(k))],'-r350')
   %return
end





