// Copyright (c) 2018, Embedded Solutions
// All rights reserved.
// This file is released under the 3-clause BSD license. See COPYING-BSD.

// This example shows how to use application generated with MicroDAQ Code Gen
// with scilab script

// Script execution duration in seconds
TIME = 20;

// Model execution frequency in Hertz
FREQ = 5000;

// Build DSP binary from Xcos model
mdaqDSPBuild(mdaqToolboxPath() + filesep() + "examples" + filesep() +"fft_demo.zcos");

// Start DSP application
mdaqDSPInit('fft_demo_scig\fft_demo.out', FREQ, -1);
mdaqDSPStart();

first_time = 1;
a = []; s = [];

// Process data from DSP
sample_count = FREQ/10;
fig = figure("Figure_name","MicroDAQ FFT demo");

for i=1:(TIME*10)
    s = mdaqDSPRead(1, 1, sample_count, 1);
   
    N=size(s,'*');  //number of samples
    s = s - mean(s);//cut DC
    y=fft(s');

    f= FREQ*(0:(N/10))/N; //associated frequency vector
    n=size(f,'*');

    if is_handle_valid(fig) then
        if first_time == 1 then
            clf();
            plot(f,abs(y(1:n)));
            title("FFT", "fontsize", 3);
            xlabel("frequency [Hz]","fontsize", 3);
            first_time = 0;
            a = gca();
        else
            a.children.children.data(:,2) = abs(y(1:n))';
        end
    else
        break;
    end
end

// Stop DSP execution
mdaqDSPStop();

// Close plot
mprintf("\nFFT demo has been stopped.");
if is_handle_valid(fig) then
    close(fig);
end
