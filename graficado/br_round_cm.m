function map = BR_round_cm(m)
%BR_round_cm White-Blue-White-Red-White Colormap
%   BR_round_cm(M) returns an M-by-3 matrix containing a colormap. 
%   The colors begin with dark purplish-blue and blue, range
%   through green and orange, and end with bright yellow. ANOMALY is useful
%   to show anomaly maps.
%
%   BR_round_cm returns a colormap with the same number of colors as the current
%   figure's colormap. If no figure exists, MATLAB uses the length of the
%   default colormap.
%
%   EXAMPLE
%
%   This example shows how to reset the colormap of the current figure.
%
%       colormap(br_round_cm)
%
%   See also AUTUMN, BONE, COLORCUBE, COOL, COPPER, FLAG, GRAY, HOT, HSV,
%   JET, LINES, PINK, PRISM, SPRING, SUMMER, WHITE, WINTER, COLORMAP,
%   RGBPLOT.

%   Tomado de Parula, modificado por Erasmo Junio-2018


if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end

%% Blanco en 180
% values = [...
%     1.0000    1.0000    1.0000
%     0.0    0.0    0.6270
%     1.0000    1          1
%     1.0000         0         0
%     1.0000    1.0000    1.0000
%    ];

%% Morado en 180
values =[
     1     0     1
     0     0     1
     1     1     1
     1     0     0
     1     0     1];


P = size(values,1);
map = interp1(1:size(values,1), values, linspace(1,P,m), 'linear');
