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

sensorFlag = [0 0 0 0 0 0 0];

pathname = 'C:\Users\Nick\Documents\Parkinson Mobility Study\Shimmer MATLAB Files\Shimmer-MATLAB-Files\Trials\';

disp('All')

buffer = 1; % seconds
shimmer1 = ShimmerHandleClass('5');
% shimmer2 = ShimmerHandleClass('7');
% shimmer3 = ShimmerHandleClass('9');
% shimmer4 = ShimmerHandleClass('11');
% shimmer5 = ShimmerHandleClass('13');
% shimmer6 = ShimmerHandleClass('15');
%shimmer7 = ShimmerHandleClass('17');
macros = SetEnabledSensorsMacrosClass;
sensorNames = {'Unit2BD1','Unit3A45','Unit399C','Unit3A1E','Unit39F8','Unit2BFD','Unit38F5'};

% Set sensor parameters

% Enable EMG collection
exgFlag = true;

% Enable GSR collection
gsrFlag = true;

% Default sensor settings
accel_range = 0; % 0 (±2g), 1 (±4g), 2 (±8g), 3 (±16g)
gyro_range = 1;  % 0 (±250°/s), 1 (±500°/s), 2 (±1000°/s), 3 (±2000°/s)
mag_range = 1;   % 1 (±1.3 Ga), 2 (±1.9 Ga), 3 (±2.5 Ga), 4 (±4.0 Ga), 5 (±4.7 Ga), 6 (±5.6 Ga), 7 (8.1 Ga)
accel_rate = 5;  % 1 (1.0 Hz), 2 (10.0 Hz), 3 (25.0 Hz), 4 (50.0 Hz), 5 (100.0 Hz), 6 (200.0 Hz) and 7 (400.0 Hz)
gyro_rate = 45;  % 255 (31.25 Hz), 155 (51.28 Hz), 45 (173.91 Hz), 30 (258.06 Hz), 14 (533.33 Hz), 6 (1142.86 Hz)
mag_rate = 6;    % 0 (0.75Hz), 1 (1.5Hz), 2 (3Hz), 3 (7.5Hz), 4 (15Hz), 5 (30Hz), 6 (75Hz), 7 (220Hz)
exg_rate = 3;    % 0 (125 Hz), 1 (250 Hz), 2 (500 Hz), 3 (1000 Hz), 4 (2000 Hz), 5 (4000 Hz), 6 (8000 Hz)
baud_rate = 8;   % 0 (115200 kB/s), 1 (1200 kB/s), 2 (2400 kB/s), 3 (4800 kB/s), 4 (9600 kB/s), 5 (19200 kB/s), 6 (38400 kB/s),7 (57600 kB/s), 8 (230400 kB/s), 9 (460800 kB/s) and 10 (921600 kB/s)
Fs = 100;        % Hz (see command window for actual settings)

if (shimmer1.connect) % && shimmer2.connect && shimmer3.connect && shimmer4.connect && shimmer5.connect && shimmer6.connect) % && shimmer7.connect)
    
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
%     shimmer2.setbaudrate(baud_rate);
%     shimmer2.setinternalboard('None');
%     shimmer2.disableallsensors;
%     shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.BATT,1);
%     shimmer2.setaccelrange(accel_range);
%     shimmer2.setgyrorange(gyro_range);
%     shimmer2.setmagrange(mag_range);
%     shimmer2.setaccelrate(accel_rate);
%     shimmer2.setgyrorate(gyro_rate);
%     shimmer2.setmagrate(mag_rate);
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
        shimmer3.setenabledsensors(macros.EMG24BIT,1);
        shimmer3.setinternalboard('EMG');
        shimmer3.setexgrate(exg_rate,1);
        shimmer3.setexgrate(exg_rate,2);
        shimmer4.setenabledsensors(macros.EMG24BIT,1);
        shimmer4.setinternalboard('EMG');
        shimmer4.setexgrate(exg_rate,1);
        shimmer4.setexgrate(exg_rate,2);
        shimmer5.setenabledsensors(macros.EMG24BIT,1);
        shimmer5.setinternalboard('EMG');
        shimmer5.setexgrate(exg_rate,1);
        shimmer5.setexgrate(exg_rate,2);
    end
    
    % Enable GSR daughterboard and internal expansion power
    if gsrFlag == true
        shimmer6.setenabledsensors(macros.INTA13,1);
        shimmer6.setinternalexppower(1);
    end 
    
    disp('Release <Disconnect> button if necessary...')
    waitfor(disconnect_h,'Value',0)
    
    while ~get(disconnect_h,'Value')
        
        disp('Release <Stop> button if necessary...')
        waitfor(stop_h,'Value',0)
        disp('Press <Start> to begin recording trial...')
        get(start_h,'Value')
        waitfor(start_h,'Value',1)
        get(start_h,'Value')
        
            if (shimmer1.start) % && shimmer2.start && shimmer3.start && shimmer4.start && shimmer5.start && shimmer6.start) % && shimmer7.start)
                
                dataShimmer1 = [];
                dataShimmer2 = [];
                dataShimmer3 = [];
                dataShimmer4 = [];
                dataShimmer5 = [];
                dataShimmer6 = [];
                dataShimmer7 = [];
                
                shimmer1header = [];
                shimmer2header = [];
                shimmer3header = [];
                shimmer4header = [];
                shimmer5header = [];
                shimmer6header = [];
                shimmer7header = [];
                
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
                            sensorNamesString = char(sensorNames{1,1});
                            signalNamesString = char(signalNames(1,1));
                            signalFormatsString = char(signalFormats(1,1));
                            signalUnitsString = char(signalUnits(1,1));
                            for i=2:length(signalNames)
                                sensorNamesString = [sensorNamesString char(9) char(sensorNames(1,1))];
                                signalNamesString = [signalNamesString char(9) char(signalNames(1,i))];
                                signalFormatsString = [signalFormatsString char(9) char(signalFormats(1,i))];
                                signalUnitsString = [signalUnitsString char(9) char(signalUnits(1,i))];
                                firsttime=false;
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
                    
                    % Read and save packet reception rate for Shimmer 2
%                     [calData,signalName,signalFormat,signalUnit]=shimmer2.getdata('c');
%                     calDataShimmer2 = [calDataShimmer2; calData];
%                     
%                     if ~isempty(calDataShimmer2)
%                         timeIndex = find(ismember(signalName, 'Time Stamp'));
%                         timeDataShimmer2 = calDataShimmer2(:,timeIndex);
%                         packetsReceivedShimmer2 = shimmer2.getpercentageofpacketsreceived(timeDataShimmer2);
%                     end
%                     
%                     % Read and save packet reception rate for Shimmer 3
%                     [calData,signalName,signalFormat,signalUnit]=shimmer3.getdata('c');
%                     calDataShimmer3 = [calDataShimmer3; calData];
%                     
%                     
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
                end
                
                % Stop streaming
                shimmer1.stop;
%                 shimmer2.stop;
%                 shimmer3.stop;
%                 shimmer4.stop;
%                 shimmer5.stop;
%                 shimmer6.stop;
                %shimmer7.stop;
                
                SortShimmerDataAPI(trialname,sensorFlag)
                
            else
                shimmer1.stop;
%                 shimmer2.stop;
%                 shimmer3.stop;
%                 shimmer4.stop;
%                 shimmer5.stop;
%                 shimmer6.stop;
                 %shimmer7.stop;
            end

    end
    shimmer1.disconnect;
%     shimmer2.disconnect;
%     shimmer3.disconnect;
%     shimmer4.disconnect;
%     shimmer5.disconnect;
%     shimmer6.disconnect;
    %shimmer7.disconnect;
    
    clear all;
    
end

end