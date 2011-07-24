function varargout = toPoly(varargin)
% TOPOLY MATLAB code for toPoly.fig
%      TOPOLY, by itself, creates a new TOPOLY or raises the existing
%      singleton*.
%
%      H = TOPOLY returns the handle to a new TOPOLY or the handle to
%      the existing singleton*.
%
%      TOPOLY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOPOLY.M with the given input arguments.
%
%      TOPOLY('Property','Value',...) creates a new TOPOLY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before toPoly_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to toPoly_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help toPoly

% Last Modified by GUIDE v2.5 23-Jul-2011 21:58:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @toPoly_OpeningFcn, ...
                   'gui_OutputFcn',  @toPoly_OutputFcn, ...
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


% --- Executes just before toPoly is made visible.
function toPoly_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to toPoly (see VARARGIN)

% Choose default command line output for toPoly
handles.output = hObject;

% UIWAIT makes toPoly wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Make setImage visable
handles.setImage = @setLineImage;

% Initialize global variables
% Precentage of verticies to keep
global vertexPrecent;
vertexPrecent = str2double( get( handles.vertexPrecent, 'String' ) );
global numColors;
numColors = str2double( get( handles.numColors, 'String' ) );

% Update handles structure
guidata( hObject, handles );

% --- Outputs from this function are returned to the command line.
function varargout = toPoly_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function setLineImage( handles, image )
global mImage;
mImage = image;
imshow( mImage, 'Parent', handles.axes1 );
global mBackup;
mBackup = mImage;

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function numColors_Callback( hObject, eventdata, handles )
global numColors;

num = str2double( get( hObject, 'String' ) );
if isnan( num ) || ~isreal( num ) 
    % Restore original value
    set( hObject, 'String', numColors );
else 
    numColors = num;
    set( hObject, 'String', numColors );
end

% Update handles structure
guidata( hObject, handles );

function vertexPrecent_Callback(hObject, eventdata, handles)
global vertexPrecent;

v = str2double( get( hObject, 'String' ) );
if isnan( v ) || ~isreal( v ) 
    % Restore original value
    set( hObject, 'String', vertexPrecent );
else 
    vertexPrecent = v;
    set( hObject, 'String', vertexPrecent );
end

% Update handles structure
guidata( hObject, handles );

% --- Executes on button press in resetButton.
function resetButton_Callback( hObject, eventdata, handles )
global mBackup;
global mImage;
global numColors;
global vertexPrecent;

mImage = mBackup;
imshow( mImage, 'Parent', handles.axes1 );

numColors = 5;
vertexPrecent = 10;
set( handles.numColors, 'String', numColors );
set( handles.vertexPrecent, 'String', vertexPrecent );

% Update handles structure
guidata( hObject, handles );

% --- Executes on button press in polygonalize.
function polygonalize_Callback( hObject, eventdata, handles )
global mImage;
global numColors;
global vertexPrecent;

ToPolys( mImage, numColors, vertexPrecent );

% Update handles structure
guidata( hObject, handles );

% --- Executes on button press in applyButton.
function applyButton_Callback(hObject, eventdata, handles)
%dosent do anything 