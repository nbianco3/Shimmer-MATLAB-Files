function NeuroDinnerPresentation(comPort,captureDuration)

numPlotSamples = 2000;   % samples
buffer = 0.2;            % seconds
shimmer1 = ShimmerHandleClass(comPort);
macros = SetEnabledSensorsMacrosClass;

if (shimmer1.connect)
    
    % Define settings
    shimmer1.setinternalboard('EMG');
    shimmer1.disableallsensors;
    shimmer1.setenabledsensors(macros.LNACCEL,1,macros.GYRO,1,macros.MAG,1,macros.EMG24BIT,1);
    shimmer1.setaccelrange(0);          % +/- 2.0 g
    shimmer1.setgyrorange(1);           % +/- 500 deg/s  
    shimmer1.setmagrange(1);            % +/- 1.0 Ga
    shimmer1.setgyrorate(155);          % 51.2 Hz (8-bit input --> 255 to 0)
    shimmer1.setexgrate(3,1);           % 1000 Hz (4 = 2000 Hz)
    shimmer1.setexgrate(3,2);
    shimmer1.setaccelrate(5);           % 100 Hz
    shimmer1.setmagrate(6);             % 75 Hz
    shimmer1.setbaudrate(10);           % 921600 kB/s (max)
    disp('WARNING: Sensor ranges must match calibrated ranges')
    disp('Press <enter> to continue...')
    pause
    
    if (shimmer1.start)
        
        calDataShimmer1 = [];
        h.figure1=figure('Name','Shimmer 1','units','normalized','position',[0 0 1 1]);
        elapsedTime = 0;
        tic;
        
        while (elapsedTime < captureDuration)
            
            pause(buffer)
        
            % Read and plot data for shimmer1
            [calData,signalName,signalFormat,signalUnit]=shimmer1.getdata('c');
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
                emgIndex(1) = find(ismember(signalName, 'EMG CH1'));
                emgIndex(2) = find(ismember(signalName, 'EMG CH2'));
                
                timeDataShimmer1 = calDataShimmer1(:,timeIndex)/1000; % seconds
                packetsReceivedShimmer1 = shimmer1.getpercentageofpacketsreceived(timeDataShimmer1*1000);
                accelDataShimmer1 = [calDataShimmer1(:,accelIndex(1)), calDataShimmer1(:,accelIndex(2)), calDataShimmer1(:,accelIndex(3))];
                gyroDataShimmer1 = [calDataShimmer1(:,gyroIndex(1)), calDataShimmer1(:,gyroIndex(2)), calDataShimmer1(:,gyroIndex(3))];
                magDataShimmer1 = [calDataShimmer1(:,magIndex(1)), calDataShimmer1(:,magIndex(2)), calDataShimmer1(:,magIndex(3))];
                emgDataShimmer1 = [calDataShimmer1(:,emgIndex(1)), calDataShimmer1(:,emgIndex(2))];
                emgSampleTime = linspace(0,numPlotSamples/1000,numPlotSamples)';
                emgFiltDataShimmer1 = [processEMG(emgDataShimmer1(:,1),emgSampleTime,[10 400],6), processEMG(emgDataShimmer1(:,1),emgSampleTime,[10 400],6)];
                set(0,'CurrentFigure',h.figure1);
                
                % Plot accelerometer data
                subplot(2,2,1)
                plot(accelDataShimmer1);                                                             
                axis([0 numPlotSamples -20 40]);
                set(gca,'YTick',[-20:5:20])
                ylabel('Acceleration (m/s^2)')
                title([sprintf('Samp Rate: %4.1f',100) ' Hz'])
                legend(char(signalName{accelIndex(1)}),char(signalName{accelIndex(2)}),char(signalName{accelIndex(3)}))     
                
                % Plot gyroscope data
                subplot(2,2,2)
                plot(gyroDataShimmer1);                                                             
                axis([0 numPlotSamples -500 1000]);
                set(gca,'YTick',[-500:250:500])
                ylabel('Angular Velocity (deg/s)')
                title([sprintf('Samp Rate: %4.1f',51.2) ' Hz'])
                legend(char(signalName{gyroIndex(1)}),char(signalName{gyroIndex(2)}),char(signalName{gyroIndex(3)})) 
                
                % Plot magnetometer data
                subplot(2,2,3)
                plot(magDataShimmer1);                                                              
                axis([0 numPlotSamples -2 3.5]);
                set(gca,'YTick',[-2:0.5:2])
                ylabel('Magnetic Flux Density (Ga)')
                title([sprintf('Samp Rate: %4.1f',75) ' Hz'])
                legend(char(signalName{magIndex(1)}),char(signalName{magIndex(2)}),char(signalName{magIndex(3)})) 
                
                % Plot ExG data
                subplot(2,2,4)
                plot((emgDataShimmer1(:,1)-mean(emgDataShimmer1(:,1)))/(0.5*max(emgDataShimmer1(:,1))),'b-')
                hold on
                plot(emgFiltDataShimmer1(:,1)/max(emgFiltDataShimmer1(:,1)),'k-','LineWidth',1.5);                                                             
                axis([0 numPlotSamples -1.5 1.5]);
                set(gca,'YTick',[-1 0 1])
                ylabel('Muscle Excitation')
                title([sprintf('Samp Rate: %4.1f',1000) ' Hz'])
                hold off             
                
                figtitle(['Shimmer 1 Data - ' sprintf('Packets Received: %3.2f',packetsReceivedShimmer1) '%']);  
            end
            elapsedTime = elapsedTime + toc;
            tic;
            
        end
        elapsedTime = elapsedTime + toc;                                  
        shimmer1.stop;  
        
    else
        shimmer1.stop;                                                                                 
    end    
    shimmer1.disconnect;                                                
       
end
clear all;  

end