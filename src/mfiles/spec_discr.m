% Title: Pattern Recognition
% Author: Yong Hyun Kim 201083607
% Log: last modified 2011/01/02

function [g,bw] = spec_discr(h)
%SPEC_DISCR returns color group number & bandwidth of the color group
% that hue value belongs to.

if (h >= 330.0 || h < 15.0)
    g = 1; bw = 45.0;
elseif (h >= 15.0 && h < 30.0)
    g = 2; bw = 15.0;
elseif (h >= 30.0 && h < 45.0)
    g = 3; bw = 15.0;
elseif (h >= 45.0 && h < 60.0)
    g = 4; bw = 15.0;
elseif (h >= 60.0 && h < 75.0)
    g = 5; bw = 15.0;
elseif (h >= 75.0 && h < 150.0)
    g = 6; bw = 75.0;
elseif (h >= 150.0 && h < 165.0)
    g = 7; bw = 15.0;
elseif (h >= 165.0 && h < 195.0)
    g = 8; bw = 30.0;
elseif (h >= 195.0 && h < 210.0)
    g = 9; bw = 15.0;
elseif (h >= 210.0 && h < 255.0)
    g = 10; bw = 45.0;
elseif (h >= 255.0 && h < 270.0)
    g = 11; bw = 15.0;
elseif (h >= 270.0 && h < 285.0)
    g = 12; bw = 15.0;
elseif (h >= 285.0 && h < 315.0)
    g = 13; bw = 30.0;
elseif (h >= 315.0 && h < 330.0)
    g = 14; bw = 15.0;
else
    g = -1; bw = -1;
end

