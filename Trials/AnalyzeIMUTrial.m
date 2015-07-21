function AnalyzeIMUTrial

% ANALYZEIMUTRIAL Analyze raw IMU data collected
%                 from SHIMMER test session.
trialname = 'NickLeftLegEMGTrial';
trial = load([trialname '.mat']);
devices = fieldnames(trial.trial);
devices = devices(1:end-1);
IMUorEMG = false; % false==IMU, true==EMG

for d = 1:length(devices)
    
    a = trial.trial.(devices{d}).CALIBRATED 
    
    % Time vector
    time = a.TimeStamp.data(2:end);
    time = (time-time(1))/1000;  
    Fs_actual = 1/mean(diff(time))
    Fs_adjusted = 1/mode(diff(time))
    
    try
        % Accelerometer
        accel_raw(:,1) = a.LowNoiseAccelerometerX.data(2:end);
        accel_raw(:,2) = a.LowNoiseAccelerometerY.data(2:end);
        accel_raw(:,3) = a.LowNoiseAccelerometerZ.data(2:end);
        
        % Gyroscope
        gyro_raw(:,1) = a.GyroscopeX.data(2:end);
        gyro_raw(:,2) = a.GyroscopeY.data(2:end);
        gyro_raw(:,3) = a.GyroscopeZ.data(2:end);
        
        % Magnetometer
        mag_raw(:,1) = a.MagnetometerX.data(2:end);
        mag_raw(:,2) = a.MagnetometerY.data(2:end);
        mag_raw(:,3) = a.MagnetometerZ.data(2:end);
    catch me
        % EMG
        IMUorEMG = true;
        EMG_raw(:,1) = a.EMGCH1.data(2:end);
        EMG_raw(:,2) = a.EMGCH2.data(2:end);
    end
    
    switch IMUorEMG
        
        case 0 % IMU
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
            clear accel_raw gyro_raw mag_raw
            
        case 1 % EMG
            
            EMG_hp = butterfilt(EMG_raw,'bandpass',[20 0.8*(Fs_adjusted/2)],4,time);
            EMG_filt = processEMG(EMG_hp,time,[20 0.8*(Fs_adjusted/2)],6,true,false);
            
            emgtitles = {'EMG CH1','EMG CH2'};
            figure(2*(d-1)+1)
            for i=1:2
                Fs = Fs_adjusted;
                y = EMG_hp(:,i)-mean(EMG_hp(:,i));
                L = length(EMG_hp(:,i));
                
                NFFT = 2^nextpow2(L); % Next power of 2 from length of y
                Y = fft(y,NFFT)/L;
                f = Fs/2*linspace(0,1,NFFT/2+1);
                
                % Plot single-sided amplitude spectrum.
                subplot(2,2,i)
                plot(f,2*abs(Y(1:NFFT/2+1)))
                xlabel('Frequency (Hz)')
                ylabel(emgtitles{i})
            end
            
            figure(2*d)
            subplot(2,1,1)
            plot(EMG_hp(:,1),'b-')
            hold on
            plot(EMG_filt(:,1),'r-','LineWidth',2)
            ylabel('EMG CH1')
            hold off
            
            subplot(2,1,2)
            plot(EMG_hp(:,2),'b-')
            hold on
            plot(EMG_filt(:,2),'r-','LineWidth',2)
            hold off
            ylabel('EMG CH2')
            
            figtitle([trialname ' - ' devices{d}])
            clear EMG_raw
    end
    
    
    disp('Press <enter> for next device...')
    pause
    IMUorEMG = false;
    %close all
end





end