function toSVG( fillColors, strokeColors, strokeWidths, points, pathColors, startPoints, startCPoints, endPoints, endCPoints )

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
    
    % Create Cubic Bezier Curves
    [r, c] = size( startPoints );
    m = r * c;
    for i = 1:m     
        % Path
        fprintf( fid, '<path d="M' );  
        fprintf( fid, '%i,%i ', startPoints{ i } );
        fprintf( fid, 'C%i,%i ', startCPoints{ i } );
        fprintf( fid, '%i,%i ', endCPoints{ i } );
        fprintf( fid, '%i,%i"', endPoints{ i } );
        % Fill  
        fprintf( fid, ' fill="none" stroke-width="1" stroke="' );
        fprintf( fid, pathColors{ i } );
        % End
        fprintf( fid, '"/>\n' );
    end
    
    
    fprintf( fid, '</svg>\n' );
    
% docNode = com.mathworks.xml.XMLUtils.createDocument( 'svg' ); 
% docRootNode = docNode.getDocumentElement; 
% docRootNode.setAttribute( 'standalone', 'yes' );
% 
% %Create Node
% polyNode = generatePolygon( docNode );
% 
% % Insert Data
% %worldNode.appendChild( docNode.createTextNode( sprintf( '%s', 'Hello World!' ) ) );
% 
% % Position Nodes
% %helloNode.appendChild( worldNode );
% %docRootNode.appendChild( helloNode );
% docRootNode.appendChild( polyNode );





    
   % xmlwrite( file, docNode ); 
   
   %fprintf( fid, '<?xml version="1.0" standalone="yes"?> \n <!DOCTYPE svg PUBLIC "raster to vector" "scott & donovan">' );
%                  '<svg width="100%" height="100%" version="1.1"> \n', ...
%                  '<circle cx="100" cy="50" r="40" stroke="black"stroke-width="2" fill="red"/> \n', ...
%                  '<rect x="0.5cm" y="0.5cm" width="2cm" height="1cm"/> \n', ...
%                  '</svg>' );
   edit( file ); 
end
end

function [polyNode] = generatePolygon( docNode )
polyNode = docNode.createElement( 'polygon' );
polyNode.setAttribute('d', sprintf( '%s', 'polygon points"220,100 300,210 170,250"style="fill:#cccccc;stroke:#000000;stroke-width:1"' ) );
end