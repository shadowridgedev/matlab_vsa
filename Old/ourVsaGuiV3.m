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

% Last Modified by GUIDE v2.5 19-Nov-2017 13:31:36

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

function [inputProcessed, avg] = prepareInputSignal(input,Fs)
    input = input(:,1);
    
    [voice ,avg] = signal_preprocess(input,Fs);
    input = input .* voice;
    input(input==0) = [];
    
    %normalization of input signal
    maxIN = max(abs(input));
    input = input ./ maxIN; 
    
    inputProcessed = input;

function [gci,goi,impulseCT,impulseOT] = generateDypsaInpulses(input,Fs)
    [gci, goi] = dypsa(input, Fs);

    impulseC(gci) = 1;
    impulseCT=impulseC';
    impulseO(goi)= 1;
    impulseOT=impulseO';
 
function plotSegmentedSignal(handle,input,avg,impulseCT,impulseOT)
    psnxAx1 = subplot(3,1,1,'Parent', handle);
    psnxAx2 = subplot(3,1,2,'Parent', handle);
    psnxAx3 = subplot(3,1,3,'Parent', handle);

    axes(psnxAx1);
    cla(psnxAx1);
    plot(input),axis('tight');
    hold on;
    set(gca,'Yticklabel',[]) 
    set(gca,'Xticklabel',[]) 
    axes(psnxAx2);
    plot(impulseCT,'r'),title('GCI Impulse Signal','FontSize',8),axis('tight');
    set(gca,'Yticklabel',[]) 
    set(gca,'Xticklabel',[]) 
    axes(psnxAx3);
    plot(impulseOT,'b'),title('GOI Impulse Signal','FontSize',8),axis('tight');
    set(gca,'Yticklabel',[]) 
    
function plotOverlaySignal(handle,input,impulseCT,impulseOT)
    psonxAx1 = subplot(1,1,1,'Parent',handle);
    cla(psonxAx1);
    axes(psonxAx1);
    plot(input);
    hold on
    plot(impulseCT,'r');
    hold on
    plot(impulseOT,'b'),title('Normalized Voiced Overlay Signal','FontSize',8);
    axis('tight');

function plotImpulseDiffs(handle,impulseCTtimeInstances,firstDifference)
    pinxAx1 = subplot(2,1,1,'Parent', handle);
    pinxAx2 = subplot(2,1,2,'Parent', handle);

    axes(pinxAx1);
    subplot(2,1,1),plot(1:1:length(impulseCTtimeInstances),impulseCTtimeInstances),title('GCI Impulse Time Instances','FontSize',8);
    set(gca,'Xticklabel',[]) 

    axes(pinxAx2);
    cla(pinxAx2);
    sz = 15;
    %halfLine(1:length(firstDifference)-1) = 0.5;
    %subplot(2,1,2),plot(1:1:length(halfLine),halfLine);
    %hold on;
    subplot(2,1,2),scatter(1:1:length(firstDifference),firstDifference,sz,firstDifference,'filled'),title('Normalized GCI Diff Impulse Time Instances','FontSize',8);
    axis([-0.2 inf 0 1.2]);
    hold on;
    meanLine(1:length(firstDifference)-1) = mean(firstDifference);
    subplot(2,1,2),plot(1:1:length(meanLine),meanLine,'r','MarkerSize',1);

    
    
function jitPercentage = processAndPlot(input,Fs,handleSegmented,handleOverlay,handleImpluses,handleBoxplot)
    [input,avg] = prepareInputSignal(input,Fs);
    
    [gci,goi,impulseCT,impulseOT] = generateDypsaInpulses(input,Fs);

    plotSegmentedSignal(handleSegmented,input,avg,impulseCT,impulseOT);

    plotOverlaySignal(handleOverlay,input,impulseCT,impulseOT);

    firstDifference = abs(diff(gci));
    firstDifference = firstDifference ./ max(firstDifference);

    plotImpulseDiffs(handleImpluses,gci,firstDifference);
    
    pnbAx1 = subplot(1,1,1,'Parent', handleBoxplot);
    axes(pnbAx1);
    boxplot(firstDifference);
    
    jitPercentage = myJitter(firstDifference);

    
    
function jitNorm = processNormal(hObject, eventdata, handles, input,Fs)
    
    jitNorm = processAndPlot(input,Fs,handles.panelSegmentedNormal,handles.panelSegmentedOverlayNormal,handles.panelImpulseNormal,handles.panelNormalBoxplot);
      
function jit = myJitter(firstDiff)
    firstDiff = firstDiff ./ max(firstDiff);
    mn = mean(firstDiff);
    jit = (sum(abs(firstDiff - mn))/(length(firstDiff*0.5)))*100; 
    
function jit = jitter(firstDiff)

    secondDiff = diff(firstDiff);
    
    N = length(firstDiff);
    
    firstDifSum = sum(firstDiff);
    secDiffSum = sum(secondDiff);
    
    %jit = abs(secDiffSum/(N-1))
    jit = abs(((secDiffSum/(N-1))/(firstDifSum/N)))*100; %relative jitter 
    
% --- Executes on button press in pushbuttonRecAud.
function pushbuttonRecAud_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRecAud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    sampleRate = str2double(get(handles.editSampleRate,'String'));
    bps = str2double(get(handles.editBps,'String'));
    recTime = str2double(get(handles.editRecTime,'String'));

    recObj = audiorecorder(sampleRate, bps, 1);
    recordblocking(recObj, recTime);
    y = getaudiodata(recObj);

    Fs = sampleRate; 
    input = y(:,1);
    
    setappdata(0,'recAudioInput',input);
    setappdata(0,'recAudioFs',Fs);
    
    sound(y,Fs);
    
	jit = processNormal(hObject, eventdata, handles, input,Fs); 

	set(handles.JitText, 'String', [num2str(round(jit,2)) '%']);
    









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


% --- Executes on button press in pushbuttonDypsaTestbed.
function pushbuttonDypsaTestbed_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDypsaTestbed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

run(ourVsaGuiV2_autoread)


% --- Executes on button press in pushbuttonPlayRec.
function pushbuttonPlayRec_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlayRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[input] = getappdata(0,'recAudioInput');
Fs = getappdata(0,'recAudioFs');
sound(input,Fs);
