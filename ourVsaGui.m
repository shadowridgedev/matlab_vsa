function varargout = ourVsaGui(varargin)
% OURVSAGUI MATLAB code for ourVsaGui.fig
%      OURVSAGUI, by itself, creates a new OURVSAGUI or raises the existing
%      singleton*.
%
%      H = OURVSAGUI returns the handle to a new OURVSAGUI or the handle to
%      the existing singleton*.
%
%      OURVSAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OURVSAGUI.M with the given input arguments.
%
%      OURVSAGUI('Property','Value',...) creates a new OURVSAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ourVsaGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ourVsaGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ourVsaGui

% Last Modified by GUIDE v2.5 12-Nov-2017 21:54:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ourVsaGui_OpeningFcn, ...
                   'gui_OutputFcn',  @ourVsaGui_OutputFcn, ...
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


% --- Executes just before ourVsaGui is made visible.
function ourVsaGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ourVsaGui (see VARARGIN)

% Choose default command line output for ourVsaGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ourVsaGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ourVsaGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonRecAud.
function pushbuttonRecAud_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRecAud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sampleRate = str2double(get(handles.editSampleRate,'String'));
bps = str2double(get(handles.editBps,'String'));
recTime = str2double(get(handles.editRecTime,'String'));

%recObj = audiorecorder(sampleRate, bps, 1);
%recordblocking(recObj, recTime);
%y = getaudiodata(recObj);

% [y,Fs] = audioread('bird.wav');
% TotalTime = length(y)./Fs;
% t = 0:TotalTime/(length(y)):TotalTime-TotalTime/length(y);
% 
% axes(handles.axesAudio);
% plot(t,y);
% 
% 
% ydft = fft(y);
% freq = 0:Fs/length(y):Fs/2;
% ydft = ydft(1:length(y)/2+1);  
% 
% axes(handles.axesFFT);
% plot(freq,abs(ydft));
% 
% [maxval,idx] = max(abs(ydft));
% freq(idx);  %this is frequency corresponding to max value
% 
% %set(handles.textFund, 'String', 'asd');
% fundStr = strcat(num2str(round(freq(idx))),' HZ')
% set(handles.textFund, 'String', fundStr);

for n = 1:8
    [y,Fs] = audioread(strcat('normal/',num2str(n),'.wav'));
    TotalTime = length(y)./Fs;
    t = 0:TotalTime/(length(y)):TotalTime-TotalTime/length(y);

    axes(handles.axesAudio);
    plot(t,y);


    ydft = fft(y);
    freq = 0:Fs/length(y):Fs/2;
    ydft = ydft(1:length(y)/2+1);  

    axes(handles.axesFFT);
    plot(freq,abs(ydft));
    xlim([0 1000]);

    [maxval,idx] = max(abs(ydft));
    freq(idx);  %this is frequency corresponding to max value

    %set(handles.textFund, 'String', 'asd');
    fundStr = strcat(num2str(round(freq(idx))),' HZ')
    set(handles.textFund, 'String', fundStr);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [y,Fs] = audioread(strcat('stressed/',num2str(n),'.wav'));
    TotalTime = length(y)./Fs;
    t = 0:TotalTime/(length(y)):TotalTime-TotalTime/length(y);

    axes(handles.axesAudioStr);
    plot(t,y);


    ydft = fft(y);
    freq = 0:Fs/length(y):Fs/2;
    ydft = ydft(1:length(y)/2+1);  

    axes(handles.axesFFTstr);
    plot(freq,abs(ydft));
    xlim([0 1000]);

    [maxval,idx] = max(abs(ydft));
    freq(idx);  %this is frequency corresponding to max value

    %set(handles.textFund, 'String', 'asd');
    fundStr = strcat(num2str(round(freq(idx))),' HZ')
    set(handles.textFundStr, 'String', fundStr);
    
    
    pause(5)
end






function editSampleRate_Callback(hObject, eventdata, handles)
% hObject    handle to editSampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSampleRate as text
%        str2double(get(hObject,'String')) returns contents of editSampleRate as a double


% --- Executes during object creation, after setting all properties.
function editSampleRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBps_Callback(hObject, eventdata, handles)
% hObject    handle to editBps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBps as text
%        str2double(get(hObject,'String')) returns contents of editBps as a double


% --- Executes during object creation, after setting all properties.
function editBps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRecTime_Callback(hObject, eventdata, handles)
% hObject    handle to editRecTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRecTime as text
%        str2double(get(hObject,'String')) returns contents of editRecTime as a double


% --- Executes during object creation, after setting all properties.
function editRecTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRecTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
