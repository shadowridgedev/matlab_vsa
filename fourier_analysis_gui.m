function varargout = fourier_analysis_gui(varargin)
% FOURIER_ANALYSIS_GUI MATLAB code for fourier_analysis_gui.fig
%      FOURIER_ANALYSIS_GUI, by itself, creates a new FOURIER_ANALYSIS_GUI or raises the existing
%      singleton*.
%
%      H = FOURIER_ANALYSIS_GUI returns the handle to a new FOURIER_ANALYSIS_GUI or the handle to
%      the existing singleton*.
%
%      FOURIER_ANALYSIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOURIER_ANALYSIS_GUI.M with the given input arguments.
%
%      FOURIER_ANALYSIS_GUI('Property','Value',...) creates a new FOURIER_ANALYSIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fourier_analysis_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fourier_analysis_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fourier_analysis_gui

% Last Modified by GUIDE v2.5 17-Nov-2017 01:09:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fourier_analysis_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @fourier_analysis_gui_OutputFcn, ...
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


% --- Executes just before fourier_analysis_gui is made visible.
function fourier_analysis_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fourier_analysis_gui (see VARARGIN)

% Choose default command line output for fourier_analysis_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fourier_analysis_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

clc;

evalin( 'base', 'clear variables' );
cla(handles.voice_signal_axis,'reset');
cla(handles.fourier_axis,'reset');
set(handles.array1, 'Data', cell(size(get(handles.array1,'Data'))));
set(handles.array2, 'Data', cell(size(get(handles.array2,'Data'))));
set(handles.meanFo1,'String','');
set(handles.meanFo2,'String','');
set(handles.Fo,'String','');

fo = getappdata(0,'evalue1');
fs = getappdata(0,'evalue2');
mean_nfo = getappdata(0,'evalue3');
mean_sfo = getappdata(0,'evalue4');
y = getappdata(0,'evalue5');
temp = getappdata(0,'evalue6');
male_check = getappdata(0,'evalue7');
female_check = getappdata(0,'evalue8');
normal_fos = getappdata(0,'evalue9');
stressed_fos = getappdata(0,'evalue10');

assignin('base', 'temp', temp);
assignin('base', 'fo', fo);
assignin('base', 'fs', fs);
assignin('base', 'y', y);
assignin('base', 'mean_sfo', mean_sfo);
assignin('base', 'mean_nfo', mean_nfo);
assignin('base', 'normal_fos', normal_fos);
assignin('base', 'stressed_fos', stressed_fos);

if male_check == 1 && female_check ==0 
    set(handles.array1,'Data', stressed_fos,'ColumnName',{'Stressed Males'},'RowName',{'BREAK','CHANGE','DEGREE','DESTINATION','EAST','EIGHT','EIGHTY','ENTER','FIFTY','FIX'});
    set(handles.array2, 'Data', normal_fos,'ColumnName',{'Non-Stressed Males'},'RowName',{'BREAK','CHANGE','DEGREE','DESTINATION','EAST','EIGHT','EIGHTY','ENTER','FIFTY','FIX'});
elseif male_check == 0 && female_check == 1 
    set(handles.array1,'Data', stressed_fos,'ColumnName',{'Stressed Females'},'RowName',{'BREAK','CHANGE','DEGREE','DESTINATION','EAST','EIGHT','EIGHTY','ENTER','FIFTY','FIX'});
    set(handles.array2, 'Data', normal_fos,'ColumnName',{'Non-Stressed Females'},'RowName',{'BREAK','CHANGE','DEGREE','DESTINATION','EAST','EIGHT','EIGHTY','ENTER','FIFTY','FIX'});
end

TotalTime = length(y)./fs;
t = 0:TotalTime/(length(y)):TotalTime-TotalTime/length(y);

axes(handles.voice_signal_axis);
plot(t,y);
grid;
xlabel('Time (s)');

ydft = fft(y);
freq = 0:fs/length(y):fs/2;
ydft = ydft(1:length(y)/2+1);

axes(handles.fourier_axis);
plot(freq,abs(ydft));
grid;
xlabel('Frequency (HZ)');
xlim([0 1000]);

mean_sfo_str = strcat(num2str(round(mean_sfo)),' HZ');
set(handles.meanFo1, 'String', mean_sfo_str); 
 
mean_nfo_str = strcat(num2str(round(mean_nfo)),' HZ');
set(handles.meanFo2, 'String', mean_nfo_str);

String_Fo = strcat(num2str(round(fo)),' HZ');
set(handles.Fo, 'String', String_Fo);

temp_str = strcat(num2str(round(temp)),' HZ');
set(handles.fth, 'String', temp_str);


% --- Outputs from this function are returned to the command line.
function varargout = fourier_analysis_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in record_button.
function record_button_Callback(hObject, eventdata, handles)
% hObject    handle to record_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


   
  


% --- Executes on button press in male_check.
function male_check_Callback(hObject, eventdata, handles)
% hObject    handle to male_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of male_check


% --- Executes on button press in female_check.
function female_check_Callback(hObject, eventdata, handles)
% hObject    handle to female_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of female_check


% --- Executes on button press in next_window.
function next_window_Callback(hObject, eventdata, handles)
% hObject    handle to next_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


close(fourier_analysis_gui);
run (ourVsaGuiV2);


% --- Executes on button press in get_data.
function get_data_Callback(hObject, eventdata, handles)
% hObject    handle to get_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
