function hc=splitline(h,sz);
%divide una linea en varias de una distancia determinada
%borra la linea madre

if ~exist('sz','var') || isempty(sz)
    sz=diff(get(gca,'Xlim'))/3.5;
end

dr=[0 cumsum(sqrt(diff(h.XData).^2 + diff(h.YData).^2))];
S=floor(dr/sz);
if all(S(1)==S) %no split
    hc=h; return
end
%su=unique(S);
S=[1 find(diff(S)),numel(h.XData)];
d=diff(dr(S));
%(d)
%hc=nan(1,numel(su));
for k=1:numel(S)-1
   if d(k)<0.5*sz
       continue
   end
    I=S(k):S(k+1);
    
   
    hc(k)=copyobj(h,h.Parent);
    hc(k).XData=hc(k).XData(I);
    hc(k).YData=hc(k).YData(I);
    %hc(k).Color=rand(1,3)
    
end

delete(h)