// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.


function subdemolist = demo_gateway()
  demopath = get_absolute_file_path("MicroDAQ.dem.gateway.sce");

  subdemolist = ["LED example", "led_demo.dem.sce" ;
                 "FFT script example", "fft_demo.dem.sce" ;
                 "Motor controller", "motor_controller.dem.sce" ;
                ];

  subdemolist(:,2) = demopath + subdemolist(:,2);

endfunction
subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
