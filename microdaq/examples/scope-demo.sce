// Copyright (c) 2017, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.

// This example show how to acquire data from analog inputs 
// with MicroDAQ and Scilab 6.


duration = 600;         // [s] 
sample_freq = 10000;   // [Hz]
buffer_size = 1000; 
first_time = 1;
f = 1:buffer_size;

ai_scan_data = [];
mdaq_ai_scan_init(1, 2, %F, sample_freq, duration)

for i=1:(sample_freq * duration) / buffer_size
    ai_scan_data = mdaq_ai_scan(buffer_size, %T);
    if first_time == 1 then
        clf()
        plot(f,ai_scan_data)
        first_time = 0;
        a = gca();
    else
        a.children.children.data(:,2) = ai_scan_data';
    end
end
