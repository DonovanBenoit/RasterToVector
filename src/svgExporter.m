function varargout = svgExporter(varargin)
% SVGEXPORTER MATLAB code for svgExporter.fig
%      SVGEXPORTER, by itself, creates a new SVGEXPORTER or raises the existing
%      singleton*.
%
%      H = SVGEXPORTER returns the handle to a new SVGEXPORTER or the handle to
%      the existing singleton*.
%
%      SVGEXPORTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVGEXPORTER.M with the given input arguments.
%
%      SVGEXPORTER('Property','Value',...) creates a new SVGEXPORTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svgExporter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svgExporter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svgExporter

% Last Modified by GUIDE v2.5 24-Jul-2011 19:17:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @svgExporter_OpeningFcn, ...
                   'gui_OutputFcn',  @svgExporter_OutputFcn, ...
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


% --- Executes just before svgExporter is made visible.
function svgExporter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to svgExporter (see VARARGIN)

% Choose default command line output for svgExporter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes svgExporter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = svgExporter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in exportButton.
function exportButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
