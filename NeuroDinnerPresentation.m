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
        
        dataShimmer1 = [];
        h.figure1=figure('Name','Shimmer 1');
        elapsedTime = 0;
        tic;
        
        while (elapsedTime < captureDuration)
        
            
            
            
            
        end
        
        
    end
    
    
    
    
end











end