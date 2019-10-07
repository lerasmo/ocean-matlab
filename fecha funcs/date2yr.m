function y=date2yr(x)

%x=[now now+30]
x=x(:);

v=datevec(x);
v0=v;
v0(:,2:end)=0;
d=x-datenum(v0);
y=v(:,1)+d/365;