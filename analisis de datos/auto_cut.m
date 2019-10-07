function R=auto_cut(D,I,opt)
%corta el set de datos




v=get_datavars(D);
R=D;

for k=1:numel(v)
    sz(k,:)=size( R.(v{k}));
end



sz=sz==numel(I);

for k=1:numel(v)
    if sz(k,1)
        R.(v{k})=R.(v{k})(I,:);
    elseif sz(k,2)
        R.(v{k})= R.(v{k})(:,I);
    elseif isnumeric(I)
         R.(v{k})= R.(v{k})(I);
    else
        error('dimensiones')
    end
end

if isfield(R,'jd') &( numel(I)==numel(R.jd) | isnumeric(I));
    R.jd=R.jd(I);
end
