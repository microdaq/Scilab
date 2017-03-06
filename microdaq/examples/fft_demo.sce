// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.


// This example show how to use application generated with MicroDAQ Code Gen
// with scilab script

// Start DSP application
result = mdaq_dsp_start('fft_demo_scig\fft_demo.out', -1); 
if result < 0 then
    abort;
end

// Register signal ID and signal size
result = mdaq_dsp_signal(123, 1); 
if result < 0 then
    disp("ERROR: unable to register signal"); 
    abort;
end

first_time = 1; 
a = [];
// Process data from DSP 
sample_count = 500;
for i=1:5000
    [result, s] = mdaq_dsp_signal_read(sample_count);
    if result < 0 then
        disp("ERROR: unable to get signal data"); 
        abort;
    end

    t = 0:1/sample_count:1;
    N=size(t,'*'); //number of samples
    y=fft(s');
    P2 = abs(y/sample_count); 
    P1 = P2(1:sample_count/2+1);
    P1(2:size(P1, "*")-1) = 2*P1(2:size(P1, "*")-1);
    f = 5000*(0:(sample_count/2))/sample_count;
//    f=sample_count*(0:(N/2))/N; //associated frequency vector
    n=size(f,'*')
    if first_time == 1 then
        clf()
        plot(f,P1)
        first_time = 0;
        a = gca();
    else
        a.children.children.data(:,2) = P1';
    end
end

// Stop DSP execution
mdaq_dsp_stop(); 
