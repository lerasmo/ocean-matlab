function n=str2deg(s)


b=s;

s=lower(s);
s=strrep(s,'°',' ');
s=strrep(s,'''',' ');
p=1;
if any(s=='w')
    p=-1;
    
end
if any(s=='s')
    p=-1;
    
end
s=strrep(s,'n',' ');
s=strrep(s,'e',' ');
s=strrep(s,'w',' ');
s=strrep(s,'s',' ');

n=str2num(s);
if isempty(n)
    error(['No se puede convertir a numero: ',b])
end

f=[1 1/60 1/60/60];
n(numel(n)+1:3)=0;
n=p*n*f';
%disp([b,' -> ',num2str(n),' -> ',deg2str(n)])