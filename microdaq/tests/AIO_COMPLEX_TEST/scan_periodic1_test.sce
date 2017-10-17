function test()  
    disp("------------ PERIODIC SCAN  TEST -------------");
    channels = [1 2]
    scanFrequency = 1000;
    scanDataSize = 1000;
    duration = 5;
    

    aiData = [];
    AOdata = [];
    sineData = sin(linspace(0, 2*%pi, 1000)) + 1.0;
    
    for i=1:size(channels, '*')
        AOdata = [AOdata (sineData+inc)'];
        inc = inc + 0.1;
    end
    
    // initialize analog input/output scanning sessions
    mdaq_ao_scan_init([2 1], AOdata, [-10 10], %F, scanFrequency, duration);
    mdaq_ai_scan_init(channels, [-10.24 10.24], %F, scanFrequency, duration);
    
    // start AI scanning without waiting for data
    mdaq_ai_scan(0, %T);
    // start signal generation
    mdaq_ao_scan();
    for i=1:duration
        // start and acquire data from analog inputs
        aiData = [aiData; mdaq_ai_scan(scanDataSize, %T)];
    end
    
    figure();  
    plot(aiData)
endfunction

test();
clear test;


    
