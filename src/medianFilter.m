%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: medianFilter
% File: medianFilter
% Description: Applies a median filter to an image.
% Created: June 20, 2011
% Authors: Scott Stevenson & Donovan Benoit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [imageNew] = medianFilter(image, filterRadius)
% image         image to apply median filter to
% filterRadius  half of the width/height of the median filter (e.g. a 3-by-3
% filter would have a filterRadius of 1)
%
% imageNew       the filtered image
print('START: Median Filter');

% Get image width and height
[H, W] = size(image);

% Create matrix to store the new image to
imageNew = zeros(H,W);

% Perform median filter operation
for y = 1:H 
    for x = 1:W 
        median_data = [];
        
        % Go through all pixels in block
        for dy = 1:((filterRadius*2) + 1)
            for dx = 1:((filterRadius*2) + 1)
                
                ycur = y + dy - (filterRadius + 1);
                xcur = x + dx - (filterRadius + 1);
                
                % Store each pixel in an array (that the median will be
                % found of)
                if (xcur < 1) || (ycur < 1) || (xcur > W) || (ycur > H)
                    median_data = [median_data; 0]; %#ok<*AGROW>
                else
                    median_data = [median_data; image(ycur,xcur,1)];
                end
            
            end
        end
        
        % Get the median value of the array
        imageNew(y,x) = median(median_data);
    end
end

disp('END: Median Filter');