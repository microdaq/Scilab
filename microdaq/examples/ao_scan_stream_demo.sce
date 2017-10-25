channels = 1
rate = 1000;
scanDataSize = 1000;
duration = 5;
expValue = -3;
sineBias = 2.5;
sineBase = sin(linspace(0, 2*%pi, scanDataSize));
expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
sineWave = sineBase. * expWave + sineBias;

// initialize analogoutput scanning sessions
mdaqAOScanInit(channels, sineWave', [-10,10], %T, rate, duration);

// start signal generation
mdaqAOScan();
n = (rate  * duration) / scanDataSize;

for i=1:n-1
    expValue = expValue + 0.8;
    expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
    sineWave = sineBase. * expWave + sineBias;
    
    // queue new data 
    mdaqAOScanData(channels, sineWave', %T);
end
