function varargout = ourVsaGuiV3(varargin)
% OURVSAGUIV3 MATLAB code for ourVsaGuiV3.fig
%      OURVSAGUIV3, by itself, creates a new OURVSAGUIV3 or raises the existing
%      singleton*.
%
%      H = OURVSAGUIV3 returns the handle to a new OURVSAGUIV3 or the handle to
%      the existing singleton*.
%
%      OURVSAGUIV3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OURVSAGUIV3.M with the given input arguments.
%
%      OURVSAGUIV3('Property','Value',...) creates a new OURVSAGUIV3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ourVsaGuiV3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ourVsaGuiV3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ourVsaGuiV3

% Last Modified by GUIDE v2.5 16-Nov-2017 19:18:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ourVsaGuiV3_OpeningFcn, ...
                   'gui_OutputFcn',  @ourVsaGuiV3_OutputFcn, ...
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


% --- Executes just before ourVsaGuiV3 is made visible.
function ourVsaGuiV3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ourVsaGuiV3 (see VARARGIN)

% Choose default command line output for ourVsaGuiV3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ourVsaGuiV3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ourVsaGuiV3_OutputFcn(hObject, eventdata, handles) 
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

    [input, Fs] = audioread('recordings/1.wav');
    input = input(:,1);

    [gci, goi] = dypsa(input, Fs);

    impulseC(gci) = 1;
    impulseCT=impulseC';
    impulseO(goi)= 1;
    impulseOT=impulseO';

    psnxAx1 = subplot(3,1,1,'Parent', handles.panelSegmentedNormal);
    psnxAx2 = subplot(3,1,2,'Parent', handles.panelSegmentedNormal);
    psnxAx3 = subplot(3,1,3,'Parent', handles.panelSegmentedNormal);

    axes(psnxAx1);
    plot(input),axis('tight');
    set(gca,'Yticklabel',[]) 
    set(gca,'Xticklabel',[]) 
    axis('tight');
    
    axes(psnxAx2);
    plot(impulseCT,'r'),title('Impulse Signal, based on GCI','FontSize',8),axis('tight');
    set(gca,'Yticklabel',[]) 
    set(gca,'Xticklabel',[]) 
    axis('tight');
    
    axes(psnxAx3);
    plot(impulseOT,'b'),title('Impulse Signal, based on GOI','FontSize',8),axis('tight');
    set(gca,'Yticklabel',[]) 
    axis('tight');
    
    psonxAx1 = subplot(1,1,1,'Parent', handles.panelSegmentedOverlayNormal);
    axes(psonxAx1);
    plot(input);
    hold on
    plot(impulseCT,'r');
    hold on
    plot(impulseOT,'b'),title('Voiced Overlay Signal','FontSize',8);
    axis('tight');


    N = length(impulseCT);
    impulseCTtimeInstances = zeros(1,N);
    c=1;
    for n = 1:N
        if impulseCT(n) ~= 0
            impulseCTtimeInstances(c) = n;
            c = c+1;
        end
    end

    impulseCTtimeInstances(impulseCTtimeInstances==0) = [];

    pinxAx1 = subplot(2,1,1,'Parent', handles.panelImpulseNormal);
    pinxAx2 = subplot(2,1,2,'Parent', handles.panelImpulseNormal);

    axes(pinxAx1);
    subplot(2,1,1),plot(1:1:length(impulseCTtimeInstances),impulseCTtimeInstances),title('Impulse Time Instances, GCI','FontSize',8);
    set(gca,'Xticklabel',[]) 

    difference = diff(impulseCTtimeInstances);

    axes(pinxAx2);
    sz = 15;
    subplot(2,1,2),scatter(1:1:length(difference),difference,sz,difference,'filled'),title('Diff Impulse Time Instances, GCI','FontSize',8);


    









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
