// Copyright (c) 2015-2019, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("microdaq.dem.gateway.sce");

    subdemolist = ["Blinking LED   (XCOS - external/simulation mode)",     "led_demo.dem.sce" ;
             "Blinking LED   (script)",   "led_script_demo.dem.sce" ;
             "Button and LED (XCOS - standalone mode)",      "button_led_demo.dem.sce" ;
             "Button and LED (script)",   "button_led_script_demo.dem.sce" ;
             "UDP send (XCOS - external mode)", "udp_send_demo.dem.sce" ;
             "Param block (XCOS - external mode)", "param_demo.dem.sce" ;
             "LabVIEW demo (XCOS)", "labview_demo.dem.sce" ;
             "MicroDAQ utils guide", "mdaq_utils_demo.dem.sce" ;
            ];

    subdemolist(:,2) = demopath + subdemolist(:,2);
endfunction
subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
