function S=dechunkstr(M)
M=M(:);
M(M==13)=[];
if M(1)~=10
    M=[10;M];
end
if M(end)~=10
    M(end+1)=10;
end
I=find(M==10);
if ~exist('n','var') || isempty(n)
    n=numel(I)-1;
end

S=cell(n,1);

for k=1:n
    S{k,1}=char(M(I(k)+1:I(k+1)-1))';
end
