%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: print
% File: toVectorGUI.m
% Description: Prints a string to the MATLAB console if printing is
% enabled.
% Created: June 20, 2011
% Authors: Scott Stevenson & Donovan Benoit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = toVectorGUI(varargin)
% TOVECTORGUI MATLAB code for toVectorGUI.fig
%      TOVECTORGUI, by itself, creates a new TOVECTORGUI or raises the existing
%      singleton*.
%
%      H = TOVECTORGUI returns the handle to a new TOVECTORGUI or the handle to
%      the existing singleton*.
%
%      TOVECTORGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOVECTORGUI.M with the given input arguments.
%
%      TOVECTORGUI('Property','Value',...) creates a new TOVECTORGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before toVectorGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to toVectorGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help toVectorGUI

% Last Modified by GUIDE v2.5 28-Jul-2011 15:30:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @toVectorGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @toVectorGUI_OutputFcn, ...
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


% --- Executes just before toVectorGUI is made visible.
function toVectorGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to toVectorGUI (see VARARGIN)

% Choose default command line output for toVectorGUI
handles.output = hObject;

% UIWAIT makes toVectorGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Make setImage visable
handles.setImage = @setLineImage;

% Initialize global variables
% Precentage of verticies to keep
global vertexPrecent;
vertexPrecent = str2double( get( handles.vertexPrecentage, 'String' ) );
% Number of colors to simplify the image to
global numColors;
numColors = str2double( get( handles.numColors, 'String' ) );
% The max squared error for the conversion process
global maxSquareError;
maxSquareError = str2double( get( handles.maxError, 'String' ) );
% Flag to show steps in conversion process
global mShowSteps;
mShowSteps = 1.0;
% The image to convert
global mImage;
mImage = zeros( 256, 256 );
imshow( mImage, 'Parent', handles.axes1 );
% Data structure to hold the curves model
global mCurves;
mCurves = [];
% Data structure to hold the polygon model
global mPolys;
mPolys = [];

% Update handles structure
guidata( hObject, handles );

% --- Outputs from this function are returned to the command line.
function varargout = toVectorGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Set the image to use
function setLineImage( handles, image )
global mImage;
mImage = image;
imshow( mImage, 'Parent', handles.axes1 );
global mBackup;
mBackup = mImage;
% Update handles structure
guidata( handles.axes1, handles );

% Set the flag so show the conversion steps
function showSteps_Callback( hObject, eventdata, handles )
global mShowSteps;
mShowSteps = get( hObject,'Value' );

% Set the number of colors to use 
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

% Set the precentage of vertices to keep
function vertexPrecentage_Callback(hObject, eventdata, handles)
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

% Set tha max error
function maxError_Callback(hObject, eventdata, handles)
global maxSquareError;
e = str2double( get( hObject, 'String' ) );
if isnan( e ) || ~isreal( e ) 
    % Restore original value
    set( hObject, 'String', maxSquareError );
else 
    maxSquareError = e;
    set( hObject, 'String', maxSquareError );
end
% Update handles structure
guidata( hObject, handles );

% Reset the state of the GUI
function resetButton_Callback( hObject, eventdata, handles )
global mBackup;
global mImage;
global numColors;
global vertexPrecent;
global maxSquareError;

mImage = mBackup;
imshow( mImage, 'Parent', handles.axes1 );

numColors = 5;
vertexPrecent = 10;
maxSquareError = 5;
set( handles.numColors, 'String', numColors );
set( handles.vertexPrecentage, 'String', vertexPrecent );
set( handles.maxError, 'String', maxSquareError );

% Update handles structure
guidata( hObject, handles );

% Create a polygon or curve model from the image
function polygonalize_Callback( hObject, eventdata, handles )
global mImage;
global mCurves;
global mPolys;
global numColors;
global vertexPrecent;
global mShowSteps;
global maxSquareError;
if get( handles.polyMode, 'Value' )
    mPolys = toVector( mImage, numColors, vertexPrecent, mShowSteps,'polys', maxSquareError );
    mCurves = [];
elseif get( handles.curveMode, 'Value' );
    mCurves = toVector( mImage, numColors, vertexPrecent, mShowSteps,'curves', maxSquareError );
    mPolys = [];
end
% Update handles structure
guidata( hObject, handles );

% Export the model using the SVG format
function exportButton_Callback( hObject, eventdata, handles )
global mCurves;
global mPolys;
toSVG( mPolys, mCurves );

% Find Hough lines in the image
function lineButton_Callback(hObject, eventdata, handles)
global mImage;
lines = linesGui( 'Lines', hObject );
linesHandle = guidata( lines );
linesHandle.setImage( linesHandle, mImage );
% Update handles structure
guidata( hObject, handles );

% Open and set the image to convert
function openButton_Callback(hObject, eventdata, handles)
global mImage;
[name, path] = uigetfile( { '*.bmp; *.png; *.jpg'; '*.*' }, 'Open Image', '../res' );
pathAndName = strcat( path, name );
if( ( length( name ) ~= 1 ) && ( length( path ) ~= 1 ) );
    mImage = imread( pathAndName );
    imshow( mImage, 'Parent', handles.axes1 );
end;
% Update handles structure
guidata( hObject, handles );
