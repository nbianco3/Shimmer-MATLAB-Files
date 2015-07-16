function AnalyzeIMUTrial

% ANALYZEIMUTRIAL Analyze raw IMU data collected
%                 from SHIMMER test session.
trialname = 'trial1 - 15-Jul-2015-12-12';
trial = load([trialname '.mat']);
devices = {'Unit2BD1','Unit3A45','Unit3A1E','Unit39F8','Unit2BFD'};

for d = 1:length(devices)
    
    a = trial.trial.(devices{d}).CALIBRATED;
    
    % TAKE OUT FIRST VALUE OF ALL DATA
    
    % Time vector
    time = a.TimeStamp.data;
    time = (time-time(1))/1000
    Fs = 1/(time(2)-time(1))
    
    % Accelerometer
    accel_raw(:,1) = a.LowNoiseAccelerometerX.data;
    accel_raw(:,2) = a.LowNoiseAccelerometerY.data;
    accel_raw(:,3) = a.LowNoiseAccelerometerZ.data;
    
    % Gyroscope
    gyro_raw(:,1) = a.GyroscopeX.data;
    gyro_raw(:,2) = a.GyroscopeY.data;
    gyro_raw(:,3) = a.GyroscopeZ.data;
    
    % Magnetometer
    mag_raw(:,1) = a.MagnetometerX.data;
    mag_raw(:,2) = a.MagnetometerY.data;
    mag_raw(:,3) = a.MagnetometerZ.data;

    % Plot the AP and SI acceleration and angular velocity frequency
    % content for the current device
    if strcmp(devices{d},'Unit3A1E')
       accelSI = -accel_raw(:,2);
       accelAP = accel_raw(:,3);
       gyroSI = -gyro_raw(:,2);
       gyroAP = gyro_raw(:,3);
    else
       accelSI = accel_raw(:,2);
       accelAP = accel_raw(:,3);
       gyroSI = gyro_raw(:,2);
       gyroAP = gyro_raw(:,3);
    end
    
    freqdata = [accelSI accelAP gyroSI gyroAP];
    size(freqdata)
    freqtitles = {'SI Accleration','AP Acceleration','SI Gyroscope','AP Gyroscope'};
    figure(2*(d-1)+1)
    for i=1:4
        Fs = 64;
        y = freqdata(:,i)-mean(freqdata(:,i));
        L = length(freqdata(:,i));
       
        NFFT = 2^nextpow2(L); % Next power of 2 from length of y
        Y = fft(y,NFFT)/L;
        f = Fs/2*linspace(0,1,NFFT/2+1);
        
        % Plot single-sided amplitude spectrum.
        subplot(2,2,i)
        plot(f,2*abs(Y(1:NFFT/2+1)))
        xlabel('Frequency (Hz)')
        ylabel(freqtitles{i})      
    end
    figtitle([trialname ' - ' devices{d}])
    
    figure(2*d)
    for i=1:4
        raw = butterfilt(freqdata(:,i),'low',20,4,time);
        filt = butterfilt(raw,'low',4,4,time);
        subplot(2,2,i)
        l=length(filt);
        plot(filt(l-800:l))
        xlabel('Time (s)')
        ylabel(freqtitles{i})
    end
    figtitle([trialname ' - ' devices{d}])
    
    disp('Press <enter> for next device...')
    pause
    clear accel_raw gyro_raw mag_raw 
    close all
end





end