function RecordAllUnits
clc; beep off;

% Define physical variables
g = 9.81;

% Define handles
handles = guihandles(gcbo);
    
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
table1_h = handles.uitable1;
window_h = handles.window;
trialname_h = handles.trialname;

% Get trialname
trialname = get(trialname_h,'String');

sensorFlag = [0 0 0 0 0 0 0];

pathname = 'C:\Users\Nick\Documents\Parkinson Mobility Study\Shimmer MATLAB Files\Shimmer-MATLAB-Files\Trials\';

buffer = 1; % seconds

shimmer1 = ShimmerHandleClass('5');
shimmer2 = ShimmerHandleClass('7');
shimmer3 = ShimmerHandleClass('9');
shimmer4 = ShimmerHandleClass('11');
shimmer5 = ShimmerHandleClass('13');
shimmer6 = ShimmerHandleClass('15');
shimmer7 = ShimmerHandleClass('17');

macros = SetEnabledSensorsMacrosClass;

sensorNames = {'Unit2BD1','Unit3A45','Unit399C','Unit3A1E','Unit39F8','Unit2BFD','Unit38F5'};

%% Set sensor parameters
disp('Select sensor options, then press <Set Parameters>...')
windisplay = {'Select sensor options, then press <Set Parameters>...'};
win=1;
set(window_h,'Data',windisplay)
waitfor(params_h,'Value',1)

% Get enabled EMG sensor flags
emgFlag = [0 get(emg2_h,'Value') get(emg3_h,'Value') get(emg4_h,'Value') get(emg5_h,'Value') 0 0];
%buffer=max(size(find(emgFlag)));

% Get enabled IMU sensor flags
imuFlag = [get(imu1_h,'Value') get(imu2_h,'Value') get(imu3_h,'Value') get(imu4_h,'Value') get(imu5_h,'Value') get(imu6_h,'Value') get(imu7_h,'Value')];

% Get enabled plot flags
plotFlag = [get(plot1_h,'Value') get(plot2_h,'Value') get(plot3_h,'Value') get(plot4_h,'Value') get(plot5_h,'Value') get(plot6_h,'Value') get(plot7_h,'Value')];

% EMG gain
contents = cellstr(get(emggain_h,'String'));
switch contents{get(emggain_h,'Value')}
    case '1'
        emg_gain = 1;
    case '2'
        emg_gain = 2;
    case '3'
        emg_gain = 3;   
    case '4'
        emg_gain = 4;
    case '6'
        emg_gain = 0;
    case '8'
        emg_gain = 5;
    case '12 (default)'
        emg_gain = 6;    
end
set(emggain_h,'Enable','off')
set(emgresolution_h,'Enable','off')

% GSR collection
switch get(gsr_h,'Value')
    case 1
        gsrFlag = true; % default
    case 0
        gsrFlag = false;
end
set(gsr_h,'Enable','off')

% GSR range
% contents = cellstr(get(gsrrange_h,'String'));
% switch contents{get(gsrrange_h,'Value')}
switch get(gsrrange_h,'Value')
    case 1 % Auto Range (default)
        gsr_range = 4;
    case 2 % 10 kOhm - 56 kOhm
        gsr_range = 0;
    case 3 % 56 kOhm - 220 kOhm
        gsr_range = 1;  
    case 4 % 220 kOhm - 680 kOhm
        gsr_range = 2;
    case 5 % 680 kOhm - 4.7 MOhm
        gsr_range = 3;
end
set(gsrrange_h,'Enable','off')

% General sampling rate (Hz)
if get(sampratebool_h,'Value')
    Fs = 64*ones(1,7);
    numSamples = 500*ones(1,7);
    if emgFlag(2)
        Fs(2)=str2double(get(samprate_h,'String'));
        numSamples(2)=str2double(get(samprate_h,'String'))*3;
    end
    if emgFlag(3)
        Fs(3)=str2double(get(samprate_h,'String'));
        numSamples(3)=str2double(get(samprate_h,'String'))*3;
    end
    if emgFlag(4)
        Fs(4)=str2double(get(samprate_h,'String'));
        numSamples(4)=str2double(get(samprate_h,'String'))*3;
    end
    if emgFlag(5)
        Fs(5)=str2double(get(samprate_h,'String'));
        numSamples(5)=str2double(get(samprate_h,'String'))*3;
    end
    if any(imuFlag)
        set(samprate_h,'String',['64+' get(samprate_h,'String')])
    else
        set(samprate_h,'String',get(samprate_h,'String'))
    end
else
    if any(emgFlag)
        Fs = 64*ones(1,7);
        numSamples = 500*ones(1,7);
        if emgFlag(2)
            Fs(2)=1024;
            numSamples(2)=2500;
        end
        if emgFlag(3)
            Fs(3)=1024;
            numSamples(3)=2500;
        end
        if emgFlag(4)
            Fs(4)=1024;
            numSamples(4)=2500;
        end
        if emgFlag(5)
            Fs(5)=1024;
            numSamples(5)=2500;
        end  
        if any(imuFlag)
            set(samprate_h,'String','64+1024')
        else
            set(samprate_h,'String','1024')
        end
    else
        Fs = 64*ones(1,7);
        numSamples = 500*ones(1,7);
        set(samprate_h,'String','64')
    end
end
set(samprate_h,'Enable','off')
set(sampratebool_h,'Enable','off')

% Wide Range Acclerometer range (±g)
contents = cellstr(get(accelrange_h,'String'));
switch contents{get(accelrange_h,'Value')}
    case '2 (default)'
        accel_range = 0;
        wr_axisrange = 2*g;
    case '4'
        accel_range = 1;
        wr_axisrange = 4*g;
    case '8'
        accel_range = 2;
        wr_axisrange = 8*g;
    case '16'
        accel_range = 3;
        wr_axisrange = 16*g;
end
set(accelrange_h,'Enable','off')

% Gyroscope range (±°/s)
contents = cellstr(get(gyrorange_h,'String'));
switch contents{get(gyrorange_h,'Value')}
    case '250'
        gyro_range = 0;
        gyro_axisrange = 250;
    case '500 (default)'
        gyro_range = 1;
        gyro_axisrange = 500;
    case '1000'
        gyro_range = 2;
        gyro_axisrange = 1000;
    case '2000'
        gyro_range = 3;
        gyro_axisrange = 2000;
end
set(gyrorange_h,'Enable','off')

% Magnetometer range (± Ga)
contents = cellstr(get(magrange_h,'String'));
switch contents{get(magrange_h,'Value')}
    case '1.3 (default)'
        mag_range = 1;
        mag_axisrange = 1.3;
    case '1.9'
        mag_range = 2;
        mag_axisrange = 1.9;
    case '2.5' 
        mag_range = 3;
        mag_axisrange = 2.5;
    case '4.0'
        mag_range = 4;
        mag_axisrange = 4.0;
    case '4.7'
        mag_range = 5;
        mag_axisrange = 4.7;
    case '5.6'
        mag_range = 6;
        mag_axisrange = 5.6;
    case '8.1'
        mag_range = 7;
        mag_axisrange = 8.1;
end
set(magrange_h,'Enable','off')

% Wide Range Accelerometer sampling rate (Hz)
contents = cellstr(get(accelrate_h,'String'));
switch contents{get(accelrate_h,'Value')}
    case '1'
        accel_rate = 1;
    case '10'
        accel_rate = 2;
    case '25'
        accel_rate = 3;
    case '50'
        accel_rate = 4;
    case '100 (default)'
        accel_rate = 5;
    case '200'
        accel_rate = 6;
    case '400'
        accel_rate = 7;
end
set(accelrate_h,'Enable','off')
set(lownoise_h,'Enable','off')
set(widerange_h,'Enable','off')

% Gyroscope sampling rate (Hz)
contents = cellstr(get(gyrorate_h,'String'));
switch contents{get(gyrorate_h,'Value')}
    case '32.25'
        gyro_rate = 255;
    case '51.28'
        gyro_rate = 155;
    case '173.91 (default)'
        gyro_rate = 45;
    case '258.06'
        gyro_rate = 30;
    case '533.33'
        gyro_rate = 14;
    case '1142.86'
        gyro_rate = 6;
end
set(gyrorate_h,'Enable','off')

% Magnetometer sampling rate (Hz)
contents = cellstr(get(magrate_h,'String'));
switch contents{get(magrate_h,'Value')}
    case '0.75'
        mag_rate = 0;
    case '1.5'
        mag_rate = 1;
    case '3'
        mag_rate = 2;
    case '7.5'
        mag_rate = 3;
    case '15'
        mag_rate = 4;
    case '30'
        mag_rate = 5;
    case '75 (default)'
        mag_rate = 6;
    case '220'
        mag_rate = 7;
end
set(magrate_h,'Enable','off')

% EMG sampling rate (Hz)
contents = cellstr(get(emgrate_h,'String'));
switch contents{get(emgrate_h,'Value')}
    case '125'
        exg_rate = 0;
    case '250'
        exg_rate = 1;
    case '500'
        exg_rate = 2;
    case '1000'
        exg_rate = 3;
    case '2000 (default)'
        exg_rate = 4;
    case '4000'
        exg_rate = 5;
    case '8000'
        exg_rate = 6;
end
set(emgrate_h,'Enable','off')

% Pressure sensor
switch get(pressure_h,'Value')
    case 1
        pressureFlag = true; 
    case 0
        pressureFlag = false; % default
end
set(pressure_h,'Enable','off')

% Pressure resolution
contents = cellstr(get(pressureresolution_h,'String'));
switch contents{get(pressureresolution_h,'Value')}
    case 'Low'
        pressure_resolution = 0;
    case 'Standard (default)'
        pressure_resolution = 1;
    case 'High'
        pressure_resolution = 2;
    case 'Very High'
        pressure_resolution = 0;
end
set(pressureresolution_h,'Enable','off')

% Baud rate (kB/s)
contents = cellstr(get(baudrate_h,'String'));
switch contents{get(baudrate_h,'Value')}
    case '115200'
        baud_rate = 0;
    case '1200'
        baud_rate = 1;
    case '2400'
        baud_rate = 2;
    case '4800'
        baud_rate = 3;
    case '9600'
        baud_rate = 4;
    case '19200'
        baud_rate = 5;
    case '38400'
        baud_rate = 6;
    case '57600'
        baud_rate = 7;
    case '230400 (default)'
        baud_rate = 8;
    case '460800'
        baud_rate = 9;
    case '921600'
        baud_rate = 10;
end
set(baudrate_h,'Enable','off')

set(enable2BD1_h,'Enable','off')
set(enable3A45_h,'Enable','off')
set(enable399C_h,'Enable','off')
set(enable3A1E_h,'Enable','off')
set(enable39F8_h,'Enable','off')
set(enable2BFD_h,'Enable','off')
set(enable38F5_h,'Enable','off')

set(emg2_h,'Enable','off')
set(emg3_h,'Enable','off')
set(emg4_h,'Enable','off')
set(emg5_h,'Enable','off')
set(imu1_h,'Enable','off')
set(imu2_h,'Enable','off')
set(imu3_h,'Enable','off')
set(imu4_h,'Enable','off')
set(imu5_h,'Enable','off')
set(imu6_h,'Enable','off')
set(imu7_h,'Enable','off')
set(gsr_h,'Enable','off')

set(plot1_h,'Enable','off')
set(plot2_h,'Enable','off')
set(plot3_h,'Enable','off')
set(plot4_h,'Enable','off')
set(plot5_h,'Enable','off')
set(plot6_h,'Enable','off')
set(plot7_h,'Enable','off')

set(params_h,'Enable','off')

%% Connect Shimmers
disp('Connecting Shimmers (may take a few minutes)...')
win=win+1;
newrow = {'Connecting Shimmers (may take a few minutes)...'};
windisplay = vertcat(newrow,windisplay);
if win>13
    windisplay{win}=[];
end
set(window_h,'Data',windisplay)

shimmersSelected = zeros(1,7);
if get(enable2BD1_h,'Value'), shimmersSelected(1)=true; end
if get(enable3A45_h,'Value'), shimmersSelected(2)=true; end
if get(enable399C_h,'Value'), shimmersSelected(3)=true; end
if get(enable3A1E_h,'Value'), shimmersSelected(4)=true; end
if get(enable39F8_h,'Value'), shimmersSelected(5)=true; end
if get(enable2BFD_h,'Value'), shimmersSelected(6)=true; end
if get(enable38F5_h,'Value'), shimmersSelected(7)=true; end

connectCount=0;
if (get(enable2BD1_h,'Value')) && (shimmersSelected(1)), if shimmer1.connect, connectCount=connectCount+1; end; end;
if (get(enable3A45_h,'Value')) && (shimmersSelected(2)), if shimmer2.connect, connectCount=connectCount+1; end; end;
if (get(enable399C_h,'Value')) && (shimmersSelected(3)), if shimmer3.connect, connectCount=connectCount+1; end; end;
if (get(enable3A1E_h,'Value')) && (shimmersSelected(4)), if shimmer4.connect, connectCount=connectCount+1; end; end;
if (get(enable39F8_h,'Value')) && (shimmersSelected(5)), if shimmer5.connect, connectCount=connectCount+1; end; end;
if (get(enable2BFD_h,'Value')) && (shimmersSelected(6)), if shimmer6.connect, connectCount=connectCount+1; end; end;
if (get(enable38F5_h,'Value')) && (shimmersSelected(7)), if shimmer7.connect, connectCount=connectCount+1; end; end;

if length(find(shimmersSelected))==connectCount
 
    %% Set Parameters
    
    %% Shimmer 1 (BTID 2BD1 - IMU unit)
    if shimmersSelected(1)
        shimmer1.setbaudrate(baud_rate);
        shimmer1.disableallsensors;
        
        shimmer1.setinternalboard('None');
        if imuFlag(1)
            if get(lownoise_h,'Value') && get(widerange_h,'Value')
                if pressureFlag
                    shimmer1.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer1.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                end
            elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                if pressureFlag
                    shimmer1.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer1.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                end
            elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                if pressureFlag
                    shimmer1.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer1.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                end
            elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                if pressureFlag
                    shimmer1.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer1.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                end
            end
        else
            if pressureFlag
                shimmer1.setenabledsensors(macros.BATT,1,macros.PRESSURE,1);
            else
                shimmer1.setenabledsensors(macros.BATT,1);
            end
        end
        
        if pressureFlag
            shimmer1.setpressureresolution(pressure_resolution);
        end
        
        shimmer1.setsamplingrate(Fs(1));
        if imuFlag(1)
%             shimmer1.setaccelrate(accel_rate);
%             shimmer1.setgyrorate(gyro_rate);
%             shimmer1.setmagrate(mag_rate);
            shimmer1.setaccelrange(accel_range);
            shimmer1.setgyrorange(gyro_range);
            shimmer1.setmagrange(mag_range);
        end
        win=win+1;
        newrow = {'Unit 2BD1 parameters set.'};
        windisplay = vertcat(newrow,windisplay);
        if win>13
            windisplay{win}=[];
        end
        set(window_h,'Data',windisplay)
    end
    
    %% Shimmer 2 (BTID 3A45 - ExG unit)
    if shimmersSelected(2)
        shimmer2.setbaudrate(baud_rate);
        shimmer2.disableallsensors;
        
        % Options if EMG enabled
        if emgFlag(2)
            shimmer2.setinternalboard('EMG');
            contents = cellstr(get(emgresolution_h,'String'));
            switch contents{get(emgresolution_h,'Value')}
                case '16 BIT'
                    if imuFlag(2)
                        if get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end,
                        elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer2.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer2.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer2.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer2.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        end
                    else
                        if pressureFlag
                            shimmer2.setenabledsensors(macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                        else
                            shimmer2.setenabledsensors(macros.BATT,1,macros.EMG16BIT,1);
                        end
                    end
                case '24 BIT (default)'
                    if imuFlag(2)
                        if get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end,
                        elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer2.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer2.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer2.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer2.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        end
                    else
                        if pressureFlag
                            shimmer2.setenabledsensors(macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                        else
                            shimmer2.setenabledsensors(macros.BATT,1,macros.EMG24BIT,1);
                        end
                    end
            end
            shimmer2.setexggain(emg_gain,1,1);
            shimmer2.setexggain(emg_gain,1,2); 
            
        % Options if EMG disabled
        elseif ~emgFlag(2)
            shimmer2.setinternalboard('None');
            if imuFlag(2)
                if get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer2.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer2.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer2.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer2.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                end
            else
                if pressureFlag
                    shimmer2.setenabledsensors(macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer2.setenabledsensors(macros.BATT,1);
                end
            end
        end
        
        if pressureFlag
            shimmer2.setpressureresolution(pressure_resolution);
        end
        
        shimmer2.setsamplingrate(Fs(2));
        if imuFlag(2)
%             shimmer2.setaccelrate(accel_rate);
%             shimmer2.setgyrorate(gyro_rate);
%             shimmer2.setmagrate(mag_rate);
            shimmer2.setaccelrange(accel_range);
            shimmer2.setgyrorange(gyro_range);
            shimmer2.setmagrange(mag_range);
        end
        if emgFlag(2)
            shimmer2.setexgrate(exg_rate,1);
            shimmer2.setexgrate(exg_rate,2);
        end
        win=win+1;
        newrow = {'Unit 3A45 parameters set.'};
        windisplay = vertcat(newrow,windisplay);
        if win>13
            windisplay{win}=[];
        end
        set(window_h,'Data',windisplay)
        
    end
    
    %% Shimmer 3 (BTID 399C - ExG unit)
    if shimmersSelected(3)
        shimmer3.setbaudrate(baud_rate);
        shimmer3.disableallsensors;
        
        % Options if EMG enabled
        if emgFlag(3)
            shimmer3.setinternalboard('EMG');
            contents = cellstr(get(emgresolution_h,'String'));
            switch contents{get(emgresolution_h,'Value')}
                case '16 BIT'
                    if imuFlag(3)
                        if get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end,
                        elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer3.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer3.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer3.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer3.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer3.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer3.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        end
                    else
                        if pressureFlag
                            shimmer3.setenabledsensors(macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                        else
                            shimmer3.setenabledsensors(macros.BATT,1,macros.EMG16BIT,1);
                        end
                    end
                case '24 BIT (default)'
                    if imuFlag(3)
                        if get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end,
                        elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer3.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer3.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer3.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer3.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer3.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer3.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        end
                    else
                        if pressureFlag
                            shimmer3.setenabledsensors(macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                        else
                            shimmer3.setenabledsensors(macros.BATT,1,macros.EMG24BIT,1);
                        end
                    end
            end
            shimmer3.setexggain(emg_gain,1,1);
            shimmer3.setexggain(emg_gain,1,2); 
            
        % Options if EMG disabled
        elseif ~emgFlag(3)
            shimmer3.setinternalboard('None');
            if imuFlag(3)
                if get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer3.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer3.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer3.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer3.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer3.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer3.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                end
            else
                if pressureFlag
                    shimmer3.setenabledsensors(macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer3.setenabledsensors(macros.BATT,1);
                end
            end
        end
        
        if pressureFlag
            shimmer3.setpressureresolution(pressure_resolution);
        end
        
        shimmer3.setsamplingrate(Fs(3));
        if imuFlag(3)
%             shimmer3.setaccelrate(accel_rate);
%             shimmer3.setgyrorate(gyro_rate);
%             shimmer3.setmagrate(mag_rate);
            shimmer3.setaccelrange(accel_range);
            shimmer3.setgyrorange(gyro_range);
            shimmer3.setmagrange(mag_range);
        end
        if emgFlag(3)
            shimmer3.setexgrate(exg_rate,1);
            shimmer3.setexgrate(exg_rate,2);
        end       
        win=win+1;
        newrow = {'Unit 399C parameters set.'};
        windisplay = vertcat(newrow,windisplay);
        if win>13
            windisplay{win}=[];
        end
        set(window_h,'Data',windisplay)
    end
    
    %% Shimmer 4 (BTID 3A1E - ExG unit)
    if shimmersSelected(4)
        shimmer4.setbaudrate(baud_rate);
        shimmer4.disableallsensors;
        
        % Options if EMG enabled
        if emgFlag(4)
            shimmer4.setinternalboard('EMG');
            contents = cellstr(get(emgresolution_h,'String'));
            switch contents{get(emgresolution_h,'Value')}
                case '16 BIT'
                    if imuFlag(4)
                        if get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end,
                        elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer4.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer4.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer4.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer4.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer4.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer4.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        end
                    else
                        if pressureFlag
                            shimmer4.setenabledsensors(macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                        else
                            shimmer4.setenabledsensors(macros.BATT,1,macros.EMG16BIT,1);
                        end
                    end
                case '24 BIT (default)'
                    if imuFlag(4)
                        if get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end,
                        elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer4.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer4.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer4.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer4.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer4.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer4.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        end
                    else
                        if pressureFlag
                            shimmer4.setenabledsensors(macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                        else
                            shimmer4.setenabledsensors(macros.BATT,1,macros.EMG24BIT,1);
                        end
                    end
            end
            shimmer4.setexggain(emg_gain,1,1);
            shimmer4.setexggain(emg_gain,1,2); 
            
        % Options if EMG disabled
        elseif ~emgFlag(4)
            shimmer4.setinternalboard('None');
            if imuFlag(4)
                if get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer4.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer4.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer4.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer4.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer4.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer4.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                end
            else
                if pressureFlag
                    shimmer4.setenabledsensors(macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer4.setenabledsensors(macros.BATT,1);
                end
            end
        end
        
        if pressureFlag
            shimmer4.setpressureresolution(pressure_resolution);
        end
        
        shimmer4.setsamplingrate(Fs(4));
        if imuFlag(4)
%             shimmer4.setaccelrate(accel_rate);
%             shimmer4.setgyrorate(gyro_rate);
%             shimmer4.setmagrate(mag_rate);
            shimmer4.setaccelrange(accel_range);
            shimmer4.setgyrorange(gyro_range);
            shimmer4.setmagrange(mag_range);
        end
        if emgFlag(4)
            shimmer4.setexgrate(exg_rate,1);
            shimmer4.setexgrate(exg_rate,2);
        end
        win=win+1;
        newrow = {'Unit 3A1E parameters set.'};
        windisplay = vertcat(newrow,windisplay);
        if win>13
            windisplay{win}=[];
        end
        set(window_h,'Data',windisplay)
    end
    
    %% Shimmer 5 (BTID 39F8 - ExG unit)
    if shimmersSelected(5)
        shimmer5.setbaudrate(baud_rate);
        shimmer5.disableallsensors;
        
        % Options if EMG enabled
        if emgFlag(5)
            shimmer5.setinternalboard('EMG');
            contents = cellstr(get(emgresolution_h,'String'));
            switch contents{get(emgresolution_h,'Value')}
                case '16 BIT'
                    if imuFlag(5)
                        if get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end,
                        elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer5.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer5.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer5.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer5.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer5.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                            else
                                shimmer5.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                            end
                        end
                    else
                        if pressureFlag
                            shimmer5.setenabledsensors(macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                        else
                            shimmer5.setenabledsensors(macros.BATT,1,macros.EMG16BIT,1);
                        end
                    end
                case '24 BIT (default)'
                    if imuFlag(5)
                        if get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end,
                        elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer5.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer5.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                            if pressureFlag
                                shimmer5.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer5.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                            if pressureFlag
                                shimmer5.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                            else
                                shimmer5.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                            end
                        end
                    else
                        if pressureFlag
                            shimmer5.setenabledsensors(macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                        else
                            shimmer5.setenabledsensors(macros.BATT,1,macros.EMG24BIT,1);
                        end
                    end
            end
            shimmer5.setexggain(emg_gain,1,1);
            shimmer5.setexggain(emg_gain,1,2); 
            
        % Options if EMG disabled
        elseif ~emgFlag(5)
            shimmer5.setinternalboard('None');
            if imuFlag(5)
                if get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer5.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer5.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer5.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer5.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer5.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer5.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                end
            else
                if pressureFlag
                    shimmer5.setenabledsensors(macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer5.setenabledsensors(macros.BATT,1);
                end
            end
        end
        
        if pressureFlag
            shimmer5.setpressureresolution(pressure_resolution);
        end
        
        shimmer5.setsamplingrate(Fs(5));
        if imuFlag(5)
%             shimmer5.setaccelrate(accel_rate);
%             shimmer5.setgyrorate(gyro_rate);
%             shimmer5.setmagrate(mag_rate);
            shimmer5.setaccelrange(accel_range);
            shimmer5.setgyrorange(gyro_range);
            shimmer5.setmagrange(mag_range);
        end
        if emgFlag(5)
            shimmer5.setexgrate(exg_rate,1);
            shimmer5.setexgrate(exg_rate,2);
        end
        win=win+1;
        newrow = {'Unit 39F8 parameters set.'};
        windisplay = vertcat(newrow,windisplay);
        if win>13
            windisplay{win}=[];
        end
        set(window_h,'Data',windisplay)
    end
    
    %% Shimmer 6 (BTID 2BFD - GSR+ unit)
    if shimmersSelected(6)
        shimmer6.setbaudrate(baud_rate);
        shimmer6.disableallsensors;
        if gsrFlag
            shimmer6.setinternalboard('GSR');
            if imuFlag(6)
                if get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer6.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1,macros.GSR,1);
                    else
                        shimmer6.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.GSR,1);
                    end
                elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer6.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1,macros.GSR,1);
                    else
                        shimmer6.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.GSR,1);
                    end
                elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer6.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1,macros.GSR,1);
                    else
                        shimmer6.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.GSR,1);
                    end
                elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer6.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1,macros.GSR,1);
                    else
                        shimmer6.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.GSR,1);
                    end
                end 
            else
                if pressureFlag
                    shimmer6.setenabledsensors(macros.BATT,1,macros.PRESSURE,1,macros.GSR,1);
                else
                    shimmer6.setenabledsensors(macros.BATT,1,macros.GSR,1);
                end
            end
            shimmer6.setgsrrange(gsr_range);
            
        elseif ~gsrFlag
            shimmer6.setinternalboard('None');
            if imuFlag(6)
                if get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer6.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer6.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer6.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer6.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                    if pressureFlag
                        shimmer6.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer6.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                    if pressureFlag
                        shimmer6.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                    else
                        shimmer6.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                    end
                end
            else
                if pressureFlag
                    shimmer6.setenabledsensors(macros.BATT,1,macros.PRESSURE);
                else
                    shimmer6.setenabledsensors(macros.BATT);
                end
            end
        end
        
        if pressureFlag
            shimmer6.setpressureresolution(pressure_resolution);
        end
        
        shimmer6.setsamplingrate(Fs(6));
        if imuFlag(6)
%             shimmer6.setaccelrate(accel_rate);
%             shimmer6.setgyrorate(gyro_rate);
%             shimmer6.setmagrate(mag_rate);
            shimmer6.setaccelrange(accel_range);
            shimmer6.setgyrorange(gyro_range);
            shimmer6.setmagrange(mag_range);
        end
        win=win+1;
        newrow = {'Unit 2BFD parameters set.'};
        windisplay = vertcat(newrow,windisplay);
        if win>13
            windisplay{win}=[];
        end
        set(window_h,'Data',windisplay)
    end
    
    %% Shimmer 7 (BTID 38F5 - PROTO3 unit)
    if shimmersSelected(7)
        shimmer7.setbaudrate(baud_rate);
        shimmer7.disableallsensors;
        
        shimmer7.setinternalboard('None');
        if imuFlag(7)
            if get(lownoise_h,'Value') && get(widerange_h,'Value')
                if pressureFlag
                    shimmer7.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer7.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                end
            elseif get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                if pressureFlag
                    shimmer7.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer7.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                end
            elseif ~get(lownoise_h,'Value') && get(widerange_h,'Value')
                if pressureFlag
                    shimmer7.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer7.setenabledsensors(macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                end
            elseif ~get(lownoise_h,'Value') && ~get(widerange_h,'Value')
                if pressureFlag
                    shimmer7.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.PRESSURE,1);
                else
                    shimmer7.setenabledsensors(macros.GYRO,1,macros.MAG,1,macros.BATT,1);
                end
            end
        else
            if pressureFlag
                shimmer7.setenabledsensors(macros.BATT,1,macros.PRESSURE,1);
            else
                shimmer7.setenabledsensors(macros.BATT,1);
            end
        end
        
        if pressureFlag
            shimmer7.setpressureresolution(pressure_resolution);
        end
        
        shimmer7.setsamplingrate(Fs(7));
        if imuFlag(7)
%             shimmer7.setaccelrate(accel_rate);
%             shimmer7.setgyrorate(gyro_rate);
%             shimmer7.setmagrate(mag_rate);
            shimmer7.setaccelrange(accel_range);
            shimmer7.setgyrorange(gyro_range);
            shimmer7.setmagrange(mag_range);
        end
        win=win+1;
        newrow = {'Unit 38F5 parameters set.'};
        windisplay = vertcat(newrow,windisplay);
        if win>13
            windisplay{win}=[];
        end
        set(window_h,'Data',windisplay)
    end
    
    %% Start Trial
    
    disp('Release <Disconnect> button if necessary...')
    win=win+1;
    newrow = {'Release <Disconnect> button if necessary...'};
    windisplay = vertcat(newrow,windisplay);
    if win>13
        windisplay{win}=[];
    end
    set(window_h,'Data',windisplay)
    waitfor(disconnect_h,'Value',0)
    
    while ~get(disconnect_h,'Value')
        
        disp('Release <Stop> button if necessary...')
        win=win+1;
        newrow = {'Release <Stop> button if necessary...'};
        windisplay = vertcat(newrow,windisplay);
        if win>13
            windisplay{win}=[];
        end
        set(window_h,'Data',windisplay)
        waitfor(stop_h,'Value',0)
        
        disp(['Press <Start> to begin recording ' trialname ' ...'])
        win=win+1;
        newrow = {['Press <Start> to begin recording ' trialname ' ...']};
        windisplay = vertcat(newrow,windisplay);
        if win>13
            windisplay{win}=[];
        end
        set(window_h,'Data',windisplay)
        waitfor(start_h,'Value',1)
        
        if get(disconnect_h,'Value')
            disp('Disconnecting...')
            win=win+1;
            newrow = {'Disconnecting...'};
            windisplay = vertcat(newrow,windisplay);
            if win>13
                windisplay{win}=[];
            end
            set(window_h,'Data',windisplay)
            waitfor(start_h,'Value',1)
            break;
        end
        
        startCount=0;
        if (shimmersSelected(1)), if shimmer1.startdatalogandstream, startCount=startCount+1; end; end;
        if (shimmersSelected(2)), if shimmer2.startdatalogandstream, startCount=startCount+1; end; end;
        if (shimmersSelected(3)), if shimmer3.startdatalogandstream, startCount=startCount+1; end; end;
        if (shimmersSelected(4)), if shimmer4.startdatalogandstream, startCount=startCount+1; end; end;
        if (shimmersSelected(5)), if shimmer5.startdatalogandstream, startCount=startCount+1; end; end;
        if (shimmersSelected(6)), if shimmer6.startdatalogandstream, startCount=startCount+1; end; end;
        if (shimmersSelected(7)), if shimmer7.startdatalogandstream, startCount=startCount+1; end; end;
        
        if length(find(shimmersSelected))==startCount
            
            elapsedTime = 0;
            set(elapsedtime_h,'String',num2str(elapsedTime))
            
            tic;
            
            dataShimmer1 = [];
            dataShimmer2 = [];
            dataShimmer3 = [];
            dataShimmer4 = [];
            dataShimmer5 = [];
            dataShimmer6 = [];
            dataShimmer7 = [];
            
            plotDataShimmer1 = [];
            plotDataShimmer2 = [];
            plotDataShimmer3 = [];
            plotDataShimmer4 = [];
            plotDataShimmer5 = [];
            plotDataShimmer6 = [];
            plotDataShimmer7 = [];
            
            packetsReceivedShimmer1 = 0;
            packetsReceivedShimmer2 = 0;
            packetsReceivedShimmer3 = 0;
            packetsReceivedShimmer4 = 0;
            packetsReceivedShimmer5 = 0;
            packetsReceivedShimmer6 = 0;
            packetsReceivedShimmer7 = 0;
            
            battShimmer1 = 0;
            battShimmer2 = 0;
            battShimmer3 = 0;
            battShimmer4 = 0;
            battShimmer5 = 0;
            battShimmer6 = 0;
            battShimmer7 = 0;
            
            firsttime=true;
            firsttime1=true;
            firsttime2=true;
            firsttime3=true;
            firsttime4=true;
            firsttime5=true;
            firsttime6=true;
            firsttime7=true;
            
            %% Data Collection (Read/Plot/Write)
            while ~get(stop_h,'Value')
                
                set(enable2BD1_h,'Enable','off')
                set(enable3A45_h,'Enable','off')
                set(enable399C_h,'Enable','off')
                set(enable3A1E_h,'Enable','off')
                set(enable39F8_h,'Enable','off')
                set(enable2BFD_h,'Enable','off')
                set(enable38F5_h,'Enable','off')
                set(emg2_h,'Enable','off')
                set(emg3_h,'Enable','off')
                set(emg4_h,'Enable','off')
                set(emg5_h,'Enable','off')
                set(imu1_h,'Enable','off')
                set(imu2_h,'Enable','off')
                set(imu3_h,'Enable','off')
                set(imu4_h,'Enable','off')
                set(imu5_h,'Enable','off')
                set(imu6_h,'Enable','off')
                set(imu7_h,'Enable','off')
                set(gsr_h,'Enable','off')
                set(plot1_h,'Enable','off')
                set(plot2_h,'Enable','off')
                set(plot3_h,'Enable','off')
                set(plot4_h,'Enable','off')
                set(plot5_h,'Enable','off')
                set(plot6_h,'Enable','off')
                set(plot7_h,'Enable','off')
                
                pause(buffer)
                
                %% Shimmer 1 (BTID 2BD1 - IMU unit)
                if shimmersSelected(1)
                    [newDataShimmer1,signalNames,signalFormats,signalUnits]=shimmer1.getdata('a');
                    if ~isempty(newDataShimmer1)
                        if firsttime==true
                            sensorNamesString = char(sensorNames(1,1));
                            signalNamesString = char(signalNames(1,1));
                            signalFormatsString = char(signalFormats(1,1));
                            signalUnitsString = char(signalUnits(1,1));
                            for i=2:length(signalNames)
                                sensorNamesString = [sensorNamesString char(9) char(sensorNames(1,1))];
                                signalNamesString = [signalNamesString char(9) char(signalNames(1,i))];
                                signalFormatsString = [signalFormatsString char(9) char(signalFormats(1,i))];
                                signalUnitsString = [signalUnitsString char(9) char(signalUnits(1,i))];
                            end
                            
                            dlmwrite([pathname trialname ' - ' sensorNames{1,1} '.txt'], sensorNamesString, '%s')
                            
                            fid = fopen([pathname trialname ' - ' sensorNames{1,1} '.txt'],'a');
                            fprintf(fid,'%s\n',signalNamesString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,1} '.txt'],'a');
                            fprintf(fid,'%s\n',signalFormatsString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,1} '.txt'],'a');
                            fprintf(fid,'%s\n',signalUnitsString);
                            fclose(fid);
                        end
                        
                        dlmwrite([pathname trialname ' - ' sensorNames{1,1} '.txt'], newDataShimmer1, '-append', 'delimiter', '\t','precision',16);
                        sensorFlag(1) = 1;
                        
                        dataShimmer1 = [dataShimmer1; newDataShimmer1];
                        plotDataShimmer1 = [plotDataShimmer1; newDataShimmer1];
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer1 = dataShimmer1(:,timeIndex(2));
                        packetsReceivedShimmer1 = shimmer1.getpercentageofpacketsreceived(timeDataShimmer1);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer1 = (((mean(newDataShimmer1(:,battIndex(2)))/1000)-3.2)/(4.167-3.2))*100;
                        
                        % Plot Shimmer 1 data
                        if plotFlag(1)
                            figure(1)
                            if length(plotDataShimmer1)>numSamples(1)
                                plotDataShimmer1 = plotDataShimmer1((length(plotDataShimmer1)-numSamples(1)):end,:);
                            end
                            
                            if ~isempty(plotDataShimmer1)
                                if imuFlag(1)
                                    if get(lownoise_h,'Value')
                                        lnaccelIndex = [find(ismember(signalNames, 'Low Noise Accelerometer X')) find(ismember(signalNames, 'Low Noise Accelerometer Y')) find(ismember(signalNames, 'Low Noise Accelerometer Z'))];
                                        subplot(2,2,1)
                                        plot([plotDataShimmer1(:,lnaccelIndex(1)), plotDataShimmer1(:,lnaccelIndex(2)), plotDataShimmer1(:,lnaccelIndex(3))])
                                        axis([0 numSamples(1) -2 2])
                                        legend(char(signalNames{lnaccelIndex(1)}),char(signalNames{lnaccelIndex(2)}),char(signalNames{lnaccelIndex(3)}))
                                    end
                                    if get(widerange_h,'Value')
                                        wraccelIndex = [find(ismember(signalNames, 'Wide Range Accelerometer X')) find(ismember(signalNames, 'Wide Range Accelerometer Y')) find(ismember(signalNames, 'Wide Range Accelerometer Z'))];
                                        subplot(2,2,2)
                                        plot([plotDataShimmer1(:,wraccelIndex(1)), plotDataShimmer1(:,wraccelIndex(2)), plotDataShimmer1(:,wraccelIndex(3))])
                                        axis([0 numSamples(1) -wr_axisrange wr_axisrange])
                                        legend(char(signalNames{wraccelIndex(1)}),char(signalNames{wraccelIndex(2)}),char(signalNames{wraccelIndex(3)}))
                                    end
                                    gyroIndex = [find(ismember(signalNames, 'Gyroscope X')) find(ismember(signalNames, 'Gyroscope Y')) find(ismember(signalNames, 'Gyroscope Z'))];
                                    subplot(2,2,3)
                                    plot([plotDataShimmer1(:,gyroIndex(1)), plotDataShimmer1(:,gyroIndex(2)), plotDataShimmer1(:,gyroIndex(3))])
                                    axis([0 numSamples(1) -gyro_axisrange gyro_axisrange])
                                    legend(char(signalNames{gyroIndex(1)}),char(signalNames{gyroIndex(2)}),char(signalNames{gyroIndex(3)}))
                                    
                                    magIndex = [find(ismember(signalNames, 'Magnetometer X')) find(ismember(signalNames, 'Magnetometer Y')) find(ismember(signalNames, 'Magnetometer Z'))];
                                    subplot(2,2,4)
                                    plot([plotDataShimmer1(:,magIndex(1)), plotDataShimmer1(:,magIndex(2)), plotDataShimmer1(:,magIndex(3))])
                                    axis([0 numSamples(1) -mag_axisrange mag_axisrange])
                                    legend(char(signalNames{magIndex(1)}),char(signalNames{magIndex(2)}),char(signalNames{magIndex(3)}))
                                end
                            end
                            if firsttime1
                                figtitle('Shimmer 1 - BTID 2BD1')
                            end
                        end
                        
                        
                    end
                    
                    
                end      
                
                %% Shimmer 2 (BTID 3A45 - ExG unit)
                if shimmersSelected(2)
                    [newDataShimmer2,signalNames,signalFormats,signalUnits]=shimmer2.getdata('a');
                    if ~isempty(newDataShimmer2)
                        if firsttime==true
                            sensorNamesString = char(sensorNames(1,2));
                            signalNamesString = char(signalNames(1,1));
                            signalFormatsString = char(signalFormats(1,1));
                            signalUnitsString = char(signalUnits(1,1));
                            for i=2:length(signalNames)
                                sensorNamesString = [sensorNamesString char(9) char(sensorNames(1,2))];
                                signalNamesString = [signalNamesString char(9) char(signalNames(1,i))];
                                signalFormatsString = [signalFormatsString char(9) char(signalFormats(1,i))];
                                signalUnitsString = [signalUnitsString char(9) char(signalUnits(1,i))];
                            end
                            
                            dlmwrite([pathname trialname ' - ' sensorNames{1,2} '.txt'], sensorNamesString, '%s')
                            
                            fid = fopen([pathname trialname ' - ' sensorNames{1,2} '.txt'],'a');
                            fprintf(fid,'%s\n',signalNamesString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,2} '.txt'],'a');
                            fprintf(fid,'%s\n',signalFormatsString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,2} '.txt'],'a');
                            fprintf(fid,'%s\n',signalUnitsString);
                            fclose(fid);
                        end
                        
                        dlmwrite([pathname trialname ' - ' sensorNames{1,2} '.txt'], newDataShimmer2, '-append', 'delimiter', '\t','precision',16);
                        sensorFlag(2) = 1;
                        
                        dataShimmer2 = [dataShimmer2; newDataShimmer2];
                        plotDataShimmer2 = [plotDataShimmer2; newDataShimmer2];
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer2 = dataShimmer2(:,timeIndex(2));
                        packetsReceivedShimmer2 = shimmer2.getpercentageofpacketsreceived(timeDataShimmer2);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer2 = (((mean(newDataShimmer2(:,battIndex(2)))/1000)-3.2)/(4.167-3.2))*100;
                        
                        % Plot Shimmer 2 data
                        if plotFlag(2)
                            figure(2)
                            if length(plotDataShimmer2)>numSamples(2)
                                plotDataShimmer2 = plotDataShimmer2((length(plotDataShimmer2)-numSamples(2)):end,:);
                            end
                            
                            if ~isempty(plotDataShimmer2)
                                if imuFlag(2)
                                    if get(lownoise_h,'Value')
                                        lnaccelIndex = [find(ismember(signalNames, 'Low Noise Accelerometer X')) find(ismember(signalNames, 'Low Noise Accelerometer Y')) find(ismember(signalNames, 'Low Noise Accelerometer Z'))];
                                        subplot(2,2,1)
                                        plot([plotDataShimmer2(:,lnaccelIndex(1)), plotDataShimmer2(:,lnaccelIndex(2)), plotDataShimmer2(:,lnaccelIndex(3))])
                                        axis([0 numSamples(2) -2 2])
                                        legend(char(signalNames{lnaccelIndex(1)}),char(signalNames{lnaccelIndex(2)}),char(signalNames{lnaccelIndex(3)}))
                                    end
                                    if get(widerange_h,'Value')
                                        wraccelIndex = [find(ismember(signalNames, 'Wide Range Accelerometer X')) find(ismember(signalNames, 'Wide Range Accelerometer Y')) find(ismember(signalNames, 'Wide Range Accelerometer Z'))];
                                        subplot(2,2,2)
                                        plot([plotDataShimmer2(:,wraccelIndex(1)), plotDataShimmer2(:,wraccelIndex(2)), plotDataShimmer2(:,wraccelIndex(3))])
                                        axis([0 numSamples(2) -wr_axisrange wr_axisrange])
                                        legend(char(signalNames{wraccelIndex(1)}),char(signalNames{wraccelIndex(2)}),char(signalNames{wraccelIndex(3)}))
                                    end
                                    gyroIndex = [find(ismember(signalNames, 'Gyroscope X')) find(ismember(signalNames, 'Gyroscope Y')) find(ismember(signalNames, 'Gyroscope Z'))];
                                    subplot(2,2,3)
                                    plot([plotDataShimmer2(:,gyroIndex(1)), plotDataShimmer2(:,gyroIndex(2)), plotDataShimmer2(:,gyroIndex(3))])
                                    axis([0 numSamples(2) -gyro_axisrange gyro_axisrange])
                                    legend(char(signalNames{gyroIndex(1)}),char(signalNames{gyroIndex(2)}),char(signalNames{gyroIndex(3)}))
                                    
                                    magIndex = [find(ismember(signalNames, 'Magnetometer X')) find(ismember(signalNames, 'Magnetometer Y')) find(ismember(signalNames, 'Magnetometer Z'))];
                                    subplot(2,2,4)
                                    plot([plotDataShimmer2(:,magIndex(1)), plotDataShimmer2(:,magIndex(2)), plotDataShimmer2(:,magIndex(3))])
                                    axis([0 numSamples(2) -mag_axisrange mag_axisrange])
                                    legend(char(signalNames{magIndex(1)}),char(signalNames{magIndex(2)}),char(signalNames{magIndex(3)}))
                                end
                                if emgFlag(2)
                                    emgIndex = [find(ismember(signalNames, 'EMG CH1')), find(ismember(signalNames, 'EMG CH2'))];
                                    subplot(2,1,1)                                    
                                    temptime = timeDataShimmer2(2:end);
                                    TV = (temptime-temptime(1))/1000;
                                    plot(butterfilt(plotDataShimmer2(:,emgIndex(1)),'bandpass',[10 400],4,TV))
                                    axis([0 numSamples(2) -5 5])
                                    legend(char(signalNames{emgIndex(1)}))
                                    subplot(2,1,2)
                                    plot(butterfilt(plotDataShimmer2(:,emgIndex(2)),'bandpass',[10 400],4,TV))
                                    axis([0 numSamples(2) -5 5])
                                    legend(char(signalNames{emgIndex(2)}))
                                end
                            end
                            if firsttime2
                                figtitle('Shimmer 2 - BTID 3A45')
                            end
                        end
                    end
                end
                               
                %% Shimmer 3 (BTID 399C - ExG unit)
                if shimmersSelected(3)
                    [newDataShimmer3,signalNames,signalFormats,signalUnits]=shimmer3.getdata('a');
                    if ~isempty(newDataShimmer3)
                        if firsttime==true
                            sensorNamesString = char(sensorNames(1,3));
                            signalNamesString = char(signalNames(1,1));
                            signalFormatsString = char(signalFormats(1,1));
                            signalUnitsString = char(signalUnits(1,1));
                            for i=2:length(signalNames)
                                sensorNamesString = [sensorNamesString char(9) char(sensorNames(1,3))];
                                signalNamesString = [signalNamesString char(9) char(signalNames(1,i))];
                                signalFormatsString = [signalFormatsString char(9) char(signalFormats(1,i))];
                                signalUnitsString = [signalUnitsString char(9) char(signalUnits(1,i))];
                            end
                            
                            dlmwrite([pathname trialname ' - ' sensorNames{1,3} '.txt'], sensorNamesString, '%s')
                            
                            fid = fopen([pathname trialname ' - ' sensorNames{1,3} '.txt'],'a');
                            fprintf(fid,'%s\n',signalNamesString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,3} '.txt'],'a');
                            fprintf(fid,'%s\n',signalFormatsString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,3} '.txt'],'a');
                            fprintf(fid,'%s\n',signalUnitsString);
                            fclose(fid);
                        end
                        
                        dlmwrite([pathname trialname ' - ' sensorNames{1,3} '.txt'], newDataShimmer3, '-append', 'delimiter', '\t','precision',16);
                        sensorFlag(3) = 1;
                        
                        dataShimmer3 = [dataShimmer3; newDataShimmer3];
                        plotDataShimmer3 = [plotDataShimmer3; newDataShimmer3];
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer3 = dataShimmer3(:,timeIndex(2));
                        packetsReceivedShimmer3 = shimmer3.getpercentageofpacketsreceived(timeDataShimmer3);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer3 = (((mean(newDataShimmer3(:,battIndex(2)))/1000)-3.2)/(4.167-3.2))*100;
                        
                        % Plot Shimmer 3 data
                        if plotFlag(3)
                            figure(3)
                            if length(plotDataShimmer3)>numSamples(3)
                                plotDataShimmer3 = plotDataShimmer3((length(plotDataShimmer3)-numSamples(3)):end,:);
                            end
                            
                            if ~isempty(plotDataShimmer3)
                                if imuFlag(3)
                                    if get(lownoise_h,'Value')
                                        lnaccelIndex = [find(ismember(signalNames, 'Low Noise Accelerometer X')) find(ismember(signalNames, 'Low Noise Accelerometer Y')) find(ismember(signalNames, 'Low Noise Accelerometer Z'))];
                                        subplot(2,2,1)
                                        plot([plotDataShimmer3(:,lnaccelIndex(1)), plotDataShimmer3(:,lnaccelIndex(2)), plotDataShimmer3(:,lnaccelIndex(3))])
                                        axis([0 numSamples(3) -2 2])
                                        legend(char(signalNames{lnaccelIndex(1)}),char(signalNames{lnaccelIndex(2)}),char(signalNames{lnaccelIndex(3)}))
                                    end
                                    if get(widerange_h,'Value')
                                        wraccelIndex = [find(ismember(signalNames, 'Wide Range Accelerometer X')) find(ismember(signalNames, 'Wide Range Accelerometer Y')) find(ismember(signalNames, 'Wide Range Accelerometer Z'))];
                                        subplot(2,2,2)
                                        plot([plotDataShimmer3(:,wraccelIndex(1)), plotDataShimmer3(:,wraccelIndex(2)), plotDataShimmer3(:,wraccelIndex(3))])
                                        axis([0 numSamples(3) -wr_axisrange wr_axisrange])
                                        legend(char(signalNames{wraccelIndex(1)}),char(signalNames{wraccelIndex(2)}),char(signalNames{wraccelIndex(3)}))
                                    end
                                    gyroIndex = [find(ismember(signalNames, 'Gyroscope X')) find(ismember(signalNames, 'Gyroscope Y')) find(ismember(signalNames, 'Gyroscope Z'))];
                                    subplot(2,2,3)
                                    plot([plotDataShimmer3(:,gyroIndex(1)), plotDataShimmer3(:,gyroIndex(2)), plotDataShimmer3(:,gyroIndex(3))])
                                    axis([0 numSamples(3) -gyro_axisrange gyro_axisrange])
                                    legend(char(signalNames{gyroIndex(1)}),char(signalNames{gyroIndex(2)}),char(signalNames{gyroIndex(3)}))
                                    
                                    magIndex = [find(ismember(signalNames, 'Magnetometer X')) find(ismember(signalNames, 'Magnetometer Y')) find(ismember(signalNames, 'Magnetometer Z'))];
                                    subplot(2,2,4)
                                    plot([plotDataShimmer3(:,magIndex(1)), plotDataShimmer3(:,magIndex(2)), plotDataShimmer3(:,magIndex(3))])
                                    axis([0 numSamples(3) -mag_axisrange mag_axisrange])
                                    legend(char(signalNames{magIndex(1)}),char(signalNames{magIndex(2)}),char(signalNames{magIndex(3)}))
                                end
                                if emgFlag(3)
                                    emgIndex = [find(ismember(signalNames, 'EMG CH1')), find(ismember(signalNames, 'EMG CH2'))];
                                    subplot(2,1,1)                                    
                                    temptime = timeDataShimmer3(2:end);
                                    TV = (temptime-temptime(1))/1000;
                                    plot(butterfilt(plotDataShimmer3(:,emgIndex(1)),'bandpass',[10 400],4,TV))
                                    axis([0 numSamples(3) -5 5])
                                    legend(char(signalNames{emgIndex(1)}))
                                    subplot(2,1,2)
                                    plot(butterfilt(plotDataShimmer3(:,emgIndex(2)),'bandpass',[10 400],4,TV))
                                    axis([0 numSamples(3) -5 5])
                                    legend(char(signalNames{emgIndex(2)}))
                                end
                            end
                            if firsttime3
                                figtitle('Shimmer 3 - BTID 399C')
                            end
                        end
                    end
                end
                
                %% Shimmer 4 (BTID 3A1E - ExG unit)
                if shimmersSelected(4)
                    [newDataShimmer4,signalNames,signalFormats,signalUnits]=shimmer4.getdata('a');
                    if ~isempty(newDataShimmer4)
                        if firsttime==true
                            sensorNamesString = char(sensorNames(1,4));
                            signalNamesString = char(signalNames(1,1));
                            signalFormatsString = char(signalFormats(1,1));
                            signalUnitsString = char(signalUnits(1,1));
                            for i=2:length(signalNames)
                                sensorNamesString = [sensorNamesString char(9) char(sensorNames(1,4))];
                                signalNamesString = [signalNamesString char(9) char(signalNames(1,i))];
                                signalFormatsString = [signalFormatsString char(9) char(signalFormats(1,i))];
                                signalUnitsString = [signalUnitsString char(9) char(signalUnits(1,i))];
                            end
                            
                            dlmwrite([pathname trialname ' - ' sensorNames{1,4} '.txt'], sensorNamesString, '%s')
                            
                            fid = fopen([pathname trialname ' - ' sensorNames{1,4} '.txt'],'a');
                            fprintf(fid,'%s\n',signalNamesString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,4} '.txt'],'a');
                            fprintf(fid,'%s\n',signalFormatsString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,4} '.txt'],'a');
                            fprintf(fid,'%s\n',signalUnitsString);
                            fclose(fid);
                        end
                        
                        dlmwrite([pathname trialname ' - ' sensorNames{1,4} '.txt'], newDataShimmer4, '-append', 'delimiter', '\t','precision',16);
                        sensorFlag(4) = 1;
                        
                        dataShimmer4 = [dataShimmer4; newDataShimmer4];
                        plotDataShimmer4 = [plotDataShimmer4; newDataShimmer4];
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer4 = dataShimmer4(:,timeIndex(2));
                        packetsReceivedShimmer4 = shimmer4.getpercentageofpacketsreceived(timeDataShimmer4);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer4 = (((mean(newDataShimmer4(:,battIndex(2)))/1000)-3.2)/(4.167-3.2))*100;
                        
                         % Plot Shimmer 4 data
                        if plotFlag(4)
                            figure(4)
                            if length(plotDataShimmer4)>numSamples(4)
                                plotDataShimmer4 = plotDataShimmer4((length(plotDataShimmer4)-numSamples(4)):end,:);
                            end
                            
                            if ~isempty(plotDataShimmer4)
                                if imuFlag(4)
                                    if get(lownoise_h,'Value')
                                        lnaccelIndex = [find(ismember(signalNames, 'Low Noise Accelerometer X')) find(ismember(signalNames, 'Low Noise Accelerometer Y')) find(ismember(signalNames, 'Low Noise Accelerometer Z'))];
                                        subplot(2,2,1)
                                        plot([plotDataShimmer4(:,lnaccelIndex(1)), plotDataShimmer4(:,lnaccelIndex(2)), plotDataShimmer4(:,lnaccelIndex(3))])
                                        axis([0 numSamples(4) -2*g 2*g])
                                        legend(char(signalNames{lnaccelIndex(1)}),char(signalNames{lnaccelIndex(2)}),char(signalNames{lnaccelIndex(3)}))
                                    end
                                    if get(widerange_h,'Value')
                                        wraccelIndex = [find(ismember(signalNames, 'Wide Range Accelerometer X')) find(ismember(signalNames, 'Wide Range Accelerometer Y')) find(ismember(signalNames, 'Wide Range Accelerometer Z'))];
                                        subplot(2,2,2)
                                        plot([plotDataShimmer4(:,wraccelIndex(1)), plotDataShimmer4(:,wraccelIndex(2)), plotDataShimmer4(:,wraccelIndex(3))])
                                        axis([0 numSamples(4) -wr_axisrange wr_axisrange])
                                        legend(char(signalNames{wraccelIndex(1)}),char(signalNames{wraccelIndex(2)}),char(signalNames{wraccelIndex(3)}))
                                    end
                                    gyroIndex = [find(ismember(signalNames, 'Gyroscope X')) find(ismember(signalNames, 'Gyroscope Y')) find(ismember(signalNames, 'Gyroscope Z'))];
                                    subplot(2,2,3)
                                    plot([plotDataShimmer4(:,gyroIndex(1)), plotDataShimmer4(:,gyroIndex(2)), plotDataShimmer4(:,gyroIndex(3))])
                                    axis([0 numSamples(4) -gyro_axisrange gyro_axisrange])
                                    legend(char(signalNames{gyroIndex(1)}),char(signalNames{gyroIndex(2)}),char(signalNames{gyroIndex(3)}))
                                    
                                    magIndex = [find(ismember(signalNames, 'Magnetometer X')) find(ismember(signalNames, 'Magnetometer Y')) find(ismember(signalNames, 'Magnetometer Z'))];
                                    subplot(2,2,4)
                                    plot([plotDataShimmer4(:,magIndex(1)), plotDataShimmer4(:,magIndex(2)), plotDataShimmer4(:,magIndex(3))])
                                    axis([0 numSamples(4) -mag_axisrange mag_axisrange])
                                    legend(char(signalNames{magIndex(1)}),char(signalNames{magIndex(2)}),char(signalNames{magIndex(3)}))
                                end
                                if emgFlag(4)
                                    emgIndex = [find(ismember(signalNames, 'EMG CH1')), find(ismember(signalNames, 'EMG CH2'))];
                                    subplot(2,1,1)                                    
                                    temptime = timeDataShimmer4(2:end);
                                    TV = (temptime-temptime(1))/1000;
                                    plot(butterfilt(plotDataShimmer4(:,emgIndex(1)),'bandpass',[10 400],4,TV))
                                    axis([0 numSamples(4) -5 5])
                                    legend(char(signalNames{emgIndex(1)}))
                                    subplot(2,1,2)
                                    plot(butterfilt(plotDataShimmer4(:,emgIndex(2)),'bandpass',[10 400],4,TV))
                                    axis([0 numSamples(4) -5 5])
                                    legend(char(signalNames{emgIndex(2)}))
                                end
                            end
                            if firsttime4
                                figtitle('Shimmer 4 - BTID 3A1E')
                            end
                        end
                    end
                end
                
                %% Shimmer 5 (BTID 39F8 - ExG unit)
                if shimmersSelected(5)
                    [newDataShimmer5,signalNames,signalFormats,signalUnits]=shimmer5.getdata('a');
                    if ~isempty(newDataShimmer5)
                        if firsttime==true
                            sensorNamesString = char(sensorNames(1,5));
                            signalNamesString = char(signalNames(1,1));
                            signalFormatsString = char(signalFormats(1,1));
                            signalUnitsString = char(signalUnits(1,1));
                            for i=2:length(signalNames)
                                sensorNamesString = [sensorNamesString char(9) char(sensorNames(1,5))];
                                signalNamesString = [signalNamesString char(9) char(signalNames(1,i))];
                                signalFormatsString = [signalFormatsString char(9) char(signalFormats(1,i))];
                                signalUnitsString = [signalUnitsString char(9) char(signalUnits(1,i))];
                            end
                            
                            dlmwrite([pathname trialname ' - ' sensorNames{1,5} '.txt'], sensorNamesString, '%s')
                            
                            fid = fopen([pathname trialname ' - ' sensorNames{1,5} '.txt'],'a');
                            fprintf(fid,'%s\n',signalNamesString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,5} '.txt'],'a');
                            fprintf(fid,'%s\n',signalFormatsString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,5} '.txt'],'a');
                            fprintf(fid,'%s\n',signalUnitsString);
                            fclose(fid);
                        end
                        
                        dlmwrite([pathname trialname ' - ' sensorNames{1,5} '.txt'], newDataShimmer5, '-append', 'delimiter', '\t','precision',16);
                        sensorFlag(5) = 1;
                        
                        dataShimmer5 = [dataShimmer5; newDataShimmer5];
                        plotDataShimmer5 = [plotDataShimmer5; newDataShimmer5];
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer5 = dataShimmer5(:,timeIndex(2));
                        packetsReceivedShimmer5 = shimmer5.getpercentageofpacketsreceived(timeDataShimmer5);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer5 = (((mean(newDataShimmer5(:,battIndex(2)))/1000)-3.2)/(4.167-3.2))*100;
                        
                        % Plot Shimmer 5 data
                        if plotFlag(5)
                            figure(5)
                            if length(plotDataShimmer5)>numSamples(5)
                                plotDataShimmer5 = plotDataShimmer5((length(plotDataShimmer5)-numSamples(5)):end,:);
                            end
                            
                            if ~isempty(plotDataShimmer5)
                                if imuFlag(5)
                                    if get(lownoise_h,'Value')
                                        lnaccelIndex = [find(ismember(signalNames, 'Low Noise Accelerometer X')) find(ismember(signalNames, 'Low Noise Accelerometer Y')) find(ismember(signalNames, 'Low Noise Accelerometer Z'))];
                                        subplot(2,2,1)
                                        plot([plotDataShimmer5(:,lnaccelIndex(1)), plotDataShimmer5(:,lnaccelIndex(2)), plotDataShimmer5(:,lnaccelIndex(3))])
                                        axis([0 numSamples(5) -2 2])
                                        legend(char(signalNames{lnaccelIndex(1)}),char(signalNames{lnaccelIndex(2)}),char(signalNames{lnaccelIndex(3)}))
                                    end
                                    if get(widerange_h,'Value')
                                        wraccelIndex = [find(ismember(signalNames, 'Wide Range Accelerometer X')) find(ismember(signalNames, 'Wide Range Accelerometer Y')) find(ismember(signalNames, 'Wide Range Accelerometer Z'))];
                                        subplot(2,2,2)
                                        plot([plotDataShimmer5(:,wraccelIndex(1)), plotDataShimmer5(:,wraccelIndex(2)), plotDataShimmer5(:,wraccelIndex(3))])
                                        axis([0 numSamples(5) -wr_axisrange wr_axisrange])
                                        legend(char(signalNames{wraccelIndex(1)}),char(signalNames{wraccelIndex(2)}),char(signalNames{wraccelIndex(3)}))
                                    end
                                    gyroIndex = [find(ismember(signalNames, 'Gyroscope X')) find(ismember(signalNames, 'Gyroscope Y')) find(ismember(signalNames, 'Gyroscope Z'))];
                                    subplot(2,2,3)
                                    plot([plotDataShimmer5(:,gyroIndex(1)), plotDataShimmer5(:,gyroIndex(2)), plotDataShimmer5(:,gyroIndex(3))])
                                    axis([0 numSamples(5) -gyro_axisrange gyro_axisrange])
                                    legend(char(signalNames{gyroIndex(1)}),char(signalNames{gyroIndex(2)}),char(signalNames{gyroIndex(3)}))
                                    
                                    magIndex = [find(ismember(signalNames, 'Magnetometer X')) find(ismember(signalNames, 'Magnetometer Y')) find(ismember(signalNames, 'Magnetometer Z'))];
                                    subplot(2,2,4)
                                    plot([plotDataShimmer5(:,magIndex(1)), plotDataShimmer5(:,magIndex(2)), plotDataShimmer5(:,magIndex(3))])
                                    axis([0 numSamples(5) -mag_axisrange mag_axisrange])
                                    legend(char(signalNames{magIndex(1)}),char(signalNames{magIndex(2)}),char(signalNames{magIndex(3)}))
                                end
                                if emgFlag(5)
                                    emgIndex = [find(ismember(signalNames, 'EMG CH1')), find(ismember(signalNames, 'EMG CH2'))];
                                    subplot(2,1,1)                                    
                                    temptime = timeDataShimmer5(2:end);
                                    TV = (temptime-temptime(1))/1000;
                                    plot(butterfilt(plotDataShimmer5(:,emgIndex(1)),'bandpass',[10 400],4,TV))
                                    axis([0 numSamples(5) -5 5])
                                    legend(char(signalNames{emgIndex(1)}))
                                    subplot(2,1,2)
                                    plot(butterfilt(plotDataShimmer5(:,emgIndex(2)),'bandpass',[10 400],4,TV))
                                    axis([0 numSamples(5) -5 5])
                                    legend(char(signalNames{emgIndex(2)}))
                                end
                            end
                            if firsttime5
                                figtitle('Shimmer 5 - BTID 39F8')
                            end
                        end
                    end
                end
                
                %% Shimmer 6 (BTID 2BFD - GSR+ unit)
                if shimmersSelected(6)
                    [newDataShimmer6,signalNames,signalFormats,signalUnits]=shimmer6.getdata('a');
                    if ~isempty(newDataShimmer6)
                        if firsttime==true
                            sensorNamesString = char(sensorNames(1,6));
                            signalNamesString = char(signalNames(1,1));
                            signalFormatsString = char(signalFormats(1,1));
                            signalUnitsString = char(signalUnits(1,1));
                            for i=2:length(signalNames)
                                sensorNamesString = [sensorNamesString char(9) char(sensorNames(1,6))];
                                signalNamesString = [signalNamesString char(9) char(signalNames(1,i))];
                                signalFormatsString = [signalFormatsString char(9) char(signalFormats(1,i))];
                                signalUnitsString = [signalUnitsString char(9) char(signalUnits(1,i))];
                            end
                            
                            dlmwrite([pathname trialname ' - ' sensorNames{1,6} '.txt'], sensorNamesString, '%s')
                            
                            fid = fopen([pathname trialname ' - ' sensorNames{1,6} '.txt'],'a');
                            fprintf(fid,'%s\n',signalNamesString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,6} '.txt'],'a');
                            fprintf(fid,'%s\n',signalFormatsString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,6} '.txt'],'a');
                            fprintf(fid,'%s\n',signalUnitsString);
                            fclose(fid);
                        end
                        
                        dlmwrite([pathname trialname ' - ' sensorNames{1,6} '.txt'], newDataShimmer6, '-append', 'delimiter', '\t','precision',16);
                        sensorFlag(6) = 1;
                        
                        dataShimmer6 = [dataShimmer6; newDataShimmer6];
                        plotDataShimmer6 = [plotDataShimmer6; newDataShimmer6];
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer6 = dataShimmer6(:,timeIndex(2));
                        packetsReceivedShimmer6 = shimmer6.getpercentageofpacketsreceived(timeDataShimmer6);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer6 = (((mean(newDataShimmer6(:,battIndex(2)))/1000)-3.2)/(4.167-3.2))*100;
                        
                        % Plot Shimmer 6 data
                        if plotFlag(6)
                            figure(6)
                            if length(plotDataShimmer6)>numSamples(6)
                                plotDataShimmer6 = plotDataShimmer6((length(plotDataShimmer6)-numSamples(6)):end,:);
                            end
                            
                            if ~isempty(plotDataShimmer6)
                                if imuFlag(6)
                                    if get(lownoise_h,'Value')
                                        lnaccelIndex = [find(ismember(signalNames, 'Low Noise Accelerometer X')) find(ismember(signalNames, 'Low Noise Accelerometer Y')) find(ismember(signalNames, 'Low Noise Accelerometer Z'))];
                                        subplot(2,3,1)
                                        plot([plotDataShimmer6(:,lnaccelIndex(1)), plotDataShimmer6(:,lnaccelIndex(2)), plotDataShimmer6(:,lnaccelIndex(3))])
                                        axis([0 numSamples(6) -2 2])
                                        legend(char(signalNames{lnaccelIndex(1)}),char(signalNames{lnaccelIndex(2)}),char(signalNames{lnaccelIndex(3)}))
                                    end
                                    if get(widerange_h,'Value')
                                        wraccelIndex = [find(ismember(signalNames, 'Wide Range Accelerometer X')) find(ismember(signalNames, 'Wide Range Accelerometer Y')) find(ismember(signalNames, 'Wide Range Accelerometer Z'))];
                                        subplot(2,3,2)
                                        plot([plotDataShimmer6(:,wraccelIndex(1)), plotDataShimmer6(:,wraccelIndex(2)), plotDataShimmer6(:,wraccelIndex(3))])
                                        axis([0 numSamples(6) -wr_axisrange wr_axisrange])
                                        legend(char(signalNames{wraccelIndex(1)}),char(signalNames{wraccelIndex(2)}),char(signalNames{wraccelIndex(3)}))
                                    end
                                    gyroIndex = [find(ismember(signalNames, 'Gyroscope X')) find(ismember(signalNames, 'Gyroscope Y')) find(ismember(signalNames, 'Gyroscope Z'))];
                                    subplot(2,3,4)
                                    plot([plotDataShimmer6(:,gyroIndex(1)), plotDataShimmer6(:,gyroIndex(2)), plotDataShimmer6(:,gyroIndex(3))])
                                    axis([0 numSamples(6) -gyro_axisrange gyro_axisrange])
                                    legend(char(signalNames{lnaccelIndex(1)}),char(signalNames{lnaccelIndex(2)}),char(signalNames{lnaccelIndex(3)}))
                                    
                                    magIndex = [find(ismember(signalNames, 'Magnetometer X')) find(ismember(signalNames, 'Magnetometer Y')) find(ismember(signalNames, 'Magnetometer Z'))];
                                    subplot(2,3,5)
                                    plot([plotDataShimmer6(:,magIndex(1)), plotDataShimmer6(:,magIndex(2)), plotDataShimmer6(:,magIndex(3))])
                                    axis([0 numSamples(6) -mag_axisrange mag_axisrange])
                                    legend(char(signalNames{magIndex(1)}),char(signalNames{magIndex(2)}),char(signalNames{magIndex(3)}))
                                end
                                if gsrFlag
                                    gsrIndex = [find(ismember(signalNames, 'GSR'))];
                                    subplot(2,3,3)
                                    plot([plotDataShimmer6(:,gsrIndex(1))])
                                    axis([0 numSamples -gyro_axisrange gyro_axisrange])
                                    legend(char(signalNames{gsrIndex(1)}))
                                end
                            end
                            if firsttime6
                                figtitle('Shimmer 6 - BTID 2BFD')
                            end
                        end
                    end
                end
                
                %% Shimmer 7 (BTID 38F5 - PROTO3 unit)
                if shimmersSelected(7)
                    [newDataShimmer7,signalNames,signalFormats,signalUnits]=shimmer7.getdata('a');
                    if ~isempty(newDataShimmer7)
                        if firsttime==true
                            sensorNamesString = char(sensorNames(1,7));
                            signalNamesString = char(signalNames(1,1));
                            signalFormatsString = char(signalFormats(1,1));
                            signalUnitsString = char(signalUnits(1,1));
                            for i=2:length(signalNames)
                                sensorNamesString = [sensorNamesString char(9) char(sensorNames(1,7))];
                                signalNamesString = [signalNamesString char(9) char(signalNames(1,i))];
                                signalFormatsString = [signalFormatsString char(9) char(signalFormats(1,i))];
                                signalUnitsString = [signalUnitsString char(9) char(signalUnits(1,i))];
                            end
                            
                            dlmwrite([pathname trialname ' - ' sensorNames{1,7} '.txt'], sensorNamesString, '%s')
                            
                            fid = fopen([pathname trialname ' - ' sensorNames{1,7} '.txt'],'a');
                            fprintf(fid,'%s\n',signalNamesString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,7} '.txt'],'a');
                            fprintf(fid,'%s\n',signalFormatsString);
                            fclose(fid);
                            fid = fopen([pathname trialname ' - ' sensorNames{1,7} '.txt'],'a');
                            fprintf(fid,'%s\n',signalUnitsString);
                            fclose(fid);
                        end
                        
                        dlmwrite([pathname trialname ' - ' sensorNames{1,7} '.txt'], newDataShimmer7, '-append', 'delimiter', '\t','precision',16);
                        sensorFlag(7) = 1;
                        
                        dataShimmer7 = [dataShimmer7; newDataShimmer7];
                        plotDataShimmer7 = [plotDataShimmer7; newDataShimmer7];
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer7 = dataShimmer7(:,timeIndex(2));
                        packetsReceivedShimmer7 = shimmer7.getpercentageofpacketsreceived(timeDataShimmer7);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer7 = (((mean(newDataShimmer7(:,battIndex(2)))/1000)-3.2)/(4.167-3.2))*100;
                        
                        % Plot Shimmer 7 data
                        if plotFlag(7)
                            figure(7)
                            if length(plotDataShimmer7)>numSamples(7)
                                plotDataShimmer7 = plotDataShimmer7((length(plotDataShimmer7)-numSamples(7)):end,:);
                            end
                            
                            if ~isempty(plotDataShimmer7)
                                if imuFlag(7)
                                    if get(lownoise_h,'Value')
                                        lnaccelIndex = [find(ismember(signalNames, 'Low Noise Accelerometer X')) find(ismember(signalNames, 'Low Noise Accelerometer Y')) find(ismember(signalNames, 'Low Noise Accelerometer Z'))];
                                        subplot(2,2,1)
                                        plot([plotDataShimmer7(:,lnaccelIndex(1)), plotDataShimmer7(:,lnaccelIndex(2)), plotDataShimmer7(:,lnaccelIndex(3))])
                                        axis([0 numSamples(7) -2 2])
                                        legend(char(signalNames{lnaccelIndex(1)}),char(signalNames{lnaccelIndex(2)}),char(signalNames{lnaccelIndex(3)}))
                                    end
                                    if get(widerange_h,'Value')
                                        wraccelIndex = [find(ismember(signalNames, 'Wide Range Accelerometer X')) find(ismember(signalNames, 'Wide Range Accelerometer Y')) find(ismember(signalNames, 'Wide Range Accelerometer Z'))];
                                        subplot(2,2,2)
                                        plot([plotDataShimmer7(:,wraccelIndex(1)), plotDataShimmer7(:,wraccelIndex(2)), plotDataShimmer7(:,wraccelIndex(3))])
                                        axis([0 numSamples(7) -wr_axisrange wr_axisrange])
                                        legend(char(signalNames{wraccelIndex(1)}),char(signalNames{wraccelIndex(2)}),char(signalNames{wraccelIndex(3)}))
                                    end
                                    gyroIndex = [find(ismember(signalNames, 'Gyroscope X')) find(ismember(signalNames, 'Gyroscope Y')) find(ismember(signalNames, 'Gyroscope Z'))];
                                    subplot(2,2,3)
                                    plot([plotDataShimmer7(:,gyroIndex(1)), plotDataShimmer7(:,gyroIndex(2)), plotDataShimmer7(:,gyroIndex(3))])
                                    axis([0 numSamples(7) -gyro_axisrange gyro_axisrange])
                                    legend(char(signalNames{gyroIndex(1)}),char(signalNames{gyroIndex(2)}),char(signalNames{gyroIndex(3)}))
                                    
                                    magIndex = [find(ismember(signalNames, 'Magnetometer X')) find(ismember(signalNames, 'Magnetometer Y')) find(ismember(signalNames, 'Magnetometer Z'))];
                                    subplot(2,2,4)
                                    plot([plotDataShimmer7(:,magIndex(1)), plotDataShimmer7(:,magIndex(2)), plotDataShimmer7(:,magIndex(3))])
                                    axis([0 numSamples(7) -mag_axisrange mag_axisrange])
                                    legend(char(signalNames{magIndex(1)}),char(signalNames{magIndex(2)}),char(signalNames{magIndex(3)}))
                                end
                            end
                            if firsttime7
                                figtitle('Shimmer 7 - BTID 38F5')
                            end
                        end
                        
                    end
                end
                
                %% Update GUI
                tabledata = [packetsReceivedShimmer1 battShimmer1; packetsReceivedShimmer2 battShimmer2; packetsReceivedShimmer3 battShimmer3; packetsReceivedShimmer4 battShimmer4; packetsReceivedShimmer5 battShimmer5; packetsReceivedShimmer6 battShimmer6; packetsReceivedShimmer7 battShimmer7];
                set(table1_h,'Data',tabledata)
                
                elapsedTime = elapsedTime + toc;
                set(elapsedtime_h,'String',num2str(elapsedTime))
                tic;
                
                firsttime=false;
            end
            
            elapsedTime = elapsedTime + toc;
            set(elapsedtime_h,'String',num2str(elapsedTime))
            
            % Stop streaming
            if (shimmersSelected(1)), shimmer1.stop; end;
            if (shimmersSelected(2)), shimmer2.stop; end;
            if (shimmersSelected(3)), shimmer3.stop; end;
            if (shimmersSelected(4)), shimmer4.stop; end;
            if (shimmersSelected(5)), shimmer5.stop; end;
            if (shimmersSelected(6)), shimmer6.stop; end;
            if (shimmersSelected(7)), shimmer7.stop; end;
            
            % Save trial data to local MAT files
            SortShimmerDataAPI(trialname,sensorFlag) 
            
        else
            if (shimmersSelected(1)), shimmer1.stop; end;
            if (shimmersSelected(2)), shimmer2.stop; end;
            if (shimmersSelected(3)), shimmer3.stop; end;
            if (shimmersSelected(4)), shimmer4.stop; end;
            if (shimmersSelected(5)), shimmer5.stop; end;
            if (shimmersSelected(6)), shimmer6.stop; end;
            if (shimmersSelected(7)), shimmer7.stop; end;
        end
        
    end
    % Re-enable sensor parameters
    set(emgrate_h,'Enable','on')
    set(emgresolution_h,'Enable','on')
    set(emggain_h,'Enable','on')
    set(gsr_h,'Enable','on')
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
   
    
    if (shimmersSelected(1)), shimmer1.disconnect; end;
    if (shimmersSelected(2)), shimmer2.disconnect; end;
    if (shimmersSelected(3)), shimmer3.disconnect; end;
    if (shimmersSelected(4)), shimmer4.disconnect; end;
    if (shimmersSelected(5)), shimmer5.disconnect; end;
    if (shimmersSelected(6)), shimmer6.disconnect; end;
    if (shimmersSelected(7)), shimmer7.disconnect; end;
    
    clear all;
    
end

end