function [ output_args ] = ToPolys( img, nColors, vertexResolution, medianFilter )
%TOPOLYS Convert a color image to a group of colored polygons
%   !!!Detailed explanation goes here

%%% CONSTANTS %%%
global DISPLAY_PRINTS;
DISPLAY_PRINTS = 1;
global SHOW_INTERMEDIATES;
SHOW_INTERMEDIATES = 1;
%%%%%%%%%%%%%%%%%

% Reduce the number of colors in the image
[img2,map]= rgb2ind(img,nColors,'nodither');

if SHOW_INTERMEDIATES
    % Show reduced color image
    set(figure(2), 'Position', [50, 50, 800, 400],...
                   'Name', 'Reduced colour raster image',...
                   'Color','black',...
                   'Toolbar', 'none',...
                   'Menu', 'figure');
    imshow(img2,map);
end

for i=1:nColors
        layers(i) = {medfilt2(eq(img2+1,i))};
end

% Ready figure to draw on.
if SHOW_INTERMEDIATES
    
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
for i=1:nColors
    
    % Fill holes.
    layers{i} = imfill(layers{i},'holes');

    % Trace edges of continuous blocks of colour. 
    % Data structure is now:
    % 'Layered_img' contains cell array of:
    % ---> 'Layers', which contain cell array of:
    % ------> 'Shapes' in the layer.
    layers{i} = bwboundaries(layers{i});

    % Find number of shapes in layer.
    shapes_in_layer = size(layers{i},1);

    
    k=1;
    
    while k<=shapes_in_layer
        
        % Get number of points in this shape
        points_in_shape = size(layers{i}{k},1);
        

        % Percentage of points to keep.
        points_to_skip = cast( ceil(100/vertexResolution),'uint32');
       
        % Reduce number of points in each shape.
        layers{i}{k} = layers{i}{k}([1:points_to_skip:points_in_shape],[1 2]);
    
        % If 'shape' is now a point, remove it.

        if size(layers{i}{k},1) <= 1
            layers{1,i}{k,1} = [0 0];
        end
        k=k+1;
        
    end
    
    % Find number of shapes in layer.
    shapes_in_layer = size(layers{i},1);
    
    
    % Plot the shapes as polygons
    for k=1:shapes_in_layer
    p = patch(layers{i}{k}(:,2),-layers{i}{k}(:,1),1);
    set(p,'FaceColor',[map(i,:)]);
    set(p,'EdgeColor','none');
    end
    
end