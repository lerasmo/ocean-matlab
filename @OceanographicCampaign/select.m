function [R, I]=select(R,str)
%seleccionar el crucero


if ischar(str)
elseif isnumeric(str)
    str=num2str(str,'%04d');
    
end
[a, I]=filter_text({R.Crucero}',str);
R=R(I);