function varargout = linesGui( varargin )
% LINESGUI MATLAB code for linesGui.fig
%      LINESGUI, by itself, creates a new LINESGUI or raises the existing
%      singleton*.
%
%      H = LINESGUI returns the handle to a new LINESGUI or the handle to
%      the existing singleton*.
%
%      LINESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINESGUI.M with the given input arguments.
%
%      LINESGUI('Property','Value',...) creates a new LINESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before linesGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to linesGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help linesGui

% Last Modified by GUIDE v2.5 23-Jul-2011 19:58:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @linesGui_OpeningFcn, ...
                   'gui_OutputFcn',  @linesGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before linesGui is made visible.
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to linesGui (see VARARGIN)
function linesGui_OpeningFcn( hObject, eventdata, handles, varargin )

% Choose default command line output for linesGui
handles.output = hObject;

% Make setImage visable
handles.setImage = @setLineImage;

% Initialize global variables
% Min length to use for lines
global mMin;
mMin = str2double( get( handles.minLength, 'String' ) );
% Gap distance to fill in lines
global mFill;
mFill = str2double( get( handles.gapFill, 'String' ) );
% Number of peks to detect when using hough
global mMaxP;
mMaxP = str2double( get( handles.maxPeaks, 'String' ) );
% Flag to show steps in line detection
global mShowSteps;
mShowSteps = 1.0;

% Update handles structure
guidata( hObject, handles );

% UIWAIT makes linesGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%uiwait( hObject );

function setLineImage( handles, image )
global mImage;
mImage = image;
imshow( mImage, 'Parent', handles.axes1 );
global mBackup;
mBackup = mImage;
% Update handles structure
guidata( hObject, handles );

% --- Outputs from this function are returned to the command line.
function varargout = linesGui_OutputFcn( hObject, eventdata, handles ) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in resetButton.
function resetButton_Callback( hObject, eventdata, handles )
global mBackup;
global mImage;

mImage = mBackup;
imshow( mImage, 'Parent', handles.axes1 );

% --- Executes on button press in linesButton.
function linesButton_Callback( hObject, eventdata, handles )

if get( handles.useHough,'Value' ) == 1
    houghLines( hObject, handles );
else
    set( handles.console, 'String', 'Other' );
    otherLines( hObject, handles );
end

function otherLines( hObject, handles )
global mImage;
global mShowSteps;
nColors = 4;
vertexResolution = 10;

image = rgb2gray( mImage );
imshow( image, 'Parent', handles.axes1 );
if mShowSteps == 1
    pause;
end
edges = edge( image, 'canny' );
imshow( edges, 'Parent', handles.axes1 );
if mShowSteps == 1
    pause;
end

% Reduce the number of colors in the image
[ img2, map ] = gray2ind( edges, nColors );

for i = 1:nColors
  layers(i) = { medfilt2( eq( img2 + 1, i ) ) };
end

subplot(1,2,2);

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
    %if(i==2)
        for k=1:shapes_in_layer
            p = patch(layers{i}{k}(:,2),-layers{i}{k}(:,1),1);

            if(i == 2)
                set(p,'FaceColor',[map(i,:)]);
                %plot(layers{2}{2}(:,2),-layers{2}{2}(:,1),'*')
                %disp(layers{2}{1})
            else
                set(p,'FaceColor',[map(i,:)]);
            end

            set(p,'EdgeColor','none');
        end
   % end    
end

guidata( hObject, handles );

function houghLines( hObject, handles )
global mImage;
global mFill;
global mMin;
global mMaxPeaks;
global mShowSteps;

%axis on, axis normal, hold on;
image = rgb2gray( mImage );
imshow( image, 'Parent', handles.axes1 );
if mShowSteps == 1
    pause;
end
edges = edge( image, 'canny' );
imshow( edges, 'Parent', handles.axes1 );
if mShowSteps == 1
    pause;
end
[H, theta, rho] = hough( edges );
imshow( H, [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit', 'Parent', handles.axes1 );
xlabel( handles.axes1, '\theta');
ylabel( handles.axes1, '\rho' );
if mShowSteps == 1
    pause;
end
peaks = houghpeaks( H, 64 );%, 'threshold', ceil( 0.3 * max( H( : ) ) ) );
x = theta( peaks( :, 2 ) ); 
y = rho( peaks( :, 1 ) );
plot( handles.axes1, x, y, 's', 'color', 'red' );
if mShowSteps == 1
    pause;
end
lines = houghlines( H, theta, rho, peaks );%, 'FillGap', mFill, 'MinLength', mMin );
imshow( mImage, 'Parent', handles.axes1 );
hold( handles.axes1 );
%hold on;
set( handles.console, 'String', length( lines ) );
for k = 1:length( lines )
    
    x1 = lines(k).point1(2);
    y1 = lines(k).point1(1);
    x2 = lines(k).point2(2);
    y2 = lines(k).point2(1);
    plot([x1 x2],[y1 y2],'Color','g','LineWidth', 4)
end
hold( handles.axes1 );

% %axes( handles.axes1 );
% for k = 1:length( lines )
%    xy = [ lines( k ).point1; lines( k ).point2 ];
%  %plot( handles.axes1, lines( k ).point1, lines( k ).point2 );
%  %line( handles.axes1, lines(k) )
%    %if k == 1
%    plot( handles.axes1, lines( k ).point1, lines( k ).point2,'LineWidth',2,'Color','green');
%    %end
%    % Plot beginnings and ends of lines
%    plot( handles.axes1, xy( 1,1 ), xy( 1,2 ), 'x', 'LineWidth', 2, 'Color', 'blue');
%    plot( handles.axes1, xy( 2,1 ), xy( 2,2 ), 'x', 'LineWidth', 2, 'Color', 'blue');
%    hold( handles.axes1 );
% end
guidata( hObject, handles );
   
% --- Executes on button press in apply.
function apply_Callback( hObject, eventdata, handles )
global mImage;

function gapFill_Callback( hObject, eventdata, handles )
global mFill;

fill = str2double( get( hObject, 'String' ) );
if isnan( fill ) || ~isreal( fill ) 
    % Restore original value
    set( hObject, 'String', mFill );
else 
    mFill = fill;
    set( hObject, 'String', mFill );
end

function minLength_Callback( hObject, eventdata, handles )
global mMin;

min = str2double( get( hObject, 'String' ) );
if isnan( min ) || ~isreal( min ) 
    % Restore original value
    set( hObject, 'String', mMin );
else 
    mMin = min;
    set( hObject, 'String', mMin );
end

function showStepsChecked_Callback( hObject, eventdata, handles )
global mShowSteps;
mShowSteps = get( hObject,'Value' );

function maxPeaks_Callback( hObject, eventdata, handles )
global mMaxPeaks;

max = str2double( get( hObject, 'String' ) );
if isnan( max ) || ~isreal( max ) 
    % Restore original value
    set( hObject, 'String', mMaxPeaks );
else 
    mMaxPeaks = max;
    set( hObject, 'String', mMaxPeaks );
end


% --------------------------------------------------------------------
function saveMenu_Callback( hObject, eventdata, handles )
[ filename, pathname ] = uiputfile( { '*.svg','Scalable Vector Graphics (*.svg)' }, 'Save figure as','../out');

%if user cancels save command, nothing happens
if isequal( filename, 0 ) || isequal( pathname, 0 )
else
    saveas( handles.axes1, fullfile( pathname, filename ) );
end