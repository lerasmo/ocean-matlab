function R=variables_recalculadas(R,CTDi,Si);

for k=1:numel(R.data);
    C=R.data{k}(:,CTDi(1));
    T=R.data{k}(:,CTDi(2));
    P=R.data{k}(:,CTDi(3));
    R.data{k}(:,Si)=sw_salt(C/sw_c3515,T,P);
end