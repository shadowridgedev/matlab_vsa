function varargout = gui_429(varargin)
% GUI_429 MATLAB code for gui_429.fig
%      GUI_429, by itself, creates a new GUI_429 or raises the existing
%      singleton*.
%
%      H = GUI_429 returns the handle to a new GUI_429 or the handle to
%      the existing singleton*.
%
%      GUI_429('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_429.M with the given input arguments.
%
%      GUI_429('Property','Value',...) creates a new GUI_429 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_429_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_429_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_429

% Last Modified by GUIDE v2.5 16-Nov-2017 20:49:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_429_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_429_OutputFcn, ...
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


% --- Executes just before gui_429 is made visible.
function gui_429_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_429 (see VARARGIN)

% Choose default command line output for gui_429
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_429 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_429_OutputFcn(hObject, eventdata, handles) 
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

clc;
evalin( 'base', 'clear variables' );
cla(handles.voice_signal_axis,'reset');
cla(handles.fourier_axis,'reset');
set(handles.array1, 'Data', cell(size(get(handles.array1,'Data'))));
set(handles.array2, 'Data', cell(size(get(handles.array2,'Data'))));

set(handles.meanFo1,'String','');
set(handles.meanFo2,'String','');
set(handles.Fo,'String','');

empty=1;
male_check = get(handles.male_check, 'Value');
female_check = get(handles.female_check, 'Value');

while empty == 1

    if male_check == 1 && female_check ==0 
        disp('Proper selection Males');
        Stressed_Male_fos = dlmread ('StressedMale_fos.m'); 
        Normal_Male_fos = dlmread ('NormalMale_fos.m'); 
        empty = 0;
        assignin('base', 'Stressed_Male_fos', Stressed_Male_fos);
        assignin('base', 'Normal_Male_fos', Normal_Male_fos);
        set(handles.array1,'Data', Stressed_Male_fos,'ColumnName',{'Stressed Males'},'RowName',{'BREAK','CHANGE','DEGREE','DESTINATION','EAST','EIGHT','EIGHTY','ENTER','FIFTY','FIX'});
        set(handles.array2, 'Data', Normal_Male_fos,'ColumnName',{'Non-Stressed Males'},'RowName',{'BREAK','CHANGE','DEGREE','DESTINATION','EAST','EIGHT','EIGHTY','ENTER','FIFTY','FIX'});

        mean_sfo = mean(Stressed_Male_fos);
        mean_nfo = mean(Normal_Male_fos);
        assignin('base', 'mean_sfo', mean_sfo);
        assignin('base', 'mean_nfo', mean_nfo);

    elseif male_check == 0 && female_check == 1
        disp('Proper selection Females');
        Stressed_Female_fos = dlmread ('StressedFemale_fos.m'); 
        Normal_Female_fos = dlmread ('NormalFemale_fos.m'); 
        empty = 0;
        assignin('base', 'Stressed_Female_fos', Stressed_Female_fos);
        assignin('base', 'Normal_Female_fos', Normal_Female_fos);
        set(handles.array1,'Data', Stressed_Female_fos,'ColumnName',{'Stressed Females'},'RowName',{'BREAK','CHANGE','DEGREE','DESTINATION','EAST','EIGHT','EIGHTY','ENTER','FIFTY','FIX'});
        set(handles.array2, 'Data', Normal_Female_fos,'ColumnName',{'Non-Stressed Females'},'RowName',{'BREAK','CHANGE','DEGREE','DESTINATION','EAST','EIGHT','EIGHTY','ENTER','FIFTY','FIX'});

        mean_sfo = mean(Stressed_Female_fos);
        mean_nfo = mean(Normal_Female_fos);
        assignin('base', 'mean_sfo', mean_sfo);
        assignin('base', 'mean_nfo', mean_nfo);

    else
        e = msgbox('Please type MALE or FEMALE in the textbox before pressing the record buttton', 'Error','error');
        return;
    end
end

mean_sfo_str = strcat(num2str(mean_sfo),' HZ');
set(handles.meanFo1, 'String', mean_sfo_str); 
mean_nfo_str = strcat(num2str(mean_nfo),' HZ');
set(handles.meanFo2, 'String', mean_nfo_str);

recObj = audiorecorder;
set(handles.rec_msg, 'String', 'Recording has started...');
recordblocking(recObj, 3);
set(handles.rec_msg, 'String', 'Recording finished!');

y = getaudiodata(recObj);
fs=8000;

TotalTime = length(y)./fs;
t = 0:TotalTime/(length(y)):TotalTime-TotalTime/length(y);

axes(handles.voice_signal_axis);
plot(t,y);

ydft = fft(y);
freq = 0:fs/length(y):fs/2;
ydft = ydft(1:length(y)/2+1);

axes(handles.fourier_axis);
plot(freq,abs(ydft));
xlim([0 1000]);

[maxval,idx] = max(abs(ydft));
fo = freq(idx);
assignin('base', 'fo',fo);

String_Fo = strcat(num2str(round(freq(idx))),' HZ')
set(handles.Fo, 'String', String_Fo);


temp = (mean_sfo + mean_nfo)/2;
assignin('base', 'temp',temp);

if fo > temp
    disp('Non_Stressed');
else
    disp('Stressed');
end
   
  


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
