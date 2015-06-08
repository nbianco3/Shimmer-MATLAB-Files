function data_HP_REDM_LP = processEMG(data,TV,hpOrbpCutoff,lpCutoff,demeanFlag,normalizeFlag)

if size(hpOrbpCutoff,2)==1
    data_HP = butterfilt(data,'high',hpOrbpCutoff,4,TV);
elseif size(hpOrbpCutoff,2)==2
    data_HP = butterfilt(data,'bandpass',hpOrbpCutoff,4,TV);
end

if exist('demeanFlag','var') && demeanFlag
    data_HP_DM = data_HP - ones(size(data_HP,1),1)*mean(data_HP);
else
    data_HP_DM = data_HP;
end

data_HP_REDM = abs(data_HP_DM);

data_HP_REDM_LP = butterfilt(data_HP_REDM,'low',lpCutoff,4,TV);

if exist('normalizeFlag','var') && normalizeFlag
    data_HP_REDM_LP = data_HP_REDM_LP./(ones(size(data_HP_REDM_LP,1),1)*max(data_HP_REDM_LP));
end