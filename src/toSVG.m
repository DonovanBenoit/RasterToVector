function toSVG( fillColors, strokeColors, strokeWidths, points, paths )

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
    
    % Create Polygons
    [r, c] = size( points );
    m = r * c;
    for i = 1:m
        % Polygon Points
        p = points{ i };
        fprintf( fid, '<polygon points="' );
        j = 1;
        [r, c] = size( p );
        n = r * c;
        while j <= n
            fprintf( fid, '%i,%i ', p( j ), p( j + 1 ) );
            j = j + 2;
        end
        % Fill  
        fprintf( fid, '" fill="' );
        fprintf( fid, fillColors{ i } );
        % Stroke
        fprintf( fid, '" stroke="' );
        fprintf( fid, strokeColors{ i } );
        fprintf( fid, '" stroke-width="%i', strokeWidths{ i } );
        fprintf( fid, '"/>\n' );
    end
    
    % Paths
    [m,c] = size( paths );
    for i = 1:m     
        fprintf( fid, '<path d="M%i,', paths{i,2}(1,1) );  
        fprintf( fid, '%i ', paths{i,2}(1,2) );
        
        startC = paths{i,3};
        endC = paths{i,4};
        endP = paths{i,5};
        [r, n] = size( startC );
        j = 1;
        while j <= n
            fprintf( fid, 'C%i', startC( j ) );
            fprintf( fid, ',%i ', startC( j + 1 ) );
            fprintf( fid, '%i', endC( j ) );
            fprintf( fid, ',%i ', endC( j + 1 ) );
            fprintf( fid, '%i', endP( j ) );
            if j == n - 1
                fprintf( fid, ',%i"', endP( j + 1 ) );
            else
                fprintf( fid, ',%i ', endP( j + 1 ) );
            end
            j = j + 2;
        end
        % Fill  
        fprintf( fid, ' fill="none" stroke-width="1" stroke="rgb(%i,%i,%i)"/>\n', int32( paths{i,1} * 255 ) );
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