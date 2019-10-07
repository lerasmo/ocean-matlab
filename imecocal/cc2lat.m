function [lat, lon] = cc2lat(li,st)
% DESCRIPTION: Use this function to convert from calcofi grid coordinates 
% to latitude and longitude. This uses a slightly modified (because the 
% original is wrong) version of the CalCOFI gridding algorithm 
% (Eber and Hewitt 1979) (Also see errata 2006).  
% Basically a little trig and some reference point defining.
% 
% INPUT: The calcofi line and station values
% OUTPUT: This function outputs a degree decimal latitude and longitude
% 
% ASSUMPTIONS: All lat/long and station values are from the Northwestern 
%               hemisphere and within the middle latitudes.
% REFERENCE: Eber and Hewitt 1979, Conversion Algorithms for the CalCOFI
% Station Grid
% WRITTEN BY: Robert Thombley (2006), Scripps Institution of Oceanography,
% CalCOFI
% MODIFIED BY: Augusto Valencia (2014), Universidad de Baja California-UABC,
% based on Weber & Moore 2013.

	rlat = 34.15 - .2 * (li - 80)*cos(cRad(30));
	lat = rlat - (1/15)*(st - 60)*sin(cRad(30));
	l1 = (mctr(lat) - mctr(34.15))*tan(cRad(30));
	l2 = (mctr(rlat) - mctr(lat))/(cos(cRad(30))*sin(cRad(30)));
	lon = l1 + l2 + 121.15;
    if lon<=180
        lon = -1*lon;
    else
        lon = (-1*lon)+360;   %Obtain a positive number greater than 180º
    end
    
function rad = cRad(deg)
% DESCRIPTION: A simple helper function that converts degrees to radians
% INPUT: angle in degrees
% OUPUT: angle in radians
% WRITTEN BY: Robert Thombley SIO 2006
	rad = deg * pi/180;
   
function val = mctr(t1)
% DESCRIPTION: Mercator transform function.  
% INPUT: Latitude value in decimal degrees
% OUTPUT: value in mercator units
% WRITTEN BY: Robert Thombley SIO 2006
	val = 180/pi* (log(tan(cRad(45 + t1/2))) - 0.00676866 * sin(cRad(t1)));