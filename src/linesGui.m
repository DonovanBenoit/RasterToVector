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

% Last Modified by GUIDE v2.5 25-Jul-2011 10:56:49

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
%guidata( hObject, handles );

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
guidata( hObject, handles );

% --- Executes on button press in linesButton.
function linesButton_Callback( hObject, eventdata, handles )
houghLines( hObject, handles );

% Find lines in the image using the Hough Transform Method
function houghLines( hObject, handles )
global mImage;
global mFill;
global mMin;
global mShowSteps;
% Convert to grayscale
image = rgb2gray( mImage );
imshow( image, 'Parent', handles.axes1 );
if mShowSteps == 1
    pause;
end
% Find Edges
edges = edge( image, 'canny' );
imshow( edges, 'Parent', handles.axes1 );
if mShowSteps == 1
    pause;
end
% Standard Hough Transform
[H, theta, rho] = hough( edges );
imshow( H, [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit', 'Parent', handles.axes1 );
xlabel( handles.axes1, '\theta');
ylabel( handles.axes1, '\rho' );
if mShowSteps == 1
    pause;
end
% Find the Hough Peaks
peaks = houghpeaks( H, 500, 'threshold', ceil( 0.3 * max( H( : ) ) ) );
x = theta( peaks( :, 2 ) ); 
y = rho( peaks( :, 1 ) );
plot( handles.axes1, x, y, 's', 'color', 'red' );
if mShowSteps == 1
    pause;
end
% Find the Hough Lines
lines = houghlines( H, theta, rho, peaks, 'FillGap', mFill, 'MinLength', mMin );
imshow( mImage, 'Parent', handles.axes1 );
hold( handles.axes1 );
for k = 1:length( lines )
    x1 = lines(k).point1(2);
    y1 = lines(k).point1(1);
    x2 = lines(k).point2(2);
    y2 = lines(k).point2(1);
    plot([x1 x2],[y1 y2],'Color','g','LineWidth', 4)
end
hold( handles.axes1 );
guidata( hObject, handles );
   

% Set the gap distance to fill
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
guidata( hObject, handles );

% Set the minimum length for lines
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
guidata( hObject, handles );

% Toggle flag to display steps
function showStepsChecked_Callback( hObject, eventdata, handles )
global mShowSteps;
mShowSteps = get( hObject,'Value' );
