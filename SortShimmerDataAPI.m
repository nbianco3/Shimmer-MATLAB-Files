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

handles = guihandles(gcbo);
accelrange_h = handles.accelrangemenu;
gyrorange_h = handles.gyrorangemenu;
magrange_h = handles.magrangemenu;
accelrate_h = handles.accelratemenu;
gyrorate_h = handles.gyroratemenu;
magrate_h = handles.magratemenu;
emgrate_h = handles.emgratemenu;
baudrate_h = handles.baudratemenu;
samprate_h = handles.samprate;
sampratebool_h = handles.samprate;

% Save parameters
if ~get(sampratebool_h,'Value')
    contents = cellstr(get(accelrange_h,'String'));
    trial.params.accelrange = ['±' contents{get(accelrange_h,'Value')} 'g'];
    contents = cellstr(get(gyrorange_h,'String'));
    trial.params.gyrorange = ['±' contents{get(gyrorange_h,'Value')} '°/s'];
    contents = cellstr(get(magrange_h,'String'));
    trial.params.magrange = ['±' contents{get(magrange_h,'Value')} 'Ga'];
    contents = cellstr(get(accelrate_h,'String'));
    trial.params.accelrate = [contents{get(accelrate_h,'Value')} 'Hz'];
    contents = cellstr(get(gyrorate_h,'String'));
    trial.params.gyrorate = [contents{get(gyrorate_h,'Value')} 'Hz'];
    contents = cellstr(get(magrate_h,'String'));
    trial.params.magrate = [contents{get(magrate_h,'Value')} 'Hz'];
    contents = cellstr(get(emgrate_h,'String'));
    trial.params.emgrate = [contents{get(emgrate_h,'Value')} 'Hz'];
    contents = cellstr(get(baudrate_h,'String'));
    trial.params.baudrate = [contents{get(baudrate_h,'Value')} 'kB/s'];
end
contents = cellstr(get(samprate_h,'String'));
trial.params.generalsamplingrate = [contents{get(samprate_h,'Value')} 'Hz'];

c = clock;
save([pathname trialname ' - ' date '-' num2str(c(1,4)) '-' num2str(c(1,5)) '.mat'],'trial')

end