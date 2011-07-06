clear all;  close all;  clc;

%--------------------------------------------------------------------------
% RASTER TO VECTOR CONVERSION WITH MATLAB
%--------------------------------------------------------------------------
% Daniel Hawkes 05/05/10
%
%

% Set number of colours to use in vector image.
no_of_colours = 2;

% Percentage of points to keep from each shape.
% E.G. '10' means discarding 90% of the data.
quality = 5;

% Remove single points?
REMOVE_POINTS = 1;

% Show figures for intermediary steps?
SHOW_INTERMEDIATE_FIGURES = 0;

% Show output fullscreen? (only when the above = 0)
SHOW_FULLSCREEN = 1;

% Use median filter to remove highest frequency noise?
MEDIAN_FILTER = 1;

% Read in the JPEG.
img1 = imread('res/HollowRectangleDigital.png');

%--------------------------------------------------------------------------

% Show the source JPEG.
if SHOW_INTERMEDIATE_FIGURES
    set(figure(1), 'Position', [50, 50, 800, 400],...
                   'Name', 'Source JPEG',...
                   'Color','black',...
                   'Toolbar', 'none');
    imshow(img1);
else
    set(figure(1), 'Position', [50, 50, 800, 400],...
                   'Name', 'Raster Source and Vector Output',...
                   'Toolbar', 'none',...
                   'Color','black');
    subplot(1,2,1);
    subimage(img1);
    axis off;
    
    % Maximise
    if SHOW_FULLSCREEN
        if nargin==0, fig=gcf; end
        units=get(figure(1),'units');
        set(figure(1),'units','normalized','outerposition',[0 0 1 1]);
        set(figure(1),'units',units);
    end
end

%--------------------------------------------------------------------------

% Reduce number of colours in image. Array 'map' holds index of the colours.
[img2,map]= rgb2ind(img1,no_of_colours,'nodither');

if SHOW_INTERMEDIATE_FIGURES
% Figure: Show reduced colour image.
    set(figure(2), 'Position', [50, 50, 800, 400],...
                   'Name', 'Reduced colour raster image',...
                   'Color','black',...
                   'Toolbar', 'none',...
                   'Menu', 'figure');
    imshow(img2,map);
end

%--------------------------------------------------------------------------

% Split image into black and white mask layers, and store them in a cell
% array.
for i=1:no_of_colours
    if  MEDIAN_FILTER
        layered_img(i) = {medfilt2(eq(img2+1,i))};
    else
        layered_img(i) = {eq(img2+1,i)};
    end
end

if SHOW_INTERMEDIATE_FIGURES
    % Figure: Show the layer masks.
    set(figure(3), 'Position', [50, 50, 1200, 800],...
                   'Name', 'Layer Masks',...
                   'Toolbar', 'none',...
                   'Menu', 'figure');
           
    for i=1:no_of_colours
        subplot(ceil(no_of_colours^0.5),ceil(no_of_colours^0.5),i);
        subimage(layered_img{i});
        axis off image;
    end
end

%--------------------------------------------------------------------------

% Ready figure to draw on.
if SHOW_INTERMEDIATE_FIGURES
    
    set(figure(4), 'Position', [50, 50, size(img2,2), size(img2,1)],...
                   'Name', 'Vector Image',...
                   'Toolbar', 'none',...
                   'Color','black',...
                   'Menu', 'figure');
               
else
    subplot(1,2,2);
end
    
axis ([0 size(img2,2) -size(img2,1) 0]);
axis image;
axis off;

hold on;

% Draw shapes.
for i=1:no_of_colours
    
    % Fill holes.
    layered_img{i} = imfill(layered_img{i},'holes');

    % Trace edges of continuous blocks of colour. 
    % Data structure is now:
    % 'Layered_img' contains cell array of:
    % ---> 'Layers', which contain cell array of:
    % ------> 'Shapes' in the layer.
    layered_img{i} = bwboundaries(layered_img{i});

    % Find number of shapes in layer.
    shapes_in_layer = size(layered_img{i},1);

    
    k=1;
    
    while k<=shapes_in_layer
        
        % Get number of points in this shape
        points_in_shape = size(layered_img{i}{k},1);
        

        % Percentage of points to keep.
        points_to_skip = cast( ceil(100/quality),'uint32');
       
        % Reduce number of points in each shape.
        layered_img{i}{k} = layered_img{i}{k}([1:points_to_skip:points_in_shape],[1 2]);
    
        % If 'shape' is now a point, remove it.
        if REMOVE_POINTS == 1
            if size(layered_img{i}{k},1) <= 1
                layered_img{1,i}{k,1} = [0 0];
            end
        end
        k=k+1;
        
    end
    
    % Find number of shapes in layer.
    shapes_in_layer = size(layered_img{i},1);
    
    
    % Plot the shapes as polygons
    for k=1:shapes_in_layer
    p = patch(layered_img{i}{k}(:,2),-layered_img{i}{k}(:,1),1);
    set(p,'FaceColor',[map(i,:)]);
    set(p,'EdgeColor','none');
    end
    
end

%--------------------------------------------------------------------------

% Clean up unwanted variables.
clear i k p img1 img2 no_of_colours point_compression_ratio 'pixels'...
points_in_shape shapes_in_layer REMOVE_POINTS SHOW_INTERMEDIATE_FIGURES;

%--------------------------------------------------------------------------