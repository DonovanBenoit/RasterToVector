classdef testbench
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mImage; %the image
        info;  %info on the loaded image
    end
    
    methods
        % bench is the instance of the testbench object
        function bench = loadImage( bench )
            [name, path] = uigetfile( {'*.bmp;*.jpg;*.png';'*.*'}, 'Open Image' );
            pathAndName = strcat( path, name );
            if( ( length( name ) ~= 1 ) && ( length( path ) ~= 1 ) )
                bench.info = imfinfo( pathAndName );
                bench.mImage = imread( pathAndName );
            end
        end
        
        % Return the testbench image
        function image = get.mImage( bench )
            image = bench.mImage;
        end
        
        % Return the testbench image info
        function info = get.info( bench )
            info = bench.info;
        end
        
    end
    
end

