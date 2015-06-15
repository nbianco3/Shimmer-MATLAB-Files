function RecordAllUnits(trialname)
clc; beep off;

% Define handles
handles = guihandles(gcbo);
    
start_h = handles.startbutton;
stop_h = handles.stopbutton;
disconnect_h = handles.disconnectbutton;
emg_h = handles.emgcheckbox;
emgrate_h = handles.emgratemenu;
emgresolution_h = handles.emgresolutionmenu;
emggain_h = handles.emggainmenu;
gsr_h = handles.gsrcheckbox;
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
table1_h = handles.uitable1;

sensorFlag = [0 0 0 0 0 0 0];

pathname = 'C:\Users\Nick\Documents\Parkinson Mobility Study\Shimmer MATLAB Files\Shimmer-MATLAB-Files\Trials\';

disp('All')

buffer = 0.5; % seconds

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
waitfor(params_h,'Value',1)

% EMG collection
switch get(emg_h,'Value')
    case 1
        exgFlag = true; % default
    case 0
        exgFlag = false;
end
set(emg_h,'Enable','off')

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

% Wide Range Acclerometer range (±g)
contents = cellstr(get(accelrange_h,'String'));
switch contents{get(accelrange_h,'Value')}
    case '2 (default)'
        accel_range = 0;
    case '4'
        accel_range = 1;
    case '8'
        accel_range = 2;
    case '16'
        accel_range = 3;
end
set(accelrange_h,'Enable','off')

% Gyroscope range (±°/s)
contents = cellstr(get(gyrorange_h,'String'));
switch contents{get(gyrorange_h,'Value')}
    case '250'
        gyro_range = 0;
    case '500 (default)'
        gyro_range = 1;
    case '1000'
        gyro_range = 2;
    case '2000'
        gyro_range = 3;
end
set(gyrorange_h,'Enable','off')

% Magnetometer range (± Ga)
contents = cellstr(get(magrange_h,'String'));
switch contents{get(magrange_h,'Value')}
    case '1.3 (default)'
        mag_range = 1;
    case '1.9'
        mag_range = 2;
    case '2.5'
        mag_range = 3;
    case '4.0'
        mag_range = 4;
    case '4.7'
        mag_range = 5;
    case '5.6'
        mag_range = 6;
    case '8.1'
        mag_range = 7;
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
    case '1000 (default)'
        exg_rate = 3;
    case '2000'
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

% General sampling rate (Hz)
Fs = str2double(get(samprate_h,'String'));
set(samprate_h,'Enable','off')

set(enable2BD1_h,'Enable','off')
set(enable3A45_h,'Enable','off')
set(enable399C_h,'Enable','off')
set(enable3A1E_h,'Enable','off')
set(enable39F8_h,'Enable','off')
set(enable2BFD_h,'Enable','off')
set(enable38F5_h,'Enable','off')

set(params_h,'Enable','off')

% Connect Shimmers
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
    
    % Shimmer 1 (BTID 2BD1 - IMU unit)
    if shimmersSelected(1)
        shimmer1.setbaudrate(baud_rate);
        shimmer1.setinternalboard('None');
        shimmer1.disableallsensors;
        
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
               
        switch get(sampratebool_h,'Value')
            case 0
                shimmer1.setaccelrate(accel_rate);
                shimmer1.setgyrorate(gyro_rate);
                shimmer1.setmagrate(mag_rate);
            case 1
                shimmer1.setsamplingrate(Fs);
        end
        
        shimmer1.setaccelrange(accel_range);
        shimmer1.setgyrorange(gyro_range);
        shimmer1.setmagrange(mag_range);
    end
    
    % Shimmer 2 (BTID 3A45 - Shimmer3 unit)
    if shimmersSelected(2)
        shimmer2.setbaudrate(baud_rate);
        shimmer2.disableallsensors;
        if exgFlag == true
            shimmer2.setinternalboard('EMG');
            contents = cellstr(get(emgresolution_h,'String'));
            switch contents{get(emgresolution_h,'Value')}
                case '16 BIT'
                    if get(lownoise_h,'Value') && get(widerange_h,'Value')
                        if pressureFlag
                            shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                        else
                            shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                        end
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
                case '24 BIT (default)'
                    if get(lownoise_h,'Value') && get(widerange_h,'Value')
                        if pressureFlag
                            shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                        else
                            shimmer2.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                        end
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
                    shimmer2.setexggain(emg_gain,1,1);
                    shimmer2.setexggain(emg_gain,1,2);
            end
        elseif exgFlag==false
            shimmer2.setinternalboard('None');
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
        end
        
        if pressureFlag
            shimmer2.setpressureresolution(pressure_resolution);
        end
        
        switch get(sampratebool_h,'Value')
            case 0
                shimmer2.setaccelrate(accel_rate);
                shimmer2.setgyrorate(gyro_rate);
                shimmer2.setmagrate(mag_rate);
                shimmer2.setexgrate(exg_rate,1);
                shimmer2.setexgrate(exg_rate,2);
            case 1
                shimmer2.setsamplingrate(Fs);
        end
        
        shimmer2.setaccelrange(accel_range);
        shimmer2.setgyrorange(gyro_range);
        shimmer2.setmagrange(mag_range);
        
    end
    
    % Shimmer 3 (BTID 399C - Shimmer3 unit)
    if shimmersSelected(3)
        shimmer3.setbaudrate(baud_rate);
        shimmer3.disableallsensors;
        if exgFlag == true
            shimmer3.setinternalboard('EMG');
            contents = cellstr(get(emgresolution_h,'String'));
            switch contents{get(emgresolution_h,'Value')}
                case '16 BIT'
                    if get(lownoise_h,'Value') && get(widerange_h,'Value')
                        if pressureFlag
                            shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                        else
                            shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                        end
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
                case '24 BIT (default)'
                    if get(lownoise_h,'Value') && get(widerange_h,'Value')
                        if pressureFlag
                            shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                        else
                            shimmer3.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                        end
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
                    shimmer3.setexggain(emg_gain,1,1);
                    shimmer3.setexggain(emg_gain,1,2);
            end
        elseif exgFlag==false
            shimmer3.setinternalboard('None');
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
        end
        
        if pressureFlag
            shimmer3.setpressureresolution(pressure_resolution);
        end
        
        switch get(sampratebool_h,'Value')
            case 0
                shimmer3.setaccelrate(accel_rate);
                shimmer3.setgyrorate(gyro_rate);
                shimmer3.setmagrate(mag_rate);
                shimmer3.setexgrate(exg_rate,1);
                shimmer3.setexgrate(exg_rate,2);
            case 1
                shimmer3.setsamplingrate(Fs);
        end
        
        shimmer3.setaccelrange(accel_range);
        shimmer3.setgyrorange(gyro_range);
        shimmer3.setmagrange(mag_range);
        
    end
    
    % Shimmer 4 (BTID 3A1E - Shimmer3 unit)
    if shimmersSelected(4)
        shimmer4.setbaudrate(baud_rate);
        shimmer4.disableallsensors;
        if exgFlag == true
            shimmer4.setinternalboard('EMG');
            contents = cellstr(get(emgresolution_h,'String'));
            switch contents{get(emgresolution_h,'Value')}
                case '16 BIT'
                    if get(lownoise_h,'Value') && get(widerange_h,'Value')
                        if pressureFlag
                            shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                        else
                            shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                        end
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
                case '24 BIT (default)'
                    if get(lownoise_h,'Value') && get(widerange_h,'Value')
                        if pressureFlag
                            shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                        else
                            shimmer4.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                        end
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
                    shimmer4.setexggain(emg_gain,1,1);
                    shimmer4.setexggain(emg_gain,1,2);
            end
        elseif exgFlag==false
            shimmer4.setinternalboard('None');
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
        end
        
        if pressureFlag
            shimmer4.setpressureresolution(pressure_resolution);
        end
        
        switch get(sampratebool_h,'Value')
            case 0
                shimmer4.setaccelrate(accel_rate);
                shimmer4.setgyrorate(gyro_rate);
                shimmer4.setmagrate(mag_rate);
                shimmer4.setexgrate(exg_rate,1);
                shimmer4.setexgrate(exg_rate,2);
            case 1
                shimmer4.setsamplingrate(Fs);
        end
        
        shimmer4.setaccelrange(accel_range);
        shimmer4.setgyrorange(gyro_range);
        shimmer4.setmagrange(mag_range);
        
    end
    
    % Shimmer 5 (BTID 39F8 - Shimmer3 unit)
    if shimmersSelected(5)
        shimmer5.setbaudrate(baud_rate);
        shimmer5.disableallsensors;
        if exgFlag == true
            shimmer5.setinternalboard('EMG');
            contents = cellstr(get(emgresolution_h,'String'));
            switch contents{get(emgresolution_h,'Value')}
                case '16 BIT'
                    if get(lownoise_h,'Value') && get(widerange_h,'Value')
                        if pressureFlag
                            shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1,macros.PRESSURE,1);
                        else
                            shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG16BIT,1);
                        end
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
                case '24 BIT (default)'
                    if get(lownoise_h,'Value') && get(widerange_h,'Value')
                        if pressureFlag
                            shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1,macros.PRESSURE,1);
                        else
                            shimmer5.setenabledsensors(macros.LNACCEL,1,macros.WRACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1,macros.EMG24BIT,1);
                        end
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
                    shimmer5.setexggain(emg_gain,1,1);
                    shimmer5.setexggain(emg_gain,1,2);
            end
        elseif exgFlag==false
            shimmer2.setinternalboard('None');
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
        end
        
        if pressureFlag
            shimmer5.setpressureresolution(pressure_resolution);
        end
        
        switch get(sampratebool_h,'Value')
            case 0
                shimmer5.setaccelrate(accel_rate);
                shimmer5.setgyrorate(gyro_rate);
                shimmer5.setmagrate(mag_rate);
                shimmer5.setexgrate(exg_rate,1);
                shimmer5.setexgrate(exg_rate,2);
            case 1
                shimmer5.setsamplingrate(Fs);
        end
        
        shimmer5.setaccelrange(accel_range);
        shimmer5.setgyrorange(gyro_range);
        shimmer5.setmagrange(mag_range);
        
    end
    
    % Shimmer 6 (BTID 2BFD - GSR+ unit)
    if shimmersSelected(6)
        shimmer6.setbaudrate(baud_rate);
        shimmer6.disableallsensors;
        if gsrFlag == true
            shimmer6.setinternalboard('GSR');
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
            
            shimmer6.setgsrrange(gsr_range);
            
        elseif gsrFlag == false
            shimmer6.setinternalboard('None');
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
        end
        
        if pressureFlag
            shimmer6.setpressureresolution(pressure_resolution);
        end
        
        switch get(sampratebool_h,'Value')
            case 0
                shimmer6.setaccelrate(accel_rate);
                shimmer6.setgyrorate(gyro_rate);
                shimmer6.setmagrate(mag_rate);
            case 1
                shimmer6.setsamplingrate(Fs);
        end
        
        shimmer6.setaccelrange(accel_range);
        shimmer6.setgyrorange(gyro_range);
        shimmer6.setmagrange(mag_range);
        
    end
    
    %  Shimmer 7 (BTID 38F5 - PROTO3 unit)
    if shimmersSelected(7)
        shimmer7.setbaudrate(baud_rate);
        shimmer7.setinternalboard('None');
        shimmer7.disableallsensors;
        
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
               
        switch get(sampratebool_h,'Value')
            case 0
                shimmer7.setaccelrate(accel_rate);
                shimmer7.setgyrorate(gyro_rate);
                shimmer7.setmagrate(mag_rate);
            case 1
                shimmer7.setsamplingrate(Fs);
        end
        
        shimmer7.setaccelrange(accel_range);
        shimmer7.setgyrorange(gyro_range);
        shimmer7.setmagrange(mag_range);
    end
    
    %% Data Collection
    
    disp('Release <Disconnect> button if necessary...')
    waitfor(disconnect_h,'Value',0)
    
    while ~get(disconnect_h,'Value')
        
        disp('Release <Stop> button if necessary...')
        waitfor(stop_h,'Value',0)
        disp('Press <Start> to begin recording trial...')
        waitfor(start_h,'Value',1)
        
        if get(disconnect_h,'Value')
            disp('Disconnecting...')
            break;
        end
        
        startCount=0;
        if (shimmersSelected(1)), if shimmer1.start, startCount=startCount+1; end; end;
        if (shimmersSelected(2)), if shimmer2.start, startCount=startCount+1; end; end;
        if (shimmersSelected(3)), if shimmer3.start, startCount=startCount+1; end; end;
        if (shimmersSelected(4)), if shimmer4.start, startCount=startCount+1; end; end;
        if (shimmersSelected(5)), if shimmer5.start, startCount=startCount+1; end; end;
        if (shimmersSelected(6)), if shimmer6.start, startCount=startCount+1; end; end;
        if (shimmersSelected(7)), if shimmer7.start, startCount=startCount+1; end; end;
        
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
            
            while ~get(stop_h,'Value')
                
                pause(buffer)
                
                % Read in Shimmer 1 data and header files
                if shimmersSelected(1)
                    [newDataShimmer1,signalNames,signalFormats,signalUnits]=shimmer1.getdata('c');
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
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer1 = dataShimmer1(:,timeIndex);
                        packetsReceivedShimmer1 = shimmer1.getpercentageofpacketsreceived(timeDataShimmer1);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer1 = (((mean(newDataShimmer1(:,battIndex))/1000)-3.2)/(4.167-3.2))*100;
                    end
                end
                
                % Read in Shimmer 2 data and header files
                if shimmersSelected(2)
                    [newDataShimmer2,signalNames,signalFormats,signalUnits]=shimmer2.getdata('c');
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
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer2 = dataShimmer2(:,timeIndex);
                        packetsReceivedShimmer2 = shimmer2.getpercentageofpacketsreceived(timeDataShimmer2);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer2 = (((mean(newDataShimmer2(:,battIndex))/1000)-3.2)/(4.167-3.2))*100;
                    end
                end
                
                
                % Read in Shimmer 3 data and header files
                if shimmersSelected(3)
                    [newDataShimmer3,signalNames,signalFormats,signalUnits]=shimmer3.getdata('c');
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
                        
                        dlmwrite([pathname trialname ' - ' sensorNames{1,3} '.txt'], newDataShimmer2, '-append', 'delimiter', '\t','precision',16);
                        sensorFlag(3) = 1;
                        
                        dataShimmer3 = [dataShimmer3; newDataShimmer3];
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer3 = dataShimmer3(:,timeIndex);
                        packetsReceivedShimmer3 = shimmer3.getpercentageofpacketsreceived(timeDataShimmer3);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer3 = (((mean(newDataShimmer3(:,battIndex))/1000)-3.2)/(4.167-3.2))*100;
                    end
                end
                
                % Read in Shimmer 4 data and header files
                if shimmersSelected(4)
                    [newDataShimmer4,signalNames,signalFormats,signalUnits]=shimmer4.getdata('c');
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
                        
                        dlmwrite([pathname trialname ' - ' sensorNames{1,4} '.txt'], newDataShimmer2, '-append', 'delimiter', '\t','precision',16);
                        sensorFlag(4) = 1;
                        
                        dataShimmer4 = [dataShimmer4; newDataShimmer4];
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer4 = dataShimmer4(:,timeIndex);
                        packetsReceivedShimmer4 = shimmer4.getpercentageofpacketsreceived(timeDataShimmer4);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer4 = (((mean(newDataShimmer4(:,battIndex))/1000)-3.2)/(4.167-3.2))*100;
                    end
                end
                
                % Read in Shimmer 5 data and header files
                if shimmersSelected(5)
                    [newDataShimmer5,signalNames,signalFormats,signalUnits]=shimmer5.getdata('c');
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
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer5 = dataShimmer5(:,timeIndex);
                        packetsReceivedShimmer5 = shimmer5.getpercentageofpacketsreceived(timeDataShimmer5);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer5 = (((mean(newDataShimmer5(:,battIndex))/1000)-3.2)/(4.167-3.2))*100;
                    end
                end
                
                % Read in Shimmer 6 data and header files
                if shimmersSelected(6)
                    [newDataShimmer6,signalNames,signalFormats,signalUnits]=shimmer6.getdata('c');
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
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer6 = dataShimmer6(:,timeIndex);
                        packetsReceivedShimmer6 = shimmer6.getpercentageofpacketsreceived(timeDataShimmer6);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer6 = (((mean(newDataShimmer6(:,battIndex))/1000)-3.2)/(4.167-3.2))*100;
                    end
                end
                
                % Read in Shimmer 2 data and header files
                if shimmersSelected(7)
                    [newDataShimmer7,signalNames,signalFormats,signalUnits]=shimmer7.getdata('c');
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
                        timeIndex = find(ismember(signalNames, 'Time Stamp'));
                        timeDataShimmer7 = dataShimmer7(:,timeIndex);
                        packetsReceivedShimmer7 = shimmer7.getpercentageofpacketsreceived(timeDataShimmer7);
                        battIndex = find(ismember(signalNames,'VSenseBatt'));
                        battShimmer7 = (((mean(newDataShimmer7(:,battIndex))/1000)-3.2)/(4.167-3.2))*100;
                    end
                end
                
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
    set(emg_h,'Enable','on')
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
    set(enable2BD1_h,'Enable','on')
    set(enable3A45_h,'Enable','on')
    set(enable399C_h,'Enable','on')
    set(enable3A1E_h,'Enable','on')
    set(enable39F8_h,'Enable','on')
    set(enable2BFD_h,'Enable','on')
    set(enable38F5_h,'Enable','on')
    
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