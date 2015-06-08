function data_lowpass = butterfilt(dataOrig,highOrLowOrBandPass,cutoff,degree,timeVector, Plot)
% data_lowpass = butterfilt(dataOrig,highOrLow,cutoff,degree,timeVector, Plot)
%% Butter worth filter
if nargin<3,
    degree = 4;end
if nargin<2
    % desired cutoff divided by sampling rate, multiplied by 2
    cutoff = 8/100*2;
end
SampRate = 1/mean(diff(timeVector));
% Create Filter
if strcmp(highOrLowOrBandPass,'high')
    [z,p,k] = butter(degree,cutoff/SampRate*2,'high');
elseif strcmp(highOrLowOrBandPass,'low')
    [z,p,k] = butter(degree,cutoff/SampRate*2,'low');
elseif strcmp(highOrLowOrBandPass,'bandpass')
    [z,p,k] = butter(degree,cutoff/SampRate*2);
end
[sos,g] = zp2sos(z,p,k);      % Convert to SOS(second-order-sections) form
Hd = dfilt.df2tsos(sos,g);
% % % Pad data with beginning and ending points to avoid startup errors
% % padN = round(size(dataOrig,1)/3) + round(1/cutoff*250);
% % data = [ones(padN,1)*dataOrig(1,:); dataOrig; ones(padN,1)*dataOrig(end,:)];
%% Pad data with reverse signal, flipped about endpoints
% this method ensure continuous derivatives at enpoints!
StartPad = dataOrig(end:-1:1,:);
StartPad = -(StartPad - ones(size(dataOrig,1),1)*StartPad(end,:))+ones(size(dataOrig,1),1)*StartPad(end,:);
EndPad = dataOrig(end:-1:1,:);
EndPad = -(EndPad - ones(size(dataOrig,1),1)*EndPad(1,:))+ones(size(dataOrig,1),1)*EndPad(1,:);
data = [StartPad(1:end-1,:); dataOrig; EndPad(2:end,:)];
padN = size(dataOrig,1)-1;
% Filter
data_lowpass = zeros(size(data,1),size(data,2));
for j=1:size(data,2)
    data_lowpass(:,j) = filter(Hd,data(:,j));
end
% Filter again but backwards to remove time delay/lag
for j=1:size(data,2)
    data_lowpass(end:-1:1,j) = filter(Hd,data_lowpass(end:-1:1,j));
end
% plot if desired
if exist('Plot','var') && Plot
    figure,
    maxx = size(data,2);
    for i=1:maxx
        subplot(ceil(sqrt(maxx)),ceil(sqrt(maxx)),i)
        plot(data(:,i))
        hold on,
        plot(data_lowpass(:,i),'b--')
        yl=ylim;
        line([padN+.5 padN+.5],yl)
        line([size(data,1)-padN+.5 size(data,1)-padN+.5],yl)
    end
end
% remove pads
data_lowpass = data_lowpass(padN+1:end-padN,:);