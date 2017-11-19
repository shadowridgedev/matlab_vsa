% Dypsa Analysis Testbed
% 
%     Author: Odysseas Economides
%     Date: 19.11.2017
%
%     Description: Select Normal and Stressed folder with voice samples to
%     compare and optimise signal's jitter calculation 
% 


function varargout = ourVsaGuiV2_autoread(varargin)
% OURVSAGUIV2_AUTOREAD MATLAB code for ourVsaGuiV2_autoread.fig
%      OURVSAGUIV2_AUTOREAD, by itself, creates a new OURVSAGUIV2_AUTOREAD or raises the existing
%      singleton*.
%
%      H = OURVSAGUIV2_AUTOREAD returns the handle to a new OURVSAGUIV2_AUTOREAD or the handle to
%      the existing singleton*.
%
%      OURVSAGUIV2_AUTOREAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OURVSAGUIV2_AUTOREAD.M with the given input arguments.
%
%      OURVSAGUIV2_AUTOREAD('Property','Value',...) creates a new OURVSAGUIV2_AUTOREAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ourVsaGuiV2_autoread_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ourVsaGuiV2_autoread_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ourVsaGuiV2_autoread

% Last Modified by GUIDE v2.5 19-Nov-2017 14:52:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ourVsaGuiV2_autoread_OpeningFcn, ...
                   'gui_OutputFcn',  @ourVsaGuiV2_autoread_OutputFcn, ...
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


% --- Executes just before ourVsaGuiV2_autoread is made visible.
function ourVsaGuiV2_autoread_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ourVsaGuiV2_autoread (see VARARGIN)

% Choose default command line output for ourVsaGuiV2_autoread
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ourVsaGuiV2_autoread wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ourVsaGuiV2_autoread_OutputFcn(hObject, eventdata, handles) 
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
    input = input ./ max(abs(input));
    
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
    set(gca,'Yticklabel',[]) 
    set(gca,'Xticklabel',[]) 
    axis([0 inf -1 1]);
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
    axis([0 inf -0.2 1.2]);
    hold on;
    meanLine(1:length(firstDifference)-1) = mean(firstDifference);
    subplot(2,1,2),plot(1:1:length(meanLine),meanLine,'r','MarkerSize',1);

    
    
function jitPercentage = processAndPlot(file,handleSegmented,handleOverlay,handleImpluses,handleBoxplot,handleTextJitter)
    [input,Fs] = audioread(file);

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
    
    set(handleTextJitter, 'String', [num2str(round(jitPercentage,2)) '%']);
 

    
    
    
function jitNorm = processNormal(hObject, eventdata, handles, file)
    
    jitNorm = processAndPlot(file,handles.panelSegmentedNormal,handles.panelSegmentedOverlayNormal,handles.panelImpulseNormal,handles.panelNormalBoxplot, handles.textJitterNormal);
      
function jit = myJitter(firstDiff)
    firstDiff = firstDiff ./ max(firstDiff);
    mn = mean(firstDiff);
    jit = (sum(abs(firstDiff - mn))/(length(firstDiff*0.5)))*100;
    
function jit = jitter(firstDiff)
    secondDiff = diff(firstDiff);
    
    N = length(firstDiff);
    
    firstDifSum = sum(firstDiff);
    secDiffSum = sum(secondDiff);
    
    jit = abs(((secDiffSum/(N-1))/(firstDifSum/N)))*100; %relative jitter
    
function processAndPlotLoop(hObject,eventdata,handles,mode,handleTable,files,path,handleJitBoxplot,handleMeanJit)
	set(handleTable, 'Data', {});

    jits = zeros(1,length(files));

    for n = 1:length(files)
        word = files{n};
        strcat(path,word);
        
        if strcmp(mode,'normal') == 1
            jit = processNormal(hObject, eventdata, handles, strcat(path,word)); 
        elseif strcmp(mode,'stressed') == 1
            jit = processStressed(hObject, eventdata, handles, strcat(path,word));     
        end
            
        jits(n) = jit;

        %set(handleJitText, 'String', [num2str(round(jit,2)) '%']);

        data=get(handleTable, 'data');
        %data(end+1,:)={[word ' ' num2str(round(jit,2))]}; %if data is a cell or 
        
        data(end+1,1)={strcat(path,word)};
        data(end,2)={num2str(round(jit,2))};
        
        set(handleTable, 'data', data,'ColumnWidth',{200});

        %pause(0.02);
    end

        pjbnAx1 = subplot(1,1,1,'Parent', handleJitBoxplot);
        axes(pjbnAx1);
        boxplot(jits);
        
       if strcmp(mode,'normal') == 1
            setappdata(0,'normalJits',jits); 
        elseif strcmp(mode,'stressed') == 1
             setappdata(0,'stressedJits',jits);      
        end
        
        set(handleMeanJit, 'String', ['MEAN ' num2str(round(mean(jits),2)) '%']);
        
        
 


%saved_name = strcat(name,'_fos.m');
%dlmwrite(saved_name,fos);


%processNormal(hObject, eventdata, handles)
%processStressed(hObject, eventdata, handles)



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


    
function jitStr = processStressed(hObject, eventdata, handles, file)

	jitStr = processAndPlot(file,handles.panelSegmentedStressed,handles.panelSegmentedOverlayStressed,handles.panelImpulseStressed,handles.panelStressedBoxplot,handles.textJitterStressed);

    
    
% --- Executes on button press in pushbuttonNormal.
function pushbuttonNormal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonNormal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%folder_name=uigetdir(path);
folder_name='normal';
files = dir(fullfile(folder_name,'*.wav'));
files = {files.name};
[filpath,name,ext] = fileparts(folder_name);
audios_name = strcat(name,'/');

processAndPlotLoop(hObject,eventdata,handles,'normal',handles.uitableJitNorm,files,audios_name,handles.uipanelJitBoxplotNormal,handles.textMeanJitNormal);

       


% --- Executes on button press in pushbuttonStressed.
function pushbuttonStressed_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStressed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%folder_name=uigetdir(path);
folder_name='stressed';
files = dir(fullfile(folder_name,'*.wav'));
files = {files.name};
[filpath,name,ext] = fileparts(folder_name);
audios_name = strcat(name,'/');

processAndPlotLoop(hObject,eventdata,handles,'stressed',handles.uitableStressed,files,audios_name,handles.uipanelJitBoxplotStressed,handles.textMeanJitStressed);



% --- Executes on button press in pushbuttonProcessData.
function pushbuttonProcessData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonProcessData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbuttonNormal_Callback(hObject, eventdata, handles) ; 
pushbuttonStressed_Callback(hObject, eventdata, handles);

%myicon = imread('Cofee.jpeg');
%h=msgbox('Here is you cofee!','Success','custom',myicon);
    



% --- Executes when selected cell(s) is changed in uitableJitNorm.
function uitableJitNorm_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitableJitNorm (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

data=get(handles.uitableJitNorm, 'data');

if ~isempty(eventdata.Indices)&&~isempty(data)
    handles.currentCell=eventdata.Indices;
    guidata(hObject,handles);
    Indices=handles.currentCell;
    data=get(handles.uitableJitNorm,'Data');
    data=data(Indices(1),Indices(2))
    processNormal(hObject, eventdata, handles, data{1}); 
 end


% --- Executes when selected cell(s) is changed in uitableStressed.
function uitableStressed_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitableStressed (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

data=get(handles.uitableStressed, 'data');

if ~isempty(eventdata.Indices)&&~isempty(data)
    handles.currentCell=eventdata.Indices;
    guidata(hObject,handles);
    Indices=handles.currentCell;
    data=get(handles.uitableStressed,'Data');
    data=data(Indices(1),Indices(2))
    processStressed(hObject, eventdata, handles, data{1}); 
 end
