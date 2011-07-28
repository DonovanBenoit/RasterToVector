function toSVG( polys, paths )

% Get File to Save
[filename, pathname] = uiputfile( { '*.svg','Scalable Vector Graphics (*.svg)' }, 'Save figure as','../out');
%if user cancels save command, nothing happens
if isequal( filename, 0 ) || isequal( pathname, 0 )
else
    file = fullfile( pathname, filename );
    % Open File with write permision
    fid = fopen( file, 'w');
    
    % Print Header
    fprintf( fid, '<?xml version="1.0" standalone="yes"?>\n' );
    fprintf( fid, '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "raster 2 vector">\n' );
    
    % SVG Code
    fprintf( fid, '<svg width="100%%" height="100%%" xmlns="http://www.w3.org/2000/svg" version="1.1">\n' );
    
    % Polygons
    [m,c] = size( polys );
    for i = 1:m
        fprintf( fid, '<polygon points="' );
        [n, c] = size( polys{i,2} );
        for j = 1:n
            if j == n  % last point
                fprintf( fid, '%i,%i"', polys{i,2}(j,1), polys{i,2}(j,2) );
            else
                fprintf( fid, '%i,%i ', polys{i,2}(j,1), polys{i,2}(j,2) );
            end
        end
        % Fill  
        fprintf( fid, ' fill="rgb(%i,%i,%i)" stroke-width="1" stroke="none"/>\n', int32( polys{i,1} * 255 ) );
    end
    
    % Curves
    [m,c] = size( paths );
    for i = 1:m     
        fprintf( fid, '<path d="M%i,', paths{i,2}(1,1) );  
        fprintf( fid, '%i ', paths{i,2}(1,2) );
        
        startC = paths{i,3};
        endC = paths{i,4};
        endP = paths{i,5};
        [n, r] = size( startC );
       
        for j = 1: n
            fprintf( fid, 'C%i', startC( j, 1 ) );
            fprintf( fid, ',%i ', startC( j, 2 ) );
            fprintf( fid, '%i', endC( j, 1  ) );
            fprintf( fid, ',%i ', endC( j, 2 ) );
            fprintf( fid, '%i', endP( j, 1 ) );
            if j == n
                fprintf( fid, ',%i"', endP( j, 2 ) );
            else
                fprintf( fid, ',%i ', endP( j, 2 ) );
            end
           
        end
        % Fill  
        fprintf( fid, ' fill="rgb(%i,%i,%i)" stroke-width="1" stroke="rgb(%i,%i,%i)"/>\n', int32( paths{i,1} * 255 ), int32( paths{i,1} * 255 ) );
    end
    
    fprintf( fid, '</svg>\n' );
    % Open the file for viewing
    edit( file ); 
end
end

function [polyNode] = generatePolygon( docNode )
polyNode = docNode.createElement( 'polygon' );
polyNode.setAttribute('d', sprintf( '%s', 'polygon points"220,100 300,210 170,250"style="fill:#cccccc;stroke:#000000;stroke-width:1"' ) );
end