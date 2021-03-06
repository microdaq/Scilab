// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.


function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("microdaq.dem.gateway.sce");

    subdemolist = [ "FFT (script + XCOS - external mode)", "fft_demo.dem.sce" ;
                  "DC motor control (XCOS - external mode)", "dc_motor_demo.dem.sce" ;
                  "PID control (script)", "pid_demo.dem.sce" ;
                  "Audio effects (script)", "audio_demo.dem.sce" ;
                  "Audio gain (script)", "audio_gain.dem.sce";
                ];

    subdemolist(:,2) = demopath + subdemolist(:,2);
endfunction
subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
