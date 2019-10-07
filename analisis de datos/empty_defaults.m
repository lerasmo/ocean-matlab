function empty_defaults(varargin)

for k=1:numel(varargin)
    
    r=evalin('caller',['exist(''',varargin{k},''',''var'')']);
    if ~r
        evalin('caller',[varargin{k},'=[];'])
    end
   % keyboard
end
