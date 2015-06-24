function SortShimmerDataAPI(trialname,sensorFlag)
clc;

sensors = {'Unit2BD1','Unit3A45','Unit399C','Unit3A1E','Unit39F8','Unit2BFD','Unit38F5'};
numSensors = length(sensors);
pathname = 'C:\Users\Nick\Documents\Parkinson Mobility Study\Shimmer MATLAB Files\Shimmer-MATLAB-Files\Trials\';

for i=1:numSensors
    if sensorFlag(i)
        sensors{i}
        [~,signalNames,formatNames,signalUnits,sensorData] = loadshimd([pathname trialname ' - ' sensors{i} '.txt']);
        
        % Remove spaces from
        for j=1:length(signalNames)
            stringname = signalNames{j};
            stringname(ismember(stringname,' ')) = [];
            signalNames{j} = stringname;
        end
        
        for j = 1:length(signalNames)
            if strcmp(formatNames{j},'RAW')
                trial.(sensors{i}).RAW.(signalNames{j}).data = sensorData(:,j);
                trial.(sensors{i}).RAW.(signalNames{j}).units = signalUnits(:,j);
            elseif strcmp(formatNames{j}(1:3),'CAL')
                if strcmp(signalNames{j},'Time Stamp')
                    time = (sensorData(:,j)-sensorData(1,j))/1000;
                    trial.(sensors{i}).CALIBRATED.(signalNames{j}).data = time;
                    trial.(sensors{i}).CALIBRATED.(signalNames{j}).units = 's';
                else
                    if ~ischar(signalNames{j})
                        keyboard
                    end
                    trial.(sensors{i}).CALIBRATED.(signalNames{j}).data = sensorData(:,j);
                    trial.(sensors{i}).CALIBRATED.(signalNames{j}).units = signalUnits(:,j);
                end
            end
        end
        
    end
end

start_h = handles.startbutton;
stop_h = handles.stopbutton;
disconnect_h = handles.disconnectbutton;
emgrate_h = handles.emgratemenu;
emgresolution_h = handles.emgresolutionmenu;
emggain_h = handles.emggainmenu;
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
emg2_h = handles.emg2;
emg3_h = handles.emg3;
emg4_h = handles.emg4;
emg5_h = handles.emg5;
imu1_h = handles.imu1;
imu2_h = handles.imu2;
imu3_h = handles.imu3;
imu4_h = handles.imu4;
imu5_h = handles.imu5;
imu6_h = handles.imu6;
imu7_h = handles.imu7;
gsr_h = handles.gsrcheckbox;

emgFlag = [0 get(emg2_h,'Value') get(emg3_h,'Value') get(emg4_h,'Value') get(emg5_h,'Value') 0 0];
imuFlag = [get(imu1_h,'Value') get(imu2_h,'Value') get(imu3_h,'Value') get(imu4_h,'Value') get(imu5_h,'Value') get(imu6_h,'Value') get(imu7_h,'Value')];

% Save parameters
contents = cellstr(get(baudrate_h,'String'));
trial.params.baudrate = [contents{get(baudrate_h,'Value')} 'kB/s'];
contents = cellstr(get(samprate_h,'String'));
trial.params.generalsamplingrate = [contents{get(samprate_h,'Value')} 'Hz'];

if any(imuFlag)
    if get(widerange_h,'Value')
        contents = cellstr(get(accelrange_h,'String'));
        trial.params.WRaccelrange = ['±' contents{get(accelrange_h,'Value')} 'g'];
        contents = cellstr(get(accelrate_h,'String'));
        trial.params.WRaccelrate = [contents{get(accelrate_h,'Value')} 'Hz'];
    end
    contents = cellstr(get(gyrorange_h,'String'));
    trial.params.gyrorange = ['±' contents{get(gyrorange_h,'Value')} '°/s'];
    contents = cellstr(get(magrange_h,'String'));
    trial.params.magrange = ['±' contents{get(magrange_h,'Value')} 'Ga'];
    contents = cellstr(get(gyrorate_h,'String'));
    trial.params.gyrorate = [contents{get(gyrorate_h,'Value')} 'Hz'];
    contents = cellstr(get(magrate_h,'String'));
    trial.params.magrate = [contents{get(magrate_h,'Value')} 'Hz']; 
end

if any(emgFlag)
        contents = cellstr(get(emgrate_h,'String'));
        trial.params.emgrate = [contents{get(emgrate_h,'Value')} 'Hz'];
        trial.params.emgresolution = get(emgresolution_h,'String');
        trial.params.emggain = get(emggain_h,'String');
end

if get(pressure_h,'Value')
    trial.params.pressureresolution = get(pressureresolution_h,'String');
end

if get(gsr_h,'Value')
    trial.params.gsrrange = get(gsrrange_h,'String');
end

c = clock;
save([pathname trialname ' - ' date '-' num2str(c(1,4)) '-' num2str(c(1,5)) '.mat'],'trial')

end