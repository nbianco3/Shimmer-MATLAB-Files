function SortShimmerData
clc; close all;

pathname = 'C:\Users\Nick\Documents\Parkinson Mobility Study\Data\';
trialnames = {'BicepEMG'};
sensors = {'Unit39F8'};

numTrials = length(trialnames);
filtFlag = false;

for t=1:numTrials
    
    filename = [pathname trialnames{t} '.dat'];
    
    [sensorNames,signalNames,formatNames,signalUnits,sensorData] = loadshimd(filename);
    
    % Enter names of sensors in data
    
    numSensors = length(sensors);
    
    % Remove spaces from
    for i=1:length(signalNames)
        stringname = signalNames{i};
        stringname(ismember(stringname,' ')) = [];
        signalNames{i} = stringname;
    end
    
    for i = 1:length(sensorNames)
        for j = 1:numSensors
            if strcmp(sensorNames{i},sensors{j})
                if strcmp(formatNames{i},'RAW')     
                    trial.(sensors{j}).RAW.(signalNames{i}).data = sensorData(:,i);
                    trial.(sensors{j}).RAW.(signalNames{i}).units = signalUnits(:,i);
                elseif strcmp(formatNames{i}(1:3),'CAL')
                    if strcmp(signalNames{i},'Timestamp')
                        time = (sensorData(:,i)-sensorData(1,i))/1000;
                        trial.(sensors{j}).CALIBRATED.(signalNames{i}).data = time;
                        trial.(sensors{j}).CALIBRATED.(signalNames{i}).units = 's';
                    else
                        trial.(sensors{j}).CALIBRATED.(signalNames{i}).data = sensorData(:,i);
                        trial.(sensors{j}).CALIBRATED.(signalNames{i}).units = signalUnits(:,i);
                    end
                end
            end
        end
    end
    
    % Filter data
    % dataOut = LowpassFilter(timeIn,dataIn,order,cutoff,plotFlag)
    
    order = 4;
    cutoff = 6;
    plotFlag = false;
    
    if filtFlag == true
        
        for i = 1:length(sensorNames)
            for j = 1:numSensors
                if strcmp(sensorNames{i},sensors{j}) && ~strcmp(signalNames{i},'Timestamp')
                    signalNames{i}
                    data = trial.(sensors{j}).CALIBRATED.(signalNames{i}).data;
                    time = trial.(sensors{j}).CALIBRATED.Timestamp.data;
                    filtData = LowpassFilter(time,data,order,cutoff,plotFlag);
                    
                    trial.(sensors{j}).FILTERED.(signalNames{i}).data = filtData;
                    trial.(sensors{j}).FILTERED.(signalNames{i}).units = trial.(sensors{j}).CALIBRATED.(signalNames{i}).units;
                    
                end
            end
        end
    end
    
    save([pathname trialnames{t} '.mat'],'trial')
    
end
end