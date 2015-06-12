function RecordAllUnits(trialname)
clc; beep off;

% Define handles
handles = guihandles(gcbo);
start_h = handles.startbutton;
stop_h = handles.stopbutton;
disconnect_h = handles.disconnectbutton;
table1_h = handles.uitable1;
emg_h = handles.emgcheckbox;
gsr_h = handles.gsrcheckbox;
accelrange_h = handles.accelrangemenu;
gyrorange_h = handles.gyrorangemenu;
magrange_h = handles.magrangemenu;
accelrate_h = handles.accelratemenu;
gyrorate_h = handles.gyroratemenu;
magrate_h = handles.magratemenu;
emgrate_h = handles.emgratemenu;
baudrate_h = handles.baudratemenu;
samprate_h = handles.samprate;
params_h = handles.setparams;
elapsedtime_h = handles.elapsedtime;

sensorFlag = [0 0 0 0 0 0 0];

pathname = 'C:\Users\Nick\Documents\Parkinson Mobility Study\Shimmer MATLAB Files\Shimmer-MATLAB-Files\Trials\';

disp('All')

buffer = 1; % seconds
shimmer1 = ShimmerHandleClass('5');
shimmer2 = ShimmerHandleClass('7');
% shimmer3 = ShimmerHandleClass('9');
% shimmer4 = ShimmerHandleClass('11');
% shimmer5 = ShimmerHandleClass('13');
% shimmer6 = ShimmerHandleClass('15');
%shimmer7 = ShimmerHandleClass('17');
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

% GSR collection
switch get(gsr_h,'Value')
    case 1
        gsrFlag = true; % default
    case 0
        gsrFlag = false;
end
set(gsr_h,'Enable','off')

% Wide Range Acclerometer range (�g)
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

% Gyroscope range (��/s)
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

% Magnetometer range (� Ga)
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

if (shimmer1.connect && shimmer2.connect) % && shimmer3.connect && shimmer4.connect && shimmer5.connect && shimmer6.connect) % && shimmer7.connect)
    
    % Shimmer 1 (BTID 2BD1 - IMU unit)
    shimmer1.setbaudrate(baud_rate);
    shimmer1.setinternalboard('None');
    shimmer1.disableallsensors;
    shimmer1.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
    shimmer1.setaccelrange(accel_range);
    shimmer1.setgyrorange(gyro_range);
    shimmer1.setmagrange(mag_range);
    shimmer1.setaccelrate(accel_rate);
    shimmer1.setgyrorate(gyro_rate);
    shimmer1.setmagrate(mag_rate);
    
    % Shimmer 2 (BTID 3A45 - Shimmer3 unit)
    shimmer2.setbaudrate(baud_rate);
    shimmer2.setinternalboard('None');
    shimmer2.disableallsensors;
    shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
    shimmer2.setaccelrange(accel_range);
    shimmer2.setgyrorange(gyro_range);
    shimmer2.setmagrange(mag_range);
    shimmer2.setaccelrate(accel_rate);
    shimmer2.setgyrorate(gyro_rate);
    shimmer2.setmagrate(mag_rate);
%     
%     % Shimmer 3 (BTID 399C - Shimmer3 unit)
%     shimmer3.setbaudrate(baud_rate);
%     shimmer3.setinternalboard('None');
%     shimmer3.disableallsensors;
%     shimmer3.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
%     shimmer3.setaccelrange(accel_range);
%     shimmer3.setgyrorange(gyro_range);
%     shimmer3.setmagrange(mag_range);
%     shimmer3.setaccelrate(accel_rate);
%     shimmer3.setgyrorate(gyro_rate);
%     shimmer3.setmagrate(mag_rate);
%     
%     % Shimmer 4 (BTID 3A1E - Shimmer3 unit)
%     shimmer4.setbaudrate(baud_rate);
%     shimmer4.setinternalboard('None');
%     shimmer4.disableallsensors;
%     shimmer4.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
%     shimmer4.setaccelrange(accel_range);
%     shimmer4.setgyrorange(gyro_range);
%     shimmer4.setmagrange(mag_range);
%     shimmer4.setaccelrate(accel_rate);
%     shimmer4.setgyrorate(gyro_rate);
%     shimmer4.setmagrate(mag_rate);
%     
%     % Shimmer 5 (BTID 39F8 - Shimmer3 unit)
%     shimmer5.setbaudrate(baud_rate);
%     shimmer5.setinternalboard('None');
%     shimmer5.disableallsensors;
%     shimmer5.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
%     shimmer5.setaccelrange(accel_range);
%     shimmer5.setgyrorange(gyro_range);
%     shimmer5.setmagrange(mag_range);
%     shimmer5.setaccelrate(accel_rate);
%     shimmer5.setgyrorate(gyro_rate);
%     shimmer5.setmagrate(mag_rate);
%     
%     % Shimmer 6 (BTID 2BFD - GSR+ unit)
%     shimmer6.setbaudrate(baud_rate);
%     shimmer6.setinternalboard('None');
%     shimmer6.disableallsensors;
%     shimmer6.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.INTA13,1,macros.BATT,1);
%     shimmer6.setinternalexppower(1);    % Enable internal expansion power
%     shimmer6.setaccelrange(accel_range);
%     shimmer6.setgyrorange(gyro_range);
%     shimmer6.setmagrange(mag_range);
%     shimmer6.setaccelrate(accel_rate);
%     shimmer6.setgyrorate(gyro_rate);
%     shimmer6.setmagrate(mag_rate);
    
    % Shimmer 7 (BTID 38F5 - PROTO3 unit)
    %     shimmer7.setbaudrate(baud_rate);
    %     shimmer7.setinternalboard('None');
    %     shimmer7.disableallsensors;
    %     shimmer7.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
    %     shimmer7.setaccelrange(accel_range);
    %     shimmer7.setgyrorange(gyro_range);
    %     shimmer7.setmagrange(mag_range);
    %     shimmer7.setaccelrate(accel_rate);
    %     shimmer7.setgyrorate(gyro_rate);
    %     shimmer7.setmagrate(mag_rate);
    
    % Enable EMG daughterboard and set sampling rates
    if exgFlag == true
        shimmer2.setenabledsensors(macros.EMG24BIT,1);
        shimmer2.setinternalboard('EMG');
        shimmer2.setexgrate(exg_rate,1);
        shimmer2.setexgrate(exg_rate,2);
%         shimmer3.setenabledsensors(macros.EMG24BIT,1);
%         shimmer3.setinternalboard('EMG');
%         shimmer3.setexgrate(exg_rate,1);
%         shimmer3.setexgrate(exg_rate,2);
%         shimmer4.setenabledsensors(macros.EMG24BIT,1);
%         shimmer4.setinternalboard('EMG');
%         shimmer4.setexgrate(exg_rate,1);
%         shimmer4.setexgrate(exg_rate,2);
%         shimmer5.setenabledsensors(macros.EMG24BIT,1);
%         shimmer5.setinternalboard('EMG');
%         shimmer5.setexgrate(exg_rate,1);
%         shimmer5.setexgrate(exg_rate,2);
    end
    
    % Enable GSR daughterboard and internal expansion power
    if gsrFlag == true
%         shimmer6.setenabledsensors(macros.INTA13,1);
%         shimmer6.setinternalexppower(1);
    end 
    
    disp('Release <Disconnect> button if necessary...')
    waitfor(disconnect_h,'Value',0)
    
    while ~get(disconnect_h,'Value')
        
        disp('Release <Stop> button if necessary...')
        waitfor(stop_h,'Value',0)
        disp('Press <Start> to begin recording trial...')
        waitfor(start_h,'Value',1)
        
            elapsedTime = 0;
            set(elapsedtime_h,'String',num2str(elapsedTime))
            if (shimmer1.start && shimmer2.start) % && shimmer3.start && shimmer4.start && shimmer5.start && shimmer6.start) % && shimmer7.start)
                
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
                    
                    % Read in Shimmer 2 data and header files
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
                          
                    
%                     if ~isempty(calDataShimmer3)
%                         timeIndex = find(ismember(signalName, 'Time Stamp'));
%                         timeDataShimmer3 = calDataShimmer3(:,timeIndex);
%                         packetsReceivedShimmer3 = shimmer3.getpercentageofpacketsreceived(timeDataShimmer3);
%                     end
%                     
%                     % Read and save packet reception rate for Shimmer 4
%                     [calData,signalName,signalFormat,signalUnit]=shimmer4.getdata('c');
%                     calDataShimmer4 = [calDataShimmer4; calData];
%                     
%                     if ~isempty(calDataShimmer4)
%                         timeIndex = find(ismember(signalName, 'Time Stamp'));
%                         timeDataShimmer4 = calDataShimmer4(:,timeIndex);
%                         packetsReceivedShimmer4 = shimmer4.getpercentageofpacketsreceived(timeDataShimmer4);
%                     end
%                     
%                     % Read and save packet reception rate for Shimmer 5
%                     [calData,signalName,signalFormat,signalUnit]=shimmer5.getdata('c');
%                     calDataShimmer5 = [calDataShimmer5; calData];
%                     
%                     
%                     if ~isempty(calDataShimmer5)
%                         timeIndex = find(ismember(signalName, 'Time Stamp'));
%                         timeDataShimmer5 = calDataShimmer5(:,timeIndex);
%                         packetsReceivedShimmer5 = shimmer5.getpercentageofpacketsreceived(timeDataShimmer5);
%                     end
%                     
%                     % Read and save packet reception rate for Shimmer 6
%                     [calData,signalName,signalFormat,signalUnit]=shimmer6.getdata('c');
%                     calDataShimmer6 = [calDataShimmer6; calData];
%                     
%                     if ~isempty(calDataShimmer6)
%                         timeIndex = find(ismember(signalName, 'Time Stamp'));
%                         timeDataShimmer6 = calDataShimmer6(:,timeIndex);
%                         packetsReceivedShimmer6 = shimmer6.getpercentageofpacketsreceived(timeDataShimmer6);
%                     end
                    
                    % Read and save packet reception rate for Shimmer 7
                    %             [calData,signalName,signalFormat,signalUnit]=shimmer7.getdata('c');
                    %             calDataShimmer7 = [calDataShimmer7; calData];
                    %
                    %             if (length(calDataShimmer7)>numPlotSamples)
                    %                 calDataShimmer7 = calDataShimmer7((length(calDataShimmer7)-numPlotSamples):end,:);
                    %             end
                    %
                    %             if ~isempty(calDataShimmer7)
                    %                 timeIndex = find(ismember(signalName, 'Time Stamp'));
                    %                 timeDataShimmer7 = calDataShimmer7(:,timeIndex);
                    %                 packetsReceivedShimmer7 = shimmer7.getpercentageofpacketsreceived(timeDataShimmer7);
                    %             end
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
                shimmer1.stop;
                shimmer2.stop;
%                 shimmer3.stop;
%                 shimmer4.stop;
%                 shimmer5.stop;
%                 shimmer6.stop;
                %shimmer7.stop;
                
                SortShimmerDataAPI(trialname,sensorFlag)
                
            else
                shimmer1.stop;
                shimmer2.stop;
%                 shimmer3.stop;
%                 shimmer4.stop;
%                 shimmer5.stop;
%                 shimmer6.stop;
                 %shimmer7.stop;
            end

    end
    % Enable sensor parameters
    set(emg_h,'Enable','on')
    set(gsr_h,'Enable','on')
    set(accelrange_h,'Enable','on')
    set(gyrorange_h,'Enable','on')
    set(magrange_h,'Enable','on')
    set(accelrate_h,'Enable','on')
    set(gyrorate_h,'Enable','on')
    set(magrate_h,'Enable','on')
    set(emgrate_h,'Enable','on')
    set(baudrate_h,'Enable','on')
    set(samprate_h,'Enable','on')
    
    shimmer1.disconnect;
    shimmer2.disconnect;
%     shimmer3.disconnect;
%     shimmer4.disconnect;
%     shimmer5.disconnect;
%     shimmer6.disconnect;
    %shimmer7.disconnect;
    
    clear all;
    
end

end