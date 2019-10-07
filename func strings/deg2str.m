function S=deg2str(N)
%  g° min.min_frac
%N=[-117.0101]
%erasmo
sg=sign(N);
N=abs(N);

n=numel(N);
g=fix(N);
m=floor((60*rem(N,1)));
s=((60*rem(N*60,1)));
%S=[num2str(g),repmat('° ',n,1),sprintf('%03d''%03d''''',m,s)]
S=cell(size(N))
for k=1:n
    %S{k,1}=sprintf('%2d°%02d''%05.2f"',g(k)*sg(k),m(k),s(k)); %segundos
    %S{k,1}=sprintf('%2d°%06.3f''',g(k)*sg(k),60*rem(N(k),1)); %minutos
    %version general
    S{k}=sprintf('%2d°%05.2f',g(k)*sg(k),60*rem(N(k),1)); %minutos %version para pdf lances
end
%S=char(S);


if n==1
    S=S{1};
end