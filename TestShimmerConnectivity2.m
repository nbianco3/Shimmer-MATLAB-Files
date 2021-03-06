function TestShimmerConnectivity2

captureDuration = 1000;
numPlotSamples = 500;   % samples
buffer = 1;             % seconds
Fs = 512;               % Hz
shimmer1 = ShimmerHandleClass('5');
shimmer2 = ShimmerHandleClass('7');
shimmer3 = ShimmerHandleClass('9');
shimmer4 = ShimmerHandleClass('11');
shimmer5 = ShimmerHandleClass('13');
shimmer6 = ShimmerHandleClass('15');
%shimmer7 = ShimmerHandleClass('17');
macros = SetEnabledSensorsMacrosClass;

if (shimmer1.connect && shimmer2.connect && shimmer3.connect && shimmer4.connect && shimmer5.connect && shimmer6.connect) % && shimmer7.connect
    
    % Shimmer 1 (BTID 2BD1 - IMU unit)
    shimmer1.setinternalboard('None');
    shimmer1.disableallsensors;
    shimmer1.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1);
    shimmer1.setaccelrange(0);          % +/- 2.0 g
    shimmer1.setgyrorange(1);           % +/- 500 deg/s  
    shimmer1.setmagrange(1);            % +/- 1.0 Ga
    shimmer1.setsamplingrate(Fs);
    shimmer1.setbaudrate(10);           % 921600 kB/s (max)
    
    % Shimmer 2 (BTID 3A45 - Shimmer3 unit)
    shimmer2.setinternalboard('EMG');
    shimmer2.disableallsensors;
    shimmer2.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.EMG24BIT,1);
    shimmer2.setaccelrange(0);          % +/- 2.0 g
    shimmer2.setgyrorange(1);           % +/- 500 deg/s  
    shimmer2.setmagrange(1);            % +/- 1.0 Ga
    shimmer2.setsamplingrate(Fs);
    shimmer2.setbaudrate(10);           % 921600 kB/s (max)
    
    % Shimmer 3 (BTID 399C - Shimmer3 unit)
    shimmer3.setinternalboard('EMG');
    shimmer3.disableallsensors;
    shimmer3.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.EMG24BIT,1);
    shimmer3.setaccelrange(0);          % +/- 2.0 g
    shimmer3.setgyrorange(1);           % +/- 500 deg/s  
    shimmer3.setmagrange(1);            % +/- 1.0 Ga
    shimmer3.setsamplingrate(Fs);
    shimmer3.setbaudrate(10);           % 921600 kB/s (max)
    
    % Shimmer 4 (BTID 3A1E - Shimmer3 unit)
    shimmer4.setinternalboard('EMG');
    shimmer4.disableallsensors;
    shimmer4.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.EMG24BIT,1);
    shimmer4.setaccelrange(0);          % +/- 2.0 g
    shimmer4.setgyrorange(1);           % +/- 500 deg/s  
    shimmer4.setmagrange(1);            % +/- 1.0 Ga
    shimmer4.setsamplingrate(Fs);
    shimmer4.setbaudrate(10);           % 921600 kB/s (max)
    
    % Shimmer 5 (BTID 39F8 - Shimmer3 unit)
    shimmer5.setinternalboard('EMG');
    shimmer5.disableallsensors;
    shimmer5.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.EMG24BIT,1);
    shimmer5.setaccelrange(0);          % +/- 2.0 g
    shimmer5.setgyrorange(1);           % +/- 500 deg/s  
    shimmer5.setmagrange(1);            % +/- 1.0 Ga
    shimmer5.setsamplingrate(Fs);
    shimmer5.setbaudrate(10);           % 921600 kB/s (max)
    
    % Shimmer 6 (BTID 2BFD - GSR+ unit)
    shimmer6.setinternalboard('GSR');
    shimmer6.disableallsensors;
    shimmer6.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.INTA13,1);
    shimmer6.setinternalexppower(1);    % Enable internal expansion power
    shimmer6.setaccelrange(0);          % +/- 2.0 g
    shimmer6.setgyrorange(1);           % +/- 500 deg/s  
    shimmer6.setmagrange(1);            % +/- 1.0 Ga
    shimmer6.setsamplingrate(Fs);
    shimmer6.setbaudrate(10);           % 921600 kB/s (max)
    
    % Shimmer 7 (BTID 38F5 - PROTO3 unit)
%     shimmer7.setinternalboard('None');
%     shimmer7.disableallsensors;
%     shimmer7.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1);
%     shimmer7.setaccelrange(0);          % +/- 2.0 g
%     shimmer7.setgyrorange(1);           % +/- 500 deg/s  
%     shimmer7.setmagrange(1);            % +/- 1.0 Ga
%     shimmer7.setgyrorate(45);           % 173.91 Hz (8-bit input --> 255 to 0)
%     shimmer7.setaccelrate(5);           % 100 Hz
%     shimmer7.setmagrate(6);             % 75 Hz
%     shimmer7.setbaudrate(10);           % 921600 kB/s (max)
    
    if (shimmer1.start && shimmer2.start && shimmer3.start && shimmer4.start && shimmer5.start && shimmer6.start) % && shimmer7.start)
     
        calDataShimmer1 = [];
        calDataShimmer2 = [];
        calDataShimmer3 = [];
        calDataShimmer4 = [];
        calDataShimmer5 = [];
        calDataShimmer6 = [];
        %calDataShimmer7 = [];
        h.figure1 = figure('Name','Shimmer Connectivity');
        elapsedTime = 0;
        tic;
        
        while (elapsedTime < captureDuration)
            
            pause(buffer)
            
            % Read and save packet reception rate for Shimmer 1
            [calData,signalName,signalFormat,signalUnit]=shimmer1.getdata('c');
            calDataShimmer1 = [calDataShimmer1; calData];
            
            if (length(calDataShimmer1)>numPlotSamples)
                calDataShimmer1 = calDataShimmer1((length(calDataShimmer1)-numPlotSamples):end,:);
            end
            
            if ~isempty(calDataShimmer1)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer1 = calDataShimmer1(:,timeIndex);
                packetsReceivedShimmer1 = shimmer1.getpercentageofpacketsreceived(timeDataShimmer1);
            end
            
            % Read and save packet reception rate for Shimmer 2
            [calData,signalName,signalFormat,signalUnit]=shimmer2.getdata('c');
            calDataShimmer2 = [calDataShimmer2; calData];
            
            if (length(calDataShimmer2)>numPlotSamples)
                calDataShimmer2 = calDataShimmer2((length(calDataShimmer2)-numPlotSamples):end,:);
            end
            
            if ~isempty(calDataShimmer2)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer2 = calDataShimmer2(:,timeIndex);
                packetsReceivedShimmer2 = shimmer2.getpercentageofpacketsreceived(timeDataShimmer2);
            end
            
            % Read and save packet reception rate for Shimmer 3
            [calData,signalName,signalFormat,signalUnit]=shimmer3.getdata('c');
            calDataShimmer3 = [calDataShimmer3; calData];
            
            if (length(calDataShimmer3)>numPlotSamples)
                calDataShimmer3 = calDataShimmer3((length(calDataShimmer3)-numPlotSamples):end,:);
            end
            
            if ~isempty(calDataShimmer3)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer3 = calDataShimmer3(:,timeIndex);
                packetsReceivedShimmer3 = shimmer3.getpercentageofpacketsreceived(timeDataShimmer3);
            end
            
            % Read and save packet reception rate for Shimmer 4
            [calData,signalName,signalFormat,signalUnit]=shimmer4.getdata('c');
            calDataShimmer4 = [calDataShimmer4; calData];
            
            if (length(calDataShimmer4)>numPlotSamples)
                calDataShimmer4 = calDataShimmer4((length(calDataShimmer4)-numPlotSamples):end,:);
            end
            
            if ~isempty(calDataShimmer4)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer4 = calDataShimmer4(:,timeIndex);
                packetsReceivedShimmer4 = shimmer4.getpercentageofpacketsreceived(timeDataShimmer4);
            end
            
            % Read and save packet reception rate for Shimmer 5
            [calData,signalName,signalFormat,signalUnit]=shimmer5.getdata('c');
            calDataShimmer5 = [calDataShimmer5; calData];
            
            if (length(calDataShimmer5)>numPlotSamples)
                calDataShimmer5 = calDataShimmer5((length(calDataShimmer5)-numPlotSamples):end,:);
            end
            
            if ~isempty(calDataShimmer5) 
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer5 = calDataShimmer5(:,timeIndex);
                packetsReceivedShimmer5 = shimmer5.getpercentageofpacketsreceived(timeDataShimmer5);
            end
            
            % Read and save packet reception rate for Shimmer 6
            [calData,signalName,signalFormat,signalUnit]=shimmer6.getdata('c');
            calDataShimmer6 = [calDataShimmer6; calData];
            
            if (length(calDataShimmer6)>numPlotSamples)
                calDataShimmer6 = calDataShimmer6((length(calDataShimmer6)-numPlotSamples):end,:);
            end
            
            if ~isempty(calDataShimmer6)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                timeDataShimmer6 = calDataShimmer6(:,timeIndex);
                packetsReceivedShimmer6 = shimmer6.getpercentageofpacketsreceived(timeDataShimmer6);
            end
            
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
            
            %ShimmerNames = {'Shimmer 1'; 'Shimmer 2'; 'Shimmer 3'; 'Shimmer 4'; 'Shimmer 5'; 'Shimmer 6'}; % 'Shimmer 7'};
            PacketsReceived = [packetsReceivedShimmer1; packetsReceivedShimmer2; packetsReceivedShimmer3; packetsReceivedShimmer4; packetsReceivedShimmer5; packetsReceivedShimmer6] % packetsReceivedShimmer7];
            
            elapsedTime = elapsedTime + toc;
            tic;
            
        end
        elapsedTime = elapsedTime + toc;
        tic;
      
        % Stop streaming
        shimmer1.stop; 
        shimmer2.stop; 
        shimmer3.stop; 
        shimmer4.stop; 
        shimmer5.stop; 
        shimmer6.stop; 
        %shimmer7.stop; 
     
    else
        shimmer1.stop; 
        shimmer2.stop; 
        shimmer3.stop; 
        shimmer4.stop; 
        shimmer5.stop; 
        shimmer6.stop; 
        %shimmer7.stop;
    end
    
    shimmer1.disconnect;
    shimmer2.disconnect;
    shimmer3.disconnect;
    shimmer4.disconnect;
    shimmer5.disconnect;
    shimmer6.disconnect;
    %shimmer7.disconnect;
    
end
clear all;


end
