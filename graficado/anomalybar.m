function [hb hx]=anomalybar(x,y)

if ~exist('y','var')
    y=x;
    x=1:numel(y);
end

I=y>=0;
yr=y;
yb=y;
yr(~I)=nan;
yb(I)=nan;

hb(1)=bar(x,yr,'r');
hold on
hb(2)=bar(x,yb,'b');


I=isnan(y);
if any(I)
    hc=plot(x(I),0,'xk');
end
