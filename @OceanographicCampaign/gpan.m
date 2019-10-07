function R=gpan(R)


if ismember('gpan',lower(R.Variables))
    return
    %nothig to do
end


R.Variables=[R.Variables;'gpan'];
cn=numel(R.Variables);
STP=R.Lance([],{'Salinidad','Temperatura','Presion'});
for k=1:size(R.data,1)
    S=STP{k}(:,1);
    T=STP{k}(:,2);
    P=STP{k}(:,3);
    i500=find(P==500);
    if max(P)>=500
        dum=sw_gpan(S,T,P)*10; %cm dinamicos
        dum=dum(i500)-dum;
        R.data{k}(:,cn)=dum;
        
    else
        R.data{k}(:,cn)=nan;
    end
end

