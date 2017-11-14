function varargout = GUI_selectChannels(varargin)
% GUI_SELECTCHANNELS MATLAB code for GUI_selectChannels.fig
%      GUI_SELECTCHANNELS, by itself, creates a new GUI_SELECTCHANNELS or raises the existing
%      singleton*.
%
%      H = GUI_SELECTCHANNELS returns the handle to a new GUI_SELECTCHANNELS or the handle to
%      the existing singleton*.
%
%      GUI_SELECTCHANNELS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SELECTCHANNELS.M with the given input arguments.
%
%      GUI_SELECTCHANNELS('Property','Value',...) creates a new GUI_SELECTCHANNELS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_selectChannels_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_selectChannels_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_selectChannels

% Last Modified by GUIDE v2.5 14-Nov-2017 16:15:35

% Hong Kyung, Kim
% hk_kim@korea.ac.kr

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_selectChannels_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_selectChannels_OutputFcn, ...
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


% --- Executes just before GUI_selectChannels is made visible.
function GUI_selectChannels_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_selectChannels (see VARARGIN)

% Choose default command line output for GUI_selectChannels
handles.output = hObject;

handles.scalp_ax = axes('Units','Normalized');

SMT.chan = varargin{1};
MNT = opt_getMontage(SMT);
% set(gcf,'units','normalized');
% scalp_plot(handles.scalp_ax, MNT);
center = [0 0];
theta = linspace(0,2*pi,360);

x = cos(theta)+center(1);
y = sin(theta)+center(2);
H.main = plot(x,y, 'k');
set(handles.scalp_ax, 'xTick',[], 'yTick',[]);
axis('xy', 'tight', 'equal', 'tight');
patch(handles.scalp_ax,x, y, [1 1 1]);
hold on;

axis off;

offset = get(handles.scalp_ax, 'Position');
center = [offset(1)+offset(3)/2 , offset(2)+offset(4)/2];

prop = 2.58;
chbox_size = [0.014, 0.014];


for i = 1:size(MNT.chan,2)
    handles.chbox(i) = uicontrol('Style','checkbox', 'Units', 'Normalized',...
        'Value',0,'Position',...
        [MNT.x(i)/prop+center(1)-(chbox_size(1)/2) MNT.y(i)/prop+center(2)-(chbox_size(2)/2) chbox_size(1) chbox_size(2)]);
    handles.txt(i) = uicontrol('Style','text', 'Units', 'Normalized',...
        'String', MNT.chan{i},'BackgroundColor', [1 1 1], 'Position',...
        [MNT.x(i)/prop+center(1)-(chbox_size(1)*1.4) MNT.y(i)/prop+center(2)-(chbox_size(2)*1.5) chbox_size(1)*2.8 chbox_size(2)]);
end

handles.sel_btn = uicontrol('Style', 'pushbutton', 'Units', 'Normalized',...
    'String', 'Select', 'CallBack', {@sel_btn_callback,handles, MNT}, 'Position', [0 0 1 0.05]);

handles.title = uicontrol('Style', 'edit', 'Units', 'Normalized',...
    'String', 'Select Channels', 'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [0 0.95 1 0.05], 'Enable', 'inactive', 'BackgroundColor', [1 1 1]); 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_selectChannels wait for user response (see UIRESUME)
uiwait(handles.figure1);

function sel_btn_callback(hObject, eventdata, handles, MNT)
idx = cell2mat(get(handles.chbox, 'Value'));
idx = logical(idx);
out = MNT.chan(idx);
handles.selectedChannels = out;
guidata(hObject,handles);
uiresume(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_selectChannels_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.selectedChannels;
delete(handles.figure1);
