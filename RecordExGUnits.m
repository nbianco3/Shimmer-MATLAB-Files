function RecordExGUnits(trialname)
clc; beep off;

disp('ExG')

captureDuration = 1000;
buffer = 1; % seconds
shimmer2 = ShimmerHandleClass('7');
shimmer3 = ShimmerHandleClass('9');
shimmer4 = ShimmerHandleClass('11');
shimmer5 = ShimmerHandleClass('13');
macros = SetEnabledSensorsMacrosClass;

% Default sensor settings
accel_range = 0; % 0 (±2g), 1 (±4g), 2 (±8g), 3 (±16g)
gyro_range = 1;  % 0 (±250°/s), 1 (±500°/s), 2 (±1000°/s), 3 (±2000°/s)
mag_range = 1;   % 1 (±1.3 Ga), 2 (±1.9 Ga), 3 (±2.5 Ga), 4 (±4.0 Ga), 5 (±4.7 Ga), 6 (±5.6 Ga), 7 (8.1 Ga)
accel_rate = 5;  % 1 (1.0 Hz), 2 (10.0 Hz), 3 (25.0 Hz), 4 (50.0 Hz), 5 (100.0 Hz), 6 (200.0 Hz) and 7 (400.0 Hz)
gyro_rate = 45;  % 255 (31.25 Hz), 155 (51.28 Hz), 45 (173.91 Hz), 30 (258.06 Hz), 14 (533.33 Hz), 6 (1142.86 Hz)
mag_rate = 6;    % 0 (0.75Hz), 1 (1.5Hz), 2 (3Hz), 3 (7.5Hz), 4 (15Hz), 5 (30Hz), 6 (75Hz), 7 (220Hz)
exg_rate = 3;    % 0 (125 Hz), 1 (250 Hz), 2 (500 Hz), 3 (1000 Hz), 4 (2000 Hz), 5 (4000 Hz), 6 (8000 Hz)
baud_rate = 8;   % 7 (57600 kB/s), 8 (230400 kB/s), 9 (460800 kB/s) and 10 (921600 kB/s)
Fs = 100;        % Hz (see command window for actual settings)

if (shimmer2.connect && shimmer3.connect && shimmer4.connect && shimmer5.connect)
    
    % Shimmer 2 (BTID 3A45 - Shimmer3 unit)
    shimmer2.setbaudrate(baud_rate);
    shimmer2.setinternalboard('EMG');
    shimmer2.disableallsensors;
    shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.EMG24BIT,1);
    shimmer2.setaccelrange(accel_range);
    shimmer2.setgyrorange(gyro_range);
    shimmer2.setmagrange(mag_range);
    shimmer2.setaccelrate(accel_rate);
    shimmer2.setgyrorate(gyro_rate);
    shimmer2.setmagrate(mag_rate);
    shimmer2.setexgrate(exg_rate,1);
    shimmer2.setexgrate(exg_rate,2);
    
    % Shimmer 3 (BTID 399C - Shimmer3 unit)
    shimmer3.setbaudrate(baud_rate);
    shimmer3.setinternalboard('EMG');
    shimmer3.disableallsensors;
    shimmer3.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.EMG24BIT,1);
    shimmer3.setaccelrange(accel_range);
    shimmer3.setgyrorange(gyro_range);
    shimmer3.setmagrange(mag_range);
    shimmer3.setaccelrate(accel_rate);
    shimmer3.setgyrorate(gyro_rate);
    shimmer3.setmagrate(mag_rate);
    shimmer3.setexgrate(exg_rate,1);
    shimmer3.setexgrate(exg_rate,2);
        
    % Shimmer 4 (BTID 3A1E - Shimmer3 unit)
    shimmer4.setbaudrate(baud_rate);
    shimmer4.setinternalboard('EMG');
    shimmer4.disableallsensors;
    shimmer4.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.EMG24BIT,1);
    shimmer4.setaccelrange(accel_range);
    shimmer4.setgyrorange(gyro_range);
    shimmer4.setmagrange(mag_range);
    shimmer4.setaccelrate(accel_rate);
    shimmer4.setgyrorate(gyro_rate);
    shimmer4.setmagrate(mag_rate);
    shimmer4.setexgrate(exg_rate,1);
    shimmer4.setexgrate(exg_rate,2);
    
    % Shimmer 5 (BTID 39F8 - Shimmer3 unit)
    shimmer5.setbaudrate(baud_rate);
    shimmer5.setinternalboard('EMG');
    shimmer5.disableallsensors;
    shimmer5.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.EMG24BIT,1);
    shimmer5.setaccelrange(accel_range);
    shimmer5.setgyrorange(gyro_range);
    shimmer5.setmagrange(mag_range);
    shimmer5.setaccelrate(accel_rate);
    shimmer5.setgyrorate(gyro_rate);
    shimmer5.setmagrate(mag_rate);
    shimmer5.setexgrate(exg_rate,1);
    shimmer5.setexgrate(exg_rate,2);
    
    if (shimmer2.start && shimmer3.start && shimmer4.start && shimmer5.start)
        
        calDataShimmer2 = [];
        calDataShimmer3 = [];
        calDataShimmer4 = [];
        calDataShimmer5 = [];
        elapsedTime = 0;
        tic;
        
        while (elapsedTime < captureDuration)
            
            pause(buffer)
               
            % Read and save packet reception rate for Shimmer 2
            [calData,signalName,signalFormat,signalUnit]=shimmer2.getdata('c');
            calDataShimmer2 = [calDataShimmer2; calData];
            
            if ~isempty(calDataShimmer2)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer2 = calDataShimmer2(:,timeIndex);
                packetsReceivedShimmer2 = shimmer2.getpercentageofpacketsreceived(timeDataShimmer2);
            end
            
            % Read and save packet reception rate for Shimmer 3
            [calData,signalName,signalFormat,signalUnit]=shimmer3.getdata('c');
            calDataShimmer3 = [calDataShimmer3; calData];
            
            if ~isempty(calDataShimmer3)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer3 = calDataShimmer3(:,timeIndex);
                packetsReceivedShimmer3 = shimmer3.getpercentageofpacketsreceived(timeDataShimmer3);
            end
            
            % Read and save packet reception rate for Shimmer 4
            [calData,signalName,signalFormat,signalUnit]=shimmer4.getdata('c');
            calDataShimmer4 = [calDataShimmer4; calData];
            
            if ~isempty(calDataShimmer4)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer4 = calDataShimmer4(:,timeIndex);
                packetsReceivedShimmer4 = shimmer4.getpercentageofpacketsreceived(timeDataShimmer4);
            end
            
            % Read and save packet reception rate for Shimmer 5
            [calData,signalName,signalFormat,signalUnit]=shimmer5.getdata('c');
            calDataShimmer5 = [calDataShimmer5; calData];
                        
            if ~isempty(calDataShimmer5)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer5 = calDataShimmer5(:,timeIndex);
                packetsReceivedShimmer5 = shimmer5.getpercentageofpacketsreceived(timeDataShimmer5);
            end
            
            PacketsReceived = [packetsReceivedShimmer2; packetsReceivedShimmer3; packetsReceivedShimmer4; packetsReceivedShimmer5]
            
            elapsedTime = elapsedTime + toc;
            tic;
            
        end
        elapsedTime = elapsedTime + toc;
        tic;
        
        % Stop streaming
        shimmer2.stop;
        shimmer3.stop;
        shimmer4.stop;
        shimmer5.stop;
        
    else
        shimmer2.stop;
        shimmer3.stop;
        shimmer4.stop;
        shimmer5.stop;
    end
    
    shimmer2.disconnect;
    shimmer3.disconnect;
    shimmer4.disconnect;
    shimmer5.disconnect;
    
end
clear all;

end