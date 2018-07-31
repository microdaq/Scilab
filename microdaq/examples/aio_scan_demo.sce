aiData = [];
channels = 1
rate = 1000;
scanDataSize = 1000;
duration = 5;
expValue = -3;
sineBias = 2.5;
sineBase = sin(linspace(0, 2*%pi, scanDataSize));
expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
sineWave = sineBase.*expWave + sineBias;

// initialize analog input/output scanning sessions
mdaqAOScanInit(channels, sineWave', [-10,10], %T, rate, duration);
mdaqAIScanInit(channels, [-10,10], %F, rate, duration);

// start AI scanning without waiting for data
mdaqAIScanStart();

// start signal generation
mdaqAOScan();
n = (rate  * duration) / scanDataSize;

for i=1:n-1
    expValue = expValue + 0.8;
    expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
    sineWave = sineBase.*expWave + sineBias;
    // queue new data 
    mdaqAOScanData(channels, sineWave', %T);
    // start and acquire data from analog inputs
    aiData = [aiData; mdaqAIScan(scanDataSize, 10)];
end
// acquire rest of samples
aiData = [aiData; mdaqAIScan(scanDataSize, 10)];
plot(aiData)
