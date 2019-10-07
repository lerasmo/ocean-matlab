function [x, y]=lims2rect(ax)
if ~exist('lims')
    ax=axis;
end

x=ax([1 2 2 1]);
y=ax([3 3 4 4]);
if nargin==1
    x=[x' y'];
end
