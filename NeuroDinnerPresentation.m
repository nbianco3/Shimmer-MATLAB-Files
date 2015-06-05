function NeuroDinnerPresentation(comPort,captureDuration)

numPlotSamples = 500;
DELAY = 0.2;

shimmer1 = ShimmerHandleClass(comPort);
macs = SetEnabledSensorsMacrosClass;

if (shimmer1.connect)
    
    % Define settings
    shimmer1.setinternalboard('EMG');
    shimmer1.disableallsensors;
    shimmer1.setenabledsensors(macs.LNACCEL,1,macs.GYRO,1,macs.MAG,1,macs.EMG24BIT,1);
    shimmer1.setaccelrange(0);          % +/- 2.0 g
    shimmer1.setgyrorange(1);           % +/- 500 deg/s  
    shimmer1.setmagrange(1);            % +/- 1.0 Ga
    shimmer1.setgyrorate(45);           % 173.91 Hz (8-bit input --> 255 to 0)
    shimmer1.setexgrate(3,1);           % 1000 Hz (4 = 2000 Hz)
    shimmer1.setexgrate(3,2);
    shimmer1.setaccelrate(5);           % 100 Hz
    shimmer1.setmagrate(6);             % 75 Hz
    shimmer1.setbaudrate(10);           % 921600 (max)
    disp('WARNING: Sensor ranges must match calibrated ranges')
    disp('Press <enter> to continue...')
    pause
    
    if (shimmer1.start)
        
        calDataShimmer1 = [];
        h.figure1=figure('Name','Shimmer 1');
        elapsedTime = 0;
        tic;
        
        while (elapsedTime < captureDuration)
            
            pause(DELAY)
            packetRateShimmer1 = shimmer1.getpercentageofpacketsreceived();
        
            % Read and plot data for shimmer1
            [calData,signalName,signalFormat,signalUnit]=shimmer1.getdata('u');
            keyboard
            calDataShimmer1 = [calDataShimmer1; calData];    % Read the calibrated data for shimmer1 and add to previous data
            
            if (length(calDataShimmer1)>numPlotSamples)
                calDataShimmer1 = calDataShimmer1((length(calDataShimmer1)-numPlotSamples):end,:);
            end
            
            if ~isempty(calDataShimmer1)
                timeIndex = find(ismember(signalName, 'Time Stamp'));
                accelIndex(1) = find(ismember(signalName, 'Low Noise Accelerometer X'));
                accelIndex(2) = find(ismember(signalName, 'Low Noise Accelerometer Y'));
                accelIndex(3) = find(ismember(signalName, 'Low Noise Accelerometer Z'));
                gyroIndex(1) = find(ismember(signalName, 'Gyroscope X'));
                gyroIndex(2) = find(ismember(signalName, 'Gyroscope Y'));
                gyroIndex(3) = find(ismember(signalName, 'Gyroscope Z'));
                magIndex(1) = find(ismember(signalName, 'Magnetometer X'));
                magIndex(2) = find(ismember(signalName, 'Magnetometer Y'));
                magIndex(3) = find(ismember(signalName, 'Magnetometer Z'));
                exgIndex(1) = find(ismember(signalName, 'EXG1 CH1'));
                exgIndex(2) = find(ismember(signalName, 'EXG1 CH2'));
                
                timeDataShimmer = calDataShimmer1(:,timeIndex);
                packetsReceivedShimmer1 = shimmer1.getpercentageofpacketsreceived(timeDataShimmer);
                accelDataShimmer1 = [calDataShimmer1(:,accelIndex(1)), calDataShimmer1(:,accelIndex(2)), calDataShimmer1(:,accelIndex(3))];
                gyroDataShimmer1 = [calDataShimmer1(:,gyroIndex(1)), calDataShimmer1(:,gyroIndex(2)), calDataShimmer1(:,gyroIndex(3))];
                magDataShimmer1 = [calDataShimmer1(:,magIndex(1)), calDataShimmer1(:,magIndex(2)), calDataShimmer1(:,magIndex(3))];
                exgDataShimmer1 = [calDataShimmer1(:,exgIndex(1)), calDataShimmer1(:,exgIndex(2))];
                
                set(0,'CurrentFigure',h.figure1);
                
                % Plot accelerometer data
                subplot(4,1,1)
                plot(accelDataShimmer1);                                       
                title(['Shimmer 1 Data - ' sprintf('Packets Received: %3.2f %',packetsReceivedShimmer1)]);                         
                axis([0 NO_SAMPLES_IN_PLOT -20 20]);                           
                legend(char(signalName{accelIndex(1)}),char(signalName{accelIndex(2)}),char(signalName{accelIndex(3)}))     
                
                % Plot gyroscope data
                subplot(4,1,2)
                plot(gyroDataShimmer1);                                                             
                axis([0 NO_SAMPLES_IN_PLOT -500 500]);                           
                legend(char(signalName{gyroIndex(1)}),char(signalName{gyroIndex(2)}),char(signalName{gyroIndex(3)})) 
                
                % Plot magnetometer data
                subplot(4,1,3)
                plot(magDataShimmer1);                                                              
                axis([0 NO_SAMPLES_IN_PLOT -2 2]);                           
                legend(char(signalName{magIndex(1)}),char(signalName{magIndex(2)}),char(signalName{magIndex(3)})) 
                
                % Plot ExG data
                subplot(4,1,4)
                plot(exgDataShimmer1);                                                             
                axis([0 NO_SAMPLES_IN_PLOT -5 5]);                           
                legend(char(signalName{exgIndex(1)}),char(signalName{exgIndex(2)})) 
            end
            elapsedTime = elapsedTime + toc; 
            
        end
        elapsedTime = elapsedTime + toc;                                   % Stop timer
        
        shimmer1.stop;                                                     % Stop data streaming from shimmer1                                                    
        shimmer2.stop;
        
    else
        
        shimmer1.stop;                                                     % Stop data streaming from shimmer1                                                    
        shimmer2.stop;
           
    end
    
    shimmer1.disconnect;                                                   % Disconnect from shimmer1
    shimmer2.disconnect;  
       
end

clear all;  











end