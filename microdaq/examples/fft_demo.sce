// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.


// This example show how to use application generated with MicroDAQ Code Gen
// with scilab script

// Start DSP application
result = dsp_start('fft_demo_scig\fft_demo.out'); 
if result < 0 then
    abort;
end

// Register signal ID and signal size
result = dsp_signal(123, 1); 
if result < 0 then
    disp("ERROR: unable to register signal"); 
    abort;
end

first_time = 1; 
a = [];
// Process data from DSP 
sample_count = 500;
for i=1:500
    [result, s] = dsp_signal_get(sample_count);
    if result < 0 then
        disp("ERROR: unable to get signal data"); 
        abort;
    end

    t = 0:1/sample_count:1;
    N=size(t,'*'); //number of samples
    y=fft(s');

    f=sample_count*(0:(N/2))/N; //associated frequency vector
    n=size(f,'*')
    if first_time == 1 then
        clf()
        plot(f,abs(y(1:n)))
        first_time = 0;
        a = gca();
    else
        a.children.children.data(:,2) = abs(y(1:n))';
    end
end

// Stop DSP execution
dsp_stop(); 
