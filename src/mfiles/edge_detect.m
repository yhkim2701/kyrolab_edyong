% Title: Identification of Geometrical Elements Through Pattern Recognition
% Author: Yong Hyun Kim
% Log: last modified 2011/01/02
% Required Files: rgb2hsl.m spec_diff.m spec_discr.m (atand2.m)
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Primary parameter initialization. (Subject to change)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
in_path_name = '\home\abra\Desktop\proj_repos\proj_edge_detect\src\img\';
in_pre_fname = 'img506';

tile_size = 1;

% h: mode = 1; s: mode = 2; l: mode = 3;
% hs: mode = 4; hl: mode = 5; sl_or: mode = 6; sl_and: mode = 7;
% hsl: mode = 8;
detect_mode = 3;

%(101:1,8,1.0,0.2,0.8) (102:1,8,1.0,0.2,0.8) (104:1,8,1.0,0.1,0.8)
%(105:1,8,1.0,0.1,0.8)
%(502:1,3,1.0,0.1,0.28)
thres_dh = 1.0;
thres_ds = 0.2;
thres_dl = 0.2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Secondary parameter initialization. (Fixed values)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rgb_max = single(255);
cred = 1;
cgreen = 2;
cblue = 3;

% STDR: st=1; CCIR601: st=2; ITUR709: st=3;
lconv ...
    = [0.3333, 0.3334, 0.3333;...
    0.2990, 0.5870, 0.1140;...
    0.2126, 0.7152, 0.0722];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Defining index number used to describe each column of lpn lookup table.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
col_y = 1;
col_x = 2;
col_h = 3;
col_s = 4;
col_l = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reading Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elapsed_t = cell(1);
proc_index = 1;

tic;

in_fname = sprintf('%s%s.jpg',in_path_name, in_pre_fname);
img_frame = imread(in_fname);
% imshow(img_frame);
[pixel_ymax,pixel_xmax,rgb_dim] = size(img_frame);
tile_ymax = floor(pixel_ymax./tile_size);
tile_xmax = floor(pixel_xmax./tile_size);

pixel_h = zeros(pixel_ymax,pixel_xmax);
pixel_s = zeros(pixel_ymax,pixel_xmax);
pixel_l = zeros(pixel_ymax,pixel_xmax);

tile_h = zeros(tile_ymax,tile_xmax);
tile_s = zeros(tile_ymax,tile_xmax);
tile_l = zeros(tile_ymax,tile_xmax);

elapsed_t{proc_index} = toc;
proc_index = proc_index + 1;
disp('> Image reading done');

edge_tile_bm = zeros(tile_ymax,tile_xmax);
edge_pixel_bm = zeros(pixel_ymax,pixel_xmax);

for nu=1:tile_ymax
    for mu=1:tile_xmax
        t_count = 0;
        sum_sin_h = 0;
        sum_cos_h = 0;
        sum_s = 0;
        sum_l = 0;
        for alpha=1:tile_size
            for beta=1:tile_size
                chi = (nu-1)*tile_size+alpha;
                phi = (mu-1)*tile_size+beta;
                r_value = img_frame(chi,phi,cred);
                g_value = img_frame(chi,phi,cgreen);
                b_value = img_frame(chi,phi,cblue);
                [h_value,s_value,l_value] = rgb2hsl(r_value,g_value,b_value);
                pixel_h(chi,phi) = h_value;
                pixel_s(chi,phi) = s_value;
                pixel_l(chi,phi) = l_value;
                
                if (h_value ~= -1)
                    t_count = t_count+1;
                    sum_sin_h = sum_sin_h + sind(h_value);
                    sum_cos_h = sum_cos_h + cosd(h_value);
                    sum_s = sum_s + s_value;
                    sum_l = sum_l + l_value;
                end
            end
        end
        avg_h = atand2(double(sum_sin_h), double(sum_cos_h));
        avg_s = sum_s / double(t_count);
        avg_l = sum_l / double(t_count);
        
        tile_h(nu,mu) = avg_h;
        tile_s(nu,mu) = avg_s;
        tile_l(nu,mu) = avg_l;
    end
end
disp('> Tiling done');

cond_h = 'max_tile_dh >= thres_dh';
cond_s = 'max_tile_ds >= thres_ds';
cond_l = 'max_tile_dl >= thres_dl';
cond_hs = sprintf('%s || %s', cond_h, cond_s);
cond_hl = sprintf('%s || %s', cond_h, cond_l);
cond_sl_or = sprintf('%s || %s', cond_s, cond_l);
cond_sl_and = sprintf('%s && %s', cond_s, cond_l);
cond_hsl = sprintf('%s || %s || %s', cond_h, cond_s, cond_l);

cond_th = cell(8);

cond_th{1} = cond_h; cond_th{2} = cond_s; cond_th{3} = cond_l;
cond_th{4} = cond_hs; cond_th{5} = cond_hl; cond_th{6} = cond_sl_or;
cond_th{7} = cond_sl_and; cond_th{8} = cond_hsl;

for nu=1:(tile_ymax-1)
    for mu=1:(tile_xmax-1)
        tile_dh1 = spec_diff(tile_h(nu,mu),tile_h(nu,mu+1));
        tile_ds1 = abs(tile_s(nu,mu)-tile_s(nu,mu+1));
        tile_dl1 = abs(tile_l(nu,mu)-tile_l(nu,mu+1));
        
        tile_dh2 = spec_diff(tile_h(nu,mu),tile_h(nu+1,mu+1));
        tile_ds2 = abs(tile_s(nu,mu)-tile_s(nu+1,mu+1));
        tile_dl2 = abs(tile_l(nu,mu)-tile_l(nu+1,mu+1));
        
        tile_dh3 = spec_diff(tile_h(nu,mu),tile_h(nu+1,mu));
        tile_ds3 = abs(tile_s(nu,mu)-tile_s(nu+1,mu));
        tile_dl3 = abs(tile_l(nu,mu)-tile_l(nu+1,mu));
        
        if (mu ~= 1)
            tile_dh4 = spec_diff(tile_h(nu,mu),tile_h(nu+1,mu-1));
            tile_ds4 = abs(tile_s(nu,mu)-tile_s(nu+1,mu-1));
            tile_dl4 = abs(tile_l(nu,mu)-tile_l(nu+1,mu-1));
        else
            tile_dh4 = tile_dh3;
            tile_ds4 = tile_ds3;
            tile_dl4 = tile_dl3;
        end
            
        max_tile_dh = max([tile_dh1 tile_dh2 tile_dh3 tile_dh4]);
        max_tile_ds = max([tile_ds1 tile_ds2 tile_ds3 tile_ds4]);
        max_tile_dl = max([tile_dl1 tile_dl2 tile_dl3 tile_dl4]);
        
        if (eval(cond_th{detect_mode}))
            edge_tile_bm(nu,mu) = 1;
        end
    end
end
disp('> Tile-level edge-detection done');

figure(1), imshow(edge_tile_bm);

if(tile_size ~= 1)
    
cond_h = 'max_pixel_dh >= thres_dh';
cond_s = 'max_pixel_ds >= thres_ds';
cond_l = 'max_pixel_dl >= thres_dl';
cond_hs = sprintf('%s || %s', cond_h, cond_s);
cond_hl = sprintf('%s || %s', cond_h, cond_l);
cond_sl_or = sprintf('%s || %s', cond_s, cond_l);
cond_sl_and = sprintf('%s && %s', cond_s, cond_l);
cond_hsl = sprintf('%s || %s || %s', cond_h, cond_s, cond_l);
cond_th = cell(8);
cond_th{1} = cond_h; cond_th{2} = cond_s; cond_th{3} = cond_l;
cond_th{4} = cond_hs; cond_th{5} = cond_hl; cond_th{6} = cond_sl_or;
cond_th{7} = cond_sl_and; cond_th{8} = cond_hsl;

for nu=1:tile_ymax
    for mu=1:tile_xmax
        if (edge_tile_bm(nu,mu) == 1)
            for alpha=1:(tile_size-1)
                for beta=1:(tile_size-1)
                    chi = (nu-1)*tile_size+alpha;
                    phi = (mu-1)*tile_size+beta;
                    
                    pixel_dh1 = spec_diff(pixel_h(chi,phi),pixel_h(chi,phi+1));
                    pixel_ds1 = abs(pixel_s(chi,phi)-pixel_s(chi,phi+1));
                    pixel_dl1 = abs(pixel_l(chi,phi)-pixel_l(chi,phi+1));
                    
                    pixel_dh2 = spec_diff(pixel_h(chi,phi),pixel_h(chi+1,phi+1));
                    pixel_ds2 = abs(pixel_s(chi,phi)-pixel_s(chi+1,phi+1));
                    pixel_dl2 = abs(pixel_l(chi,phi)-pixel_l(chi+1,phi+1));
                    
                    pixel_dh3 = spec_diff(pixel_h(chi,phi),pixel_h(chi+1,phi));
                    pixel_ds3 = abs(pixel_s(chi,phi)-pixel_s(chi+1,phi));
                    pixel_dl3 = abs(pixel_l(chi,phi)-pixel_l(chi+1,phi));
                    
                    if (beta ~= 1)
                        pixel_dh4 = spec_diff(pixel_h(chi,phi),pixel_h(chi+1,phi-1));
                        pixel_ds4 = abs(pixel_s(chi,phi)-pixel_s(chi+1,phi-1));
                        pixel_dl4 = abs(pixel_l(chi,phi)-pixel_l(chi+1,phi-1));
                    else
                        pixel_dh4 = pixel_dh3;
                        pixel_ds4 = pixel_ds3;
                        pixel_dl4 = pixel_dl3;
                    end
                    
                    max_pixel_dh = max([pixel_dh1 pixel_dh2 pixel_dh3 pixel_dh4]);
                    max_pixel_ds = max([pixel_ds1 pixel_ds2 pixel_ds3 pixel_ds4]);
                    max_pixel_dl = max([pixel_dl1 pixel_dl2 pixel_dl3 pixel_dl4]);
                    
                    if (eval(cond_th{detect_mode}))
                        edge_pixel_bm(chi,phi) = 1;
                    end
                end %beta
            end %alpha
        end %if     
    end %mu
end %nu

disp('> Pixel-level edge-detection done');

figure(2), imshow(edge_pixel_bm);
end

% figure(3), bw1 = edge(pixel_l,'sobel'); imshow(bw1);
% figure(4), bw1 = edge(pixel_l,'prewitt'); imshow(bw1);
% figure(5), bw1 = edge(pixel_l,'roberts'); imshow(bw1);
% figure(6), bw1 = edge(pixel_l,'log'); imshow(bw1);
% figure(7), bw1 = edge(pixel_l,'canny'); imshow(bw1);

% szl_tile = sparse(zl_tile);
% [lpn_y, lpn_x, lpn_luma] = find(szl_tile);
% [sz_n, sz_m] = size(lpn_y);

