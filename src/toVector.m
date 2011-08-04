function [ returnData ] = toVector( img, nColors, percTracePointsToKeep, showIntermediates, mode, maxSquareDist, axes )
%TOVECTOR Convert a color image to a group of colored polygons
%   !!!Detailed explanation goes here

% Reduce the number of colors in the image
[img2,map]= rgb2ind(img,nColors,'nodither');

if showIntermediates
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


totalShapes = 0;

% Draw shapes
for i=1:nColors
    
    % Fill holes (This sometimes removes image details, best not to do)
    layers{i} = imfill(layers{i},'holes');
    
    % Trace the contour of colored blobs
    layers{i} = bwboundaries(layers{i});

    % Find number of shapes in layer and increment total shapes
    shapesInLayer = size(layers{i},1);
    totalShapes = totalShapes + shapesInLayer;
    
    k=1;
    
    while k<=shapesInLayer
        
        % Get number of points in this shape
        points_in_shape = size(layers{i}{k},1);

        % Percentage of points to keep.
        points_to_skip = cast( ceil(100/percTracePointsToKeep),'uint32');
       
        % Reduce number of points in each shape.
        layers{i}{k} = layers{i}{k}([1:points_to_skip:points_in_shape],[1 2]);
    
        % If 'shape' is now a point, remove it.

        if size(layers{i}{k},1) <= 1
            layers{1,i}{k,1} = [0 0];
        end
        k=k+1;
        
    end
end


% Set up figure to draw polygons on
if showIntermediates
    set(figure(4), 'Position', [50, 50, size(img2,2), size(img2,1)],...
                   'Name', 'Vector Image',...
                   'Toolbar', 'none',...
                   'Color','black',...
                   'Menu', 'figure');
     axis ([0 size(img2,2) -size(img2,1) 0]);
     axis image;
     axis off;
     hold on;
else
    %subplot(1,2,2);
end




% Initialize variables
shapesDrawn = 0;
returnData = [];
polygons = [];

% Start drawing shapes, drawing those with the largest perimeter first
while(shapesDrawn < totalShapes)
    maxArea = 0;
    maxAreaI = 0;
    maxAreaK = 0;
    
    for i=1:nColors
        % Find number of shapes in layer.
        shapesInLayer = size(layers{i},1);
        
        % Find next max perimeter shape to draw
        for k=1:shapesInLayer
            if size( layers{i}{k} ) > 0
                if( polyarea( layers{i}{k}(:,2), layers{i}{k}(:,1) ) > maxArea)
                    maxAreaI = i;
                    maxAreaK = k;
                    maxArea = polyarea( layers{i}{k}(:,2), layers{i}{k}(:,1) );
                end
            end
        end
    end
    
    %if( maxAreaI && maxAreaK )

    if( showIntermediates && maxAreaI && maxAreaK )
        pause;
        
        % Paint shape as a patch
        p = patch(layers{maxAreaI}{maxAreaK}(:,2),-layers{maxAreaI}{maxAreaK}(:,1),1);
        
        % Set patch edge and face color
        set(p,'FaceColor',[map(maxAreaI,:)]);
        set(p,'EdgeColor','none');
    end
        
    % MATLAB spline fitting
    %t = 1:size(layers{maxAreaI}{maxAreaK}(:,2));
    %ts = 1:1/100:size(layers{maxAreaI}{maxAreaK}(:,2));
    %xs = spline(t,layers{maxAreaI}{maxAreaK}(:,2),ts);
    %ys = spline(t,-layers{maxAreaI}{maxAreaK}(:,1),ts);
    %disp(xs)
    %disp(ys)
    %hold on;
    %plot(xs,ys, 'r')
    %hold off;
    %pause
    
    % POLYGON MODE: Just return the color of each polygon and a list of its
    % vertices
    if strcmp( mode, 'polys' ) && maxAreaI && maxAreaK
        polyVertices = [layers{maxAreaI}{maxAreaK}(:,2), layers{maxAreaI}{maxAreaK}(:,1)];
        returnData = [returnData; {map(maxAreaI,:), polyVertices}];
    end
        
    
    % BEZIER CURVE MODE: Return color of bezier curve path as well as all
    % of its breakpoints and control points.
    % Need at least 4 points to do fit.
    if strcmp(mode,'curves') && maxAreaI && maxAreaK && size(layers{maxAreaI}{maxAreaK}(:,2),1)>=4
        points = [layers{maxAreaI}{maxAreaK}(:,2),-layers{maxAreaI}{maxAreaK}(:,1)];
        points = vertcat(points,points(1,:)); % Close shape to start point
 
        [p0mat,p1mat,p2mat,p3mat,fbi,MxSqD] = bzapproxu(points, maxSquareDist);
        [MatI]=BezierInterpCPMatSegVec(p0mat,p1mat,p2mat,p3mat,fbi);

        if(showIntermediates)
            hold on
            plot2d_bz_org_intrp_cp(points,MatI,p0mat,p1mat,p2mat,p3mat);
            hold off
        end
        
        % Convert y values to be positive instead of negative
        p0mat = abs(p0mat);
        p1mat = abs(p1mat);
        p2mat = abs(p2mat);
        p3mat = abs(p3mat);
        
        returnData = [returnData; {map(maxAreaI,:),p0mat,p1mat,p2mat,p3mat}];
    end
    
    % Remove shape that was just painted from layers
    if maxAreaI && maxAreaK
    layers{maxAreaI}{maxAreaK} = [];
    end
    
    %end
    shapesDrawn = shapesDrawn + 1;
    
end
    