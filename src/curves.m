function varargout = curves(varargin)
% CURVES MATLAB code for curves.fig
%      CURVES, by itself, creates a new CURVES or raises the existing
%      singleton*.
%
%      H = CURVES returns the handle to a new CURVES or the handle to
%      the existing singleton*.
%
%      CURVES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CURVES.M with the given input arguments.
%
%      CURVES('Property','Value',...) creates a new CURVES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before curves_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to curves_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help curves

% Last Modified by GUIDE v2.5 24-Jul-2011 15:18:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @curves_OpeningFcn, ...
                   'gui_OutputFcn',  @curves_OutputFcn, ...
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


% --- Executes just before curves is made visible.
function curves_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to curves (see VARARGIN)

% Choose default command line output for curves
handles.output = hObject;

% Make setImage visable
handles.setImage = @setLineImage;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes curves wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function setLineImage( handles, image )
global mImage;
mImage = image;
imshow( mImage, 'Parent', handles.axes1 );
global mBackup;
mBackup = mImage;
% Update handles structure
guidata( hObject, handles );

% --- Outputs from this function are returned to the command line.
function varargout = curves_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
global mBackup;
global mImage;

mImage = mBackup;
imshow( mImage, 'Parent', handles.axes1 );
% Update handles structure
guidata( hObject, handles );

% --- Executes on button press in findCurves.
function findCurves_Callback(hObject, eventdata, handles)


% --- Executes on button press in applyButton.
function applyButton_Callback(hObject, eventdata, handles)
