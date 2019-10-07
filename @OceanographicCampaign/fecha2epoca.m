function [e, ep]=fecha2epoca(R)


for k=1:numel(R)
    [e(k,1) ,ep(k,1)]=fecha2epoca(mean(R(k).fecha));
end

