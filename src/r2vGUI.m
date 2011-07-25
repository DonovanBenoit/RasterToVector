
function varargout = r2vGUI(varargin)
global mVarargin;
mVarargin = varargin;
% R2VGUI MATLAB code for r2vGUI.fig
%      R2VGUI, by itself, creates a new R2VGUI or raises the existing
%      singleton*.
%
%      H = R2VGUI returns the handle to a new R2VGUI or the handle to
%      the existing singleton*.
%
%      R2VGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in R2VGUI.M with the given input arguments.
%
%      R2VGUI('Property','Value',...) creates a new R2VGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before r2vGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to r2vGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help r2vGUI

% Last Modified by GUIDE v2.5 24-Jul-2011 19:35:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @r2vGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @r2vGUI_OutputFcn, ...
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

% --- Executes just before r2vGUI is made visible.
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to r2vGUI (see VARARGIN)
function r2vGUI_OpeningFcn( hObject, eventdata, handles, varargin )

% Choose default command line output for r2vGUI
handles.output = hObject;

global mImage;
global mHeight;
mHeight = 256;
global mWidth;
mWidth = 256;
mImage = zeros( mHeight, mWidth );

imshow( mImage, 'Parent', handles.axes1 );

% Update handles structure
guidata( hObject, handles );


% --- Outputs from this function are returned to the command line.
function varargout = r2vGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in polybutton
% hObject    handle to polybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function polybutton_Callback( hObject, eventdata, handles )
global mImage;

polys = toPoly( 'Polys', hObject );
polysHandle = guidata( polys );
polysHandle.setImage( polysHandle, mImage );

% Update handles structure
guidata( hObject, handles );

% --- Executes on button press in lineButton.
% hObject    handle to lineButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function lineButton_Callback( hObject, eventdata, handles )
global mImage;

lines = linesGui( 'Lines', hObject );
linesHandle = guidata( lines );
linesHandle.setImage( linesHandle, mImage );
% Update handles structure
guidata( hObject, handles );

% Create curves sub GUI and set image
function curveButton_Callback( hObject, eventdata, handles )
global mImage;

curve = curves( 'Curves', hObject );
curveHandle = guidata( curve );
curveHandle.setImage( curveHandle, mImage );
% Update handles structure
guidata( hObject, handles );

% --------------------------------------------------------------------
% hObject    handle to fileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function fileMenu_Callback( hObject, eventdata, handles )

function open_Callback( hObject, eventdata, handles )
global mImage;
global mHeight;
global mWidth;

[name, path] = uigetfile( { '*.bmp; *.png; *.jpg'; '*.*' }, 'Open Image', '../res' );
pathAndName = strcat( path, name );
if( ( length( name ) ~= 1 ) && ( length( path ) ~= 1 ) );
    info = imfinfo( pathAndName );
    mHeight = info.Height;
    mWidth = info.Width;
    mImage = imread( pathAndName );
    imshow( mImage, 'Parent', handles.axes1 );
end;
% Update handles structure
guidata( hObject, handles );


% --- Executes on button press in exportButton.
function exportButton_Callback(hObject, eventdata, handles)
% Polygons
fillColors = {'red','white'};
strokeColors = {'lime','blue'};
strokeWidths = {2,5};
points = {[0, 0, 100, 0, 100, 100, 0, 100], [50, 0, 0, 50, 100, 50]};
% Curves
paths = [{[1,0,1],[0,0,50,50],[10,10,78,95],[45,56,156,200],[50,50,100,100]};{[0.5,0.5,0.5],[45,90],[20,56],[43,67],[200,40]}];


% [
% {[r g b],startMatrix,Cont1Matrix,Cont2Matrix,endMatrix};
% {[r g b],startMatrix,Cont1Matrix,Cont2Matrix,endMatrix};
% {[r g b],startMatrix,Cont1Matrix,Cont2Matrix,endMatrix};
% ]

toSVG( fillColors, strokeColors, strokeWidths, points, paths );
