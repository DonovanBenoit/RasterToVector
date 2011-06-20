function [ imageNew ] = autoThreshold( image )
%AUTOTHRESHOLD Automatically thresholds image using Otsu's method.
% image     the image to automatically threshold, in double format
disp('Start: Automatic Threshold');

% Get image size
[H,W] = size(image);

% Convert image from 0-1 range to integer 1-256 range.
image = round(image.*256);

% Generate 256 bin histogram
image_hist = hist(image, 1:256);

% Perform Otsu's method to find the optimal threshold value (from notes)
n = W*H;
wgv_min = 1.0E9;
for T=1:256
    BX2 = 0;
    BX = 0;
    BN = 0;
    WX2 = 0;
    WX = 0;
    WN = 0;
    for I=1:256
        p=double(image_hist(I));
        if I<T
            BX = BX + p*(I-1);
            BX2 = BX2 + p*(I-1)*(I-1);
            BN = BN + p;
        else
            WX = WX + p*(I-1);
            WX2 = WX2 + p*(I-1)*(I-1);
            WN = WN + p;
        end;
    end;
    
    v1 = (BN*BX2 - BX*BX) / (BN*(BN-1));
    ps1= BN/n;
    v2 = (WN*WX2 - WX*WX) / (WN*(WN-1));
    ps2= WN/n;
    wgv = ps1*v1 + ps2*v2;
    
    if wgv<wgv_min
        wgv_min=wgv;
        value=T; %value is the threshold value
    end;
end;

% Apply threshold using found value
for y = 1:H
    for x = 1:W
        if(image(y,x) > value)
            image(y,x) = 1;
        elseif(image(y,x) < value)
            image(y,x) = 0;
        end;
    end;
end;

% Convert image back to double format
imageNew = im2double(image);

disp('END: Automatic Threshold');
end

