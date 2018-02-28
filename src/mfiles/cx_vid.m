% Title: Identification of Geometrical Elements Through Pattern Recognition
% Author: Yong Hyun Kim
% Log: last modified 2011/01/02
clear;

in_path_name = '\home\abra\Desktop\proj_repos\proj_edge_detect\src\img\';
in_pre_fname = 'bw1';

in_fname = sprintf('%s%s.avi',in_path_name, in_pre_fname);

% reading video file
obj_vid = mmreader(in_fname);

% reading video property
get(obj_vid)

% reading the number of frames
frame_num = get(obj_vid, {'NumberOfFrames'});
last_frame_num = cell2mat(frame_num);

% drawing image
for nu=1:(last_frame_num-65)
    frame_cur = read(obj_vid,nu);
    frame_next = read(obj_vid, nu+1);
    frame_size = size(frame_cur);
    frame_dh = zeros(frame_size(1),frame_size(2));
    frame_ds = zeros(frame_size(1),frame_size(2));
    frame_dl = zeros(frame_size(1),frame_size(2));
    
    for chi=1:frame_size(1)
        for phi=1:frame_size(2)
            r_cur = frame_cur(chi,phi,1);
            g_cur = frame_cur(chi,phi,2);
            b_cur = frame_cur(chi,phi,3);
            r_next = frame_next(chi,phi,1);
            g_next = frame_next(chi,phi,2);
            b_next = frame_next(chi,phi,3);
            [h_cur,s_cur,l_cur] = rgb2hsl(r_cur,g_cur,b_cur);
            [h_next,s_next,l_next] = rgb2hsl(r_next,g_next,b_next);
            dh = spec_diff(h_cur,h_next);
            ds = abs(s_cur-s_next);
            dl = abs(l_cur-l_next);
            if (dh > 0.2), frame_dh(chi,phi) = 1; end;
            if (ds > 0.2), frame_ds(chi,phi) = 1; end;
            if (dl > 0.2), frame_dl(chi,phi) = 1; end;
        end
    end
    
    image(frame_dh);
    %image(frame_ds);
    %image(frame_dl);
end

