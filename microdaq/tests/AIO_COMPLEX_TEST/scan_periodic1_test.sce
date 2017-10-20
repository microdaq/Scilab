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
    mdaqAOScanInit([2 1], AOdata, [-10 10], %F, scanFrequency, duration);
    mdaqAIScanInit(channels, [-10.24 10.24], %F, scanFrequency, duration);
    
    // start AI scanning without waiting for data
    mdaqAIScan(0, %T);
    // start signal generation
    mdaqAOScan();
    for i=1:duration
        // start and acquire data from analog inputs
        aiData = [aiData; mdaqAIScan(scanDataSize, %T)];
    end
    
    figure();  
    plot(aiData)
endfunction

test();
clear test;


    