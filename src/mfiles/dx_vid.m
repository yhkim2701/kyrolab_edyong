% Title: Identification of Geometrical Elements Through Pattern Recognition
% Author: Yong Hyun Kim
% Log: last modified 2011/01/02
clear;

% reading video file
xyloObj = mmreader('\home\abra\Desktop\proj_repos\proj_edge_detect\src\vid\bw1.avi');

% reading video property
get(xyloObj);

% reading the number of frames
xyloSize = get(xyloObj, {'NumberOfFrames'});
lastFrameNum = cell2mat(xyloSize);

tmpArr = zeros(xyloObj.Height,xyloObj.Width);

% drawing image
for i = 10:(lastFrameNum - 70)
    beforeFrame = read(xyloObj,i-1);
    afterFrame  = read(xyloObj, i);
    eachFrame   = afterFrame - beforeFrame;
    
    % gray image
    grayFrame   =  mean(eachFrame, 3);
    
    % integral method 
    % condition : when diff. intensity is more than 10, counting 
    tmpArr      = tmpArr + (grayFrame > 7);
    tmpArr2     = 150 .* (tmpArr ./ max(max(tmpArr)));
    
    subplot(2,1,1)
    image (read(xyloObj, i))
    
    subplot(2,1,2)
    image (tmpArr2)
    colormap(gray)
end

