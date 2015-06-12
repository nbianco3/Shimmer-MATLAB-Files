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
                    signalNames{j}
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

c = clock;
save([pathname trialname ' - ' date '-' num2str(c(1,4)) '-' num2str(c(1,5)) '.mat'],'trial')

end