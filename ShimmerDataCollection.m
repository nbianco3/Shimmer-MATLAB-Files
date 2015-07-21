function varargout = ShimmerDataCollection(varargin)
% SHIMMERDATACOLLECTION MATLAB code for ShimmerDataCollection.fig
%      SHIMMERDATACOLLECTION, by itself, creates a new SHIMMERDATACOLLECTION or raises the existing
%      singleton*.
%
%      H = SHIMMERDATACOLLECTION returns the handle to a new SHIMMERDATACOLLECTION or the handle to
%      the existing singleton*.
%
%      SHIMMERDATACOLLECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHIMMERDATACOLLECTION.M with the given input arguments.
%
%      SHIMMERDATACOLLECTION('Property','Value',...) creates a new SHIMMERDATACOLLECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ShimmerDataCollection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ShimmerDataCollection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ShimmerDataCollection

% Last Modified by GUIDE v2.5 23-Jun-2015 15:31:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ShimmerDataCollection_OpeningFcn, ...
                   'gui_OutputFcn',  @ShimmerDataCollection_OutputFcn, ...
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

%% GUI functions

% --- Executes just before ShimmerDataCollection is made visible.
function ShimmerDataCollection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ShimmerDataCollection (see VARARGIN)

% Choose default command line output for ShimmerDataCollection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ShimmerDataCollection wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ShimmerDataCollection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Select data collection mode
function modemenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns modemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modemenu
function modemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Connect/Disconnect Shimmers, Start/Stop Recording
function connectbutton_Callback(hObject, eventdata, handles)
    % Retrieve handles
    handles = guihandles(gcbo);
    
    % Get trial name
    trialnameObject = handles.trialname;
    trialname = get(trialnameObject,'String');
    
    % Assign variables to handles
    modes_h = handles.defaultmodes;
    start_h = handles.startbutton;
    stop_h = handles.stopbutton;
    disconnect_h = handles.disconnectbutton;
    emgrate_h = handles.emgratemenu;
    emgresolution_h = handles.emgresolutionmenu;
    emggain_h = handles.emggainmenu;
    gsrrange_h = handles.gsrrangemenu;
    lownoise_h = handles.lownoiseaccelcheckbox;
    widerange_h = handles.widerangeaccelcheckbox;
    accelrange_h = handles.accelrangemenu;
    gyrorange_h = handles.gyrorangemenu;
    magrange_h = handles.magrangemenu;
    accelrate_h = handles.accelratemenu;
    gyrorate_h = handles.gyroratemenu;
    magrate_h = handles.magratemenu; 
    baudrate_h = handles.baudratemenu;
    samprate_h = handles.samprate;
    sampratebool_h = handles.sampratebool;
    pressure_h = handles.pressurecheckbox;
    pressureresolution_h = handles.pressuremenu;
    params_h = handles.setparams;
    elapsedtime_h = handles.elapsedtime;
    enable2BD1_h = handles.enable2BD1;
    enable3A45_h = handles.enable3A45;
    enable399C_h = handles.enable399C;
    enable3A1E_h = handles.enable3A1E;
    enable39F8_h = handles.enable39F8;
    enable2BFD_h = handles.enable2BFD;
    enable38F5_h = handles.enable38F5;
    emg2_h = handles.emg2;
    emg3_h = handles.emg3;
    emg4_h = handles.emg4;
    emg5_h = handles.emg5;
    imu1_h = handles.imu1;
    imu2_h = handles.imu2;
    imu3_h = handles.imu3;
    imu4_h = handles.imu4;
    imu5_h = handles.imu5;
    imu6_h = handles.imu6;
    imu7_h = handles.imu7;
    gsr_h = handles.gsrcheckbox;
    plot1_h = handles.plot1;
    plot2_h = handles.plot2;
    plot3_h = handles.plot3;
    plot4_h = handles.plot4;
    plot5_h = handles.plot5;
    plot6_h = handles.plot6;
    plot7_h = handles.plot7;
    
    % Set defaults
    set(start_h,'Value',0)
    set(stop_h,'Value',0)
    set(disconnect_h,'Value',0)
    set(emgrate_h,'Value',1)
    set(emgresolution_h,'Value',1)
    set(emggain_h,'Value',1)
    set(gsrrange_h,'Value',1)
    set(lownoise_h,'Value',1)
    set(widerange_h,'Value',0)
    set(accelrange_h,'Value',1)
    set(gyrorange_h,'Value',1)
    set(magrange_h,'Value',1)
    set(accelrate_h,'Value',1)
    set(gyrorate_h,'Value',1)
    set(magrate_h,'Value',1)
    set(baudrate_h,'Value',1)
    set(sampratebool_h,'Value',0)
    set(samprate_h,'Value',1)
    set(pressure_h,'Value',0)
    set(pressureresolution_h,'Value',1)
    set(params_h,'Value',0)
    set(elapsedtime_h,'String',0)
    set(enable2BD1_h,'Value',0)
    set(enable3A45_h,'Value',0)
    set(enable399C_h,'Value',0)
    set(enable3A1E_h,'Value',0)
    set(enable39F8_h,'Value',0)
    set(enable2BFD_h,'Value',0)
    set(enable38F5_h,'Value',0)
    set(imu1_h,'Value',0)
    set(imu2_h,'Value',0)
    set(imu3_h,'Value',0)
    set(imu4_h,'Value',0)
    set(imu5_h,'Value',0)
    set(imu6_h,'Value',0)
    set(imu7_h,'Value',0)
    set(emg2_h,'Value',0)
    set(emg3_h,'Value',0)
    set(emg4_h,'Value',0)
    set(emg5_h,'Value',0)
    set(gsr_h,'Value',0)
    set(plot1_h,'Value',0)
    set(plot2_h,'Value',0)
    set(plot3_h,'Value',0)
    set(plot4_h,'Value',0)
    set(plot5_h,'Value',0)
    set(plot6_h,'Value',0)
    set(plot7_h,'Value',0)
    
    contents = cellstr(get(modes_h,'String'));
    switch contents{get(modes_h,'Value')}
        case 'IMU'
            set(enable2BD1_h,'Value',1)
            set(enable3A45_h,'Value',1)
            set(enable399C_h,'Value',1)
            set(enable3A1E_h,'Value',1)
            set(enable39F8_h,'Value',1)
            set(enable2BFD_h,'Value',1)
            set(enable38F5_h,'Value',0)
            set(imu1_h,'Value',1)
            set(imu2_h,'Value',1)
            set(imu3_h,'Value',1)
            set(imu4_h,'Value',1)
            set(imu5_h,'Value',1)
            set(imu6_h,'Value',1)
            set(imu7_h,'Value',1)
        case 'EMG'
            set(enable3A45_h,'Value',1)
            set(enable399C_h,'Value',1)
            set(enable3A1E_h,'Value',1)
            set(enable39F8_h,'Value',1)
            set(emg2_h,'Value',1)
            set(emg3_h,'Value',1)
            set(emg4_h,'Value',1)
            set(emg5_h,'Value',1)
        case 'GSR'
            set(enable2BFD_h,'Value',1)
            set(gsr_h,'Value',1)
        case 'IMU+GSR'
            set(enable2BD1_h,'Value',1)
            set(enable3A45_h,'Value',1)
            set(enable399C_h,'Value',1)
            set(enable3A1E_h,'Value',1)
            set(enable39F8_h,'Value',1)
            set(enable2BFD_h,'Value',1)
            set(enable38F5_h,'Value',0)
            set(imu1_h,'Value',1)
            set(imu2_h,'Value',1)
            set(imu3_h,'Value',1)
            set(imu4_h,'Value',1)
            set(imu5_h,'Value',1)
            set(imu6_h,'Value',1)
            set(imu7_h,'Value',1)
            set(gsr_h,'Value',1)
        case 'IMU+EMG'
            set(enable2BD1_h,'Value',1)
            set(enable3A45_h,'Value',1)
            set(enable399C_h,'Value',1)
            set(enable3A1E_h,'Value',1)
            set(enable39F8_h,'Value',1)
            set(enable2BFD_h,'Value',1)
            set(enable38F5_h,'Value',0)
            set(imu1_h,'Value',1)
            set(imu2_h,'Value',1)
            set(imu3_h,'Value',1)
            set(imu4_h,'Value',1)
            set(imu5_h,'Value',1)
            set(imu6_h,'Value',1)
            set(imu7_h,'Value',1)
            set(emg2_h,'Value',1)
            set(emg3_h,'Value',1)
            set(emg4_h,'Value',1)
            set(emg5_h,'Value',1)
        case 'EMG+GSR'
            set(enable3A45_h,'Value',1)
            set(enable399C_h,'Value',1)
            set(enable3A1E_h,'Value',1)
            set(enable39F8_h,'Value',1)
            set(emg2_h,'Value',1)
            set(emg3_h,'Value',1)
            set(emg4_h,'Value',1)
            set(emg5_h,'Value',1)        
            set(enable2BFD_h,'Value',1)
            set(gsr_h,'Value',1)
        case 'IMU+EMG+GSR'
            set(enable2BD1_h,'Value',1)
            set(enable3A45_h,'Value',1)
            set(enable399C_h,'Value',1)
            set(enable3A1E_h,'Value',1)
            set(enable39F8_h,'Value',1)
            set(enable2BFD_h,'Value',1)
            set(enable38F5_h,'Value',0)
            set(imu1_h,'Value',1)
            set(imu2_h,'Value',1)
            set(imu3_h,'Value',1)
            set(imu4_h,'Value',1)
            set(imu5_h,'Value',1)
            set(imu6_h,'Value',1)
            set(imu7_h,'Value',1)
            set(emg2_h,'Value',1)
            set(emg3_h,'Value',1)
            set(emg4_h,'Value',1)
            set(emg5_h,'Value',1)
            set(gsr_h,'Value',1)
        case '399C'
            set(enable399C_h,'Value',1)
            set(imu3_h,'Value',1)
            set(emg3_h,'Value',1)
            set(plot3_h,'Value',1)
    end  
    
    % Enable sensor parameters if disabled
    set(emgrate_h,'Enable','on')
    set(emgresolution_h,'Enable','on')
    set(emggain_h,'Enable','on')
    set(gsrrange_h,'Enable','on')
    set(lownoise_h,'Enable','on')
    set(widerange_h,'Enable','on')
    set(accelrange_h,'Enable','on')
    set(gyrorange_h,'Enable','on')
    set(magrange_h,'Enable','on')
    set(accelrate_h,'Enable','on')
    set(gyrorate_h,'Enable','on')
    set(magrate_h,'Enable','on')
    set(baudrate_h,'Enable','on')
    set(samprate_h,'Enable','on')
    set(sampratebool_h,'Enable','on')
    set(pressure_h,'Enable','on')
    set(pressureresolution_h,'Enable','on')
    set(params_h,'Enable','on')
    set(elapsedtime_h,'Enable','on')
    set(enable2BD1_h,'Enable','on')
    set(enable3A45_h,'Enable','on')
    set(enable399C_h,'Enable','on')
    set(enable3A1E_h,'Enable','on')
    set(enable39F8_h,'Enable','on')
    set(enable2BFD_h,'Enable','on')
    set(enable38F5_h,'Enable','on')
    set(emg2_h,'Enable','on')
    set(emg3_h,'Enable','on')
    set(emg4_h,'Enable','on')
    set(emg5_h,'Enable','on')
    set(imu1_h,'Enable','on')
    set(imu2_h,'Enable','on')
    set(imu3_h,'Enable','on')
    set(imu4_h,'Enable','on')
    set(imu5_h,'Enable','on')
    set(imu6_h,'Enable','on')
    set(imu7_h,'Enable','on')
    set(gsr_h,'Enable','on')
    set(plot1_h,'Enable','on')
    set(plot2_h,'Enable','on')
    set(plot3_h,'Enable','on')
    set(plot4_h,'Enable','on')
    set(plot5_h,'Enable','on')
    set(plot6_h,'Enable','on')
    set(plot7_h,'Enable','on')
    
    % Execute data collection
    RecordAllUnits
  
% Disconnect Shimmers
function disconnectbutton_Callback(hObject, eventdata, handles)

% Start recording trial
function startbutton_Callback(hObject, eventdata, handles)
    
% Stop trial recording
function stopbutton_Callback(hObject, eventdata, handles)

%% Trial Name
function trialname_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of trialname as text
%        str2double(get(hObject,'String')) returns contents of trialname as a double
function trialname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Set Rates

% Set acceleration sampling rate
function accelratemenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns accelratemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from accelratemenu
function accelratemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to accelratemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Set gyroscope sampling rate
function gyroratemenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns gyroratemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gyroratemenu
function gyroratemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gyroratemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Set magnetometer sampling rate
function magratemenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns magratemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from magratemenu
function magratemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to magratemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Set EMG sampling rate
function emgratemenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns emgratemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from emgratemenu
function emgratemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emgratemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Set baud rate
function baudratemenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns baudratemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from baudratemenu
function baudratemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baudratemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in samprate.
function samprate_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns samprate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from samprate
function samprate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samprate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Set Ranges

% Set acceleration range
function accelrangemenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns accelrangemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from accelrangemenu
function accelrangemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to accelrangemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Set gyroscope range
function gyrorangemenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns gyrorangemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gyrorangemenu
function gyrorangemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gyrorangemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Set magnetometer range
function magrangemenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns magrangemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from magrangemenu
function magrangemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to magrangemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Optional Settings

% Enable/Disable EMG recording
function emgcheckbox_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of emgcheckbox

% Enable/Disable GSR recording
function gsrcheckbox_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of gsrcheckbox


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in setparams.
function setparams_Callback(hObject, eventdata, handles)
% hObject    handle to setparams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function elapsedtime_Callback(hObject, eventdata, handles)
% hObject    handle to text123 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text123 as text
%        str2double(get(hObject,'String')) returns contents of text123 as a double


% --- Executes during object creation, after setting all properties.
function text123_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text123 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sampratebool.
function sampratebool_Callback(hObject, eventdata, handles)
% hObject    handle to sampratebool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sampratebool


% --- Executes on button press in enable2BD1.
function enable2BD1_Callback(hObject, eventdata, handles)
% hObject    handle to enable2BD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable2BD1


% --- Executes on button press in enable3A45.
function enable3A45_Callback(hObject, eventdata, handles)
% hObject    handle to enable3A45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable3A45


% --- Executes on button press in enable399C.
function enable399C_Callback(hObject, eventdata, handles)
% hObject    handle to enable399C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable399C


% --- Executes on button press in enable3A1E.
function enable3A1E_Callback(hObject, eventdata, handles)
% hObject    handle to enable3A1E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable3A1E


% --- Executes on button press in enable39F8.
function enable39F8_Callback(hObject, eventdata, handles)
% hObject    handle to enable39F8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable39F8


% --- Executes on button press in enable2BFD.
function enable2BFD_Callback(hObject, eventdata, handles)
% hObject    handle to enable2BFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable2BFD


% --- Executes on button press in enable38F5.
function enable38F5_Callback(hObject, eventdata, handles)
% hObject    handle to enable38F5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable38F5


% --- Executes during object creation, after setting all properties.
function elapsedtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elapsedtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in emgresolutionmenu.
function emgresolutionmenu_Callback(hObject, eventdata, handles)
% hObject    handle to emgresolutionmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns emgresolutionmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from emgresolutionmenu


% --- Executes during object creation, after setting all properties.
function emgresolutionmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emgresolutionmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gsrrangemenu.
function gsrrangemenu_Callback(hObject, eventdata, handles)
% hObject    handle to gsrrangemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns gsrrangemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gsrrangemenu


% --- Executes during object creation, after setting all properties.
function gsrrangemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gsrrangemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in emggainmenu.
function emggainmenu_Callback(hObject, eventdata, handles)
% hObject    handle to emggainmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns emggainmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from emggainmenu


% --- Executes during object creation, after setting all properties.
function emggainmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emggainmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pressurecheckbox.
function pressurecheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to pressurecheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pressurecheckbox


% --- Executes on selection change in pressuremenu.
function pressuremenu_Callback(hObject, eventdata, handles)
% hObject    handle to pressuremenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pressuremenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pressuremenu


% --- Executes during object creation, after setting all properties.
function pressuremenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pressuremenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in lownoiseaccelcheckbox.
function lownoiseaccelcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to lownoiseaccelcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lownoiseaccelcheckbox


% --- Executes on button press in widerangeaccelcheckbox.
function widerangeaccelcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to widerangeaccelcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of widerangeaccelcheckbox


% --- Executes on button press in imu1.
function imu1_Callback(hObject, eventdata, handles)
% hObject    handle to imu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imu1


% --- Executes on button press in imu2.
function imu2_Callback(hObject, eventdata, handles)
% hObject    handle to imu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imu2


% --- Executes on button press in imu3.
function imu3_Callback(hObject, eventdata, handles)
% hObject    handle to imu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imu3


% --- Executes on button press in imu4.
function imu4_Callback(hObject, eventdata, handles)
% hObject    handle to imu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imu4


% --- Executes on button press in imu5.
function imu5_Callback(hObject, eventdata, handles)
% hObject    handle to imu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imu5


% --- Executes on button press in imu6.
function imu6_Callback(hObject, eventdata, handles)
% hObject    handle to imu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imu6


% --- Executes on button press in imu7.
function imu7_Callback(hObject, eventdata, handles)
% hObject    handle to imu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imu7


% --- Executes on button press in emg1.
function emg1_Callback(hObject, eventdata, handles)
% hObject    handle to emg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of emg1


% --- Executes on button press in emg2.
function emg2_Callback(hObject, eventdata, handles)
% hObject    handle to emg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of emg2


% --- Executes on button press in emg3.
function emg3_Callback(hObject, eventdata, handles)
% hObject    handle to emg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of emg3


% --- Executes on button press in emg4.
function emg4_Callback(hObject, eventdata, handles)
% hObject    handle to emg4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of emg4


% --- Executes on button press in emg5.
function emg5_Callback(hObject, eventdata, handles)
% hObject    handle to emg5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of emg5


% --- Executes on button press in emg6.
function emg6_Callback(hObject, eventdata, handles)
% hObject    handle to emg6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of emg6


% --- Executes on button press in emg7.
function emg7_Callback(hObject, eventdata, handles)
% hObject    handle to emg7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of emg7


% --- Executes on selection change in defaultmodes.
function defaultmodes_Callback(hObject, eventdata, handles)
% hObject    handle to defaultmodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns defaultmodes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from defaultmodes


% --- Executes during object creation, after setting all properties.
function defaultmodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to defaultmodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot1.
function plot1_Callback(hObject, eventdata, handles)
% hObject    handle to plot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot1


% --- Executes on button press in plot2.
function plot2_Callback(hObject, eventdata, handles)
% hObject    handle to plot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot2


% --- Executes on button press in plot3.
function plot3_Callback(hObject, eventdata, handles)
% hObject    handle to plot3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot3


% --- Executes on button press in plot4.
function plot4_Callback(hObject, eventdata, handles)
% hObject    handle to plot4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot4


% --- Executes on button press in plot5.
function plot5_Callback(hObject, eventdata, handles)
% hObject    handle to plot5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot5


% --- Executes on button press in plot6.
function plot6_Callback(hObject, eventdata, handles)
% hObject    handle to plot6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot6


% --- Executes on button press in plot7.
function plot7_Callback(hObject, eventdata, handles)
% hObject    handle to plot7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot7
