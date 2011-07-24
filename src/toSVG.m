function toSVG()

docNode = com.mathworks.xml.XMLUtils.createDocument( 'Node1' ); 
docRootNode = docNode.getDocumentElement; 

%Create Node
polyNode = docNode.createElement( '0x20' );

% Insert Data
%worldNode.appendChild( docNode.createTextNode( sprintf( '%s', 'Hello World!' ) ) );

% Position Nodes
%helloNode.appendChild( worldNode );
%docRootNode.appendChild( helloNode );
docRootNode.appendChild( polyNode );

% Save File
[filename, pathname] = uiputfile( { '*.svg','Scalable Vector Graphics (*.svg)' }, 'Save figure as','../out');

%if user cancels save command, nothing happens
if isequal( filename, 0 ) || isequal( pathname, 0 )
else
    file = fullfile( pathname, filename );
    xmlwrite( file, docNode ); 

    edit( file ); 
end
end

function [polyNode] = generatePolygon( docNode )
polyNode = docNode.createElement( 'polygon points' );%"220,100 300,210 170,250"' );%style="fill:#cccccc;stroke:#000000;stroke-width:1"' );
end