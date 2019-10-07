function empty(varargin)
%keyboard

for k=1:numel(varargin)
    assignin('caller',varargin{k},[]);
end