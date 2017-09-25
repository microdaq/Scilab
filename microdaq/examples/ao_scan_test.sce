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
mdaq_ao_scan_init(channels, sineWave', 1, %T, scanFrequency, duration);
mdaq_ai_scan_init(channels, 1, %F, scanFrequency, duration);

// start AI scanning without waiting for data
mdaq_ai_scan(0, %T);
// start signal generation
mdaq_ao_scan();
n = (scanFrequency  * duration) / scanDataSize;

for i=1:n-1
    expValue = expValue + 0.8;
    expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
    sineWave = sineBase. * expWave + sineBias;
    // queue new data 
    mdaq_ao_scan_data(channels, sineWave', %T);
    // start and acquire data from analog inputs
    aiData = [aiData; mdaq_ai_scan(scanDataSize, %T)];
end
// acquire rest of samples
aiData = [aiData; mdaq_ai_scan(scanDataSize, %T)];
plot(aiData)
clear aiData;
