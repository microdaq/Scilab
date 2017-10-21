aiData = [];
channels = 1
scanFrequency = 1000;
scanDataSize = 1000;
duration = 5;
expValue = -3;
sineBias = 2.5;
sineBase = sin(linspace(0, 2*%pi, scanDataSize));
expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
sineWave = sineBase. * expWave + sineBias;

// initialize analog input/output scanning sessions
mdaqAOScanInit(channels, sineWave', 1, %T, scanFrequency, duration);
mdaqAIScanInit(channels, 1, %F, scanFrequency, duration);

// start AI scanning without waiting for data
mdaqAIScan(0, %T);
// start signal generation
mdaqAOScan();
n = (scanFrequency  * duration) / scanDataSize;

for i=1:n-1
    expValue = expValue + 0.8;
    expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
    sineWave = sineBase. * expWave + sineBias;
    // queue new data 
    mdaqAOScanData(channels, sineWave', %T);
    // start and acquire data from analog inputs
    aiData = [aiData; mdaqAIScan(scanDataSize, %T)];
end
// acquire rest of samples
aiData = [aiData; mdaqAIScan(scanDataSize, %T)];
plot(aiData)
clear aiData;
