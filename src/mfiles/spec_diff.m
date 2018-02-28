% Title: Pattern Recognition
% Author: Yong Hyun Kim 201083607
% Log: last modified 2011/01/02

function q = spec_diff(h1,h2)
%SPEC_DIFF returns degree of difference between two hue values
% Returns a value between [0,1]

[g1,bw1] = spec_discr(h1);
[g2,bw2] = spec_discr(h2);
dg = abs(g1-g2);

if (dg == 0)
    q = 0.0;
elseif (dg == 1 || dg == 13)
    bwt = bw1+bw2;
    if (g1 == 1 && g2 == 14)
        if(h1 >= 330.0), q = abs(h1-h2)/bwt;
        else q = abs(360.0+h1-h2)/bwt; end;
    elseif (g1 == 14 && g2 == 1)
        if(h2 >= 330.0), q = abs(h1-h2)/bwt;
        else q = abs(360.0-h1+h2)/bwt; end;
    elseif (g1 == 1 && g2 == 2)
        if(h1 < 15.0), q = abs(h1-h2)/bwt;
        else q = abs(360.0-h1+h2)/bwt; end;
    elseif (g1 == 2 && g2 == 1)
        if(h2 < 15.0), q = abs(h1-h2)/bwt;
        else q = abs(360.0+h1-h2)/bwt; end;
    else
        q = abs(h1-h2)/bwt;
    end
elseif (dg >= 2 && dg <= 12)
    q = 1.0;
end

