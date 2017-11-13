function test()
    disp("------------ STREAM SCAN  TEST -------------");
    aiData = [];
    channels = [1 2 3]
    scanFrequency = 1000;
    scanDataSize = 1000;
    duration = 5;
    expValue = -3;
    sineBias = 2.5;
    sineBase = sin(linspace(0, 2*%pi, scanDataSize));
    expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
    sineWave = sineBase. * expWave + sineBias;
    
    AOdata = [];
    AOdata2 = [];
    
    inc = 0.0;
    for i=1:size(channels, '*')
        AOdata = [AOdata (sineWave+inc)'];
        inc = inc + 0.1;
    end
    // initialize analog input/output scanning sessions
    mdaqAOScanInit(channels, AOdata, [-10 10], %T, scanFrequency, duration);
    mdaqAIScanInit(channels, [-10 10], %F, scanFrequency, duration);
    
    // start AI scanning without waiting for data
    mdaqAIScan(0, %T);
    
    // start signal generation
    mdaqAOScan();
    n = (scanFrequency  * duration) / scanDataSize;
    for i=1:n-1
        expValue = expValue + 0.8;
        expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
        sineWave = sineBase. * expWave + sineBias;
        
        AOdata = [];
        inc = 0.0;
        for i=1:size(channels, '*')
            AOdata = [AOdata (sineWave+inc)'];
            inc = inc + 0.1;
        end
        
        // queue new data 
        mdaqAOScanData(channels, AOdata, %T);
        
        // start and acquire data from analog inputs
        aiData = [aiData; mdaqAIScan(scanDataSize, %T)];
    end
    // acquire rest of samples
    aiData = [aiData; mdaqAIScan(scanDataSize, %T)];
    plot(aiData)
endfunction

test();
clear test;


    
