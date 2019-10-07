function map = anomaly(m)
%Anomaly Blue-White-Red Colormap
%   ANOMALY(M) returns an M-by-3 matrix containing a colormap. 
%   The colors begin with dark purplish-blue and blue, range
%   through green and orange, and end with bright yellow. ANOMALY is useful
%   to show anomaly maps.
%
%   PARULA returns a colormap with the same number of colors as the current
%   figure's colormap. If no figure exists, MATLAB uses the length of the
%   default colormap.
%
%   EXAMPLE
%
%   This example shows how to reset the colormap of the current figure.
%
%       colormap(anomaly)
%
%   See also AUTUMN, BONE, COLORCUBE, COOL, COPPER, FLAG, GRAY, HOT, HSV,
%   JET, LINES, PINK, PRISM, SPRING, SUMMER, WHITE, WINTER, COLORMAP,
%   RGBPLOT.

%   Tomado de Parula, modificado por Erasmo Marzo-2017


if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end

values = [
         0         0    0.6250
    0.0667    0.0667    0.6500
    0.1333    0.1333    0.6750
    0.2000    0.2000    0.7000
    0.2667    0.2667    0.7250
    0.3333    0.3333    0.7500
    0.4000    0.4000    0.7750
    0.4667    0.4667    0.8000
    0.5333    0.5333    0.8250
    0.6000    0.6000    0.8500
    0.6667    0.6667    0.8750
    0.7333    0.7333    0.9000
    0.8000    0.8000    0.9250
    0.8667    0.8667    0.9500
    0.9333    0.9333    0.9750
    1.0000    1.0000    1.0000
    1.0000    0.9333    0.9333
    1.0000    0.8667    0.8667
    1.0000    0.8000    0.8000
    1.0000    0.7333    0.7333
    1.0000    0.6667    0.6667
    1.0000    0.6000    0.6000
    1.0000    0.5333    0.5333
    1.0000    0.4667    0.4667
    1.0000    0.4000    0.4000
    1.0000    0.3333    0.3333
    1.0000    0.2667    0.2667
    1.0000    0.2000    0.2000
    1.0000    0.1333    0.1333
    1.0000    0.0667    0.0667
    1.0000         0         0
   ];

P = size(values,1);
map = interp1(1:size(values,1), values, linspace(1,P,m), 'linear');
