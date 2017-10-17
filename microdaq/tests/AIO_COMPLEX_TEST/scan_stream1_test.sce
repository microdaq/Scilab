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
    mdaq_ao_scan_init(channels, AOdata, [-10 10], %T, scanFrequency, duration);
    mdaq_ai_scan_init(channels, [-10.24 10.24], %F, scanFrequency, duration);
    
    // start AI scanning without waiting for data
    mdaq_ai_scan(0, %T);
    
    // start signal generation
    mdaq_ao_scan();
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
        mdaq_ao_scan_data(channels, AOdata, %T);
        
        // start and acquire data from analog inputs
        aiData = [aiData; mdaq_ai_scan(scanDataSize, %T)];
    end
    // acquire rest of samples
    aiData = [aiData; mdaq_ai_scan(scanDataSize, %T)];
    plot(aiData)
endfunction

test();
clear test;


    
