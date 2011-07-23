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

% Last Modified by GUIDE v2.5 22-Jul-2011 18:10:37

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
function linesGui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for linesGui
handles.output = hObject;

handles.setImage = @setLineImage;

global mMin;
mMin = 20.0;
global mFill;
mFill = 40.0;
global mMaxP;
mMaxP = 5.0;
global mShowSteps;
mShowSteps = 1.0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes linesGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%uiwait( hObject );

function setLineImage( handles, image )
global mImage;
mImage = image;
imshow( mImage, 'Parent', handles.axes1 );
global mBackup;
mBackup = mImage;

% --- Outputs from this function are returned to the command line.
function varargout = linesGui_OutputFcn(hObject, eventdata, handles) 
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
P = houghpeaks( H, 100 );%, 'threshold', ceil( 0.3 * max( H( : ) ) ) );
x = theta( P( :, 2 ) ); 
y = rho( P( :, 1 ) );
plot( handles.axes1, x, y, 's', 'color', 'white' );
if mShowSteps == 1
    pause;
end
lines = houghlines( H, theta, rho, P, 'FillGap', mFill, 'MinLength', mMin );
imshow( mImage, 'Parent', handles.axes1 );

%hold on;
for k = 1:length(lines)
    x1 = lines(k).point1(1);
    y1 = lines(k).point1(2);
    x2 = lines(k).point2(1);
    y2 = lines(k).point2(2);
    plot([x1 x2],[y1 y2],'Color','g','LineWidth', 4)
    if k == 1
        hold( handles.axes1 );
    end
%    xy = [lines(k).point1; lines(k).point2];
%    %hold( handles.axes1 );
%    plot(handles.axes1, xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(handles.axes1, xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(handles.axes1, xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
   
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


