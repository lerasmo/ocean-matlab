function out=acento(in);


b='����������';
p='aeiouAEIOU';

if ~exist('in','var') || isempty(in)
    in=p;
end
[~,j,k]=intersect(in,p);
out=b(k);