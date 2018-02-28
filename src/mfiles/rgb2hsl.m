% Title: Pattern Recognition
% Author: Yong Hyun Kim 201083607
% Log: last modified 2011/01/02

function [h,s,l] = rgb2hsl(r,g,b)
%RGB2HSL Convert rgb pixel value to hsl value.

% STDR: st = 1; CCIR601: st = 2; ITUR709: st = 3;
st = 1;
lconv ...
    = [0.3333, 0.3334, 0.3333;...
    0.2990, 0.5870, 0.1140;...
    0.2126, 0.7152, 0.0722];

if (r >= g && g >= b) %S1
    if ((r-b) ~= 0)
        h = 60.0 * (double(g-b) / double(r-b));
    else
        h = 60.0;
    end
    % disp('S1:Red-Yellow');
    
elseif (g > r && r >= b) %S2
    h = 60.0 * (2.0 - double(r-b) / double(g-b));
    % disp('S2:Yellow-Green');

elseif (g >= b && b > r) %S3
    h = 60.0 * (2.0 + double(b-r) / double(g-r));
    % disp('S3:Green-Cyan');
    
elseif (b > g && g > r) %S4
    h = 60.0 * (4.0 - double(g-r) / double(b-r));
    % disp('S4:Cyan-Blue');
    
elseif (b > r && r >= g) %S5
    h = 60.0 * (4.0 + double(r-g) / double(b-g));
    % disp('S5:Blue-Magenta');

elseif (r >= b && b > g) %S6
    h = 60.0 * (6.0 - double(b-g) / double(r-g));
    % disp('S6:Magenta-Red');

else
    h = -1;
%    disp('X');
end

s = 1 - double(min([r g b]))/ 255.0;
l = lconv(st,1) * double(r)/255.0 ...
    + lconv(st,2) * double(g)/255.0 ...
    + lconv(st,3) * double(b)/255.0;



