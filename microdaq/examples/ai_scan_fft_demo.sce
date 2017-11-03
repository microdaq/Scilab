// Copyright (c) 2017, Embedded Solutions
// All rights reserved.
// This file is released under the 3-clause BSD license. See COPYING-BSD.
// FFT, AI scan function - DEMO

figH = figure("Figure_name","MicroDAQ FFT demo");
notInitialized = 1;
divFac = 10;
axisH = [];

// AI scan parameters  
scanFreq = 100000;
channel = 1;
AIRange = [-5 5];
isDifferential = %F;
numOfSmaples = scanFreq/divFac;
duration = 120;

// Initialize analog input scanning
mdaqAIScanInit(channel, AIRange, isDifferential, scanFreq, duration);

for i=1:(duration*divFac)
    // Acquire data
    [data result] = mdaqAIScan(numOfSmaples, %T);
    
    // Calculate FFT
    data = data - mean(data);
    y = fft(data');
    f = scanFreq*(0:(numOfSmaples/10))/numOfSmaples; 
    n = size(f,'*');

    // Update plot 
    if is_handle_valid(figH) then
        if notInitialized == 1 then
            clf();
            plot(f,abs(y(1:n)));
            title("FFT", "fontsize", 3);
            xlabel("scanFrequency [Hz]","fontsize", 3);
            notInitialized = 0;
            axisH = gca();
        else
            axisH.children.children.data(:,2) = abs(y(1:n))';
        end
    else
        // Stop scanning 
        mdaqAIScanStop();
        break;
    end
end

// Close plot
mprintf("\nFFT demo has been stopped.");
if is_handle_valid(figH) then
    close(figH);
end
