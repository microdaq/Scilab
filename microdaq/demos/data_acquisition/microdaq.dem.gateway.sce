// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.


function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("microdaq.dem.gateway.sce");
    sci_ver = getversion('scilab');
    subdemolist = [];
    
    if sci_ver(1) == 5 then 
        subdemolist = ["Analog input scanning (script)", "ai_scan.dem.sce" ;
         "Analog output scanning - periodic (script)", "ao_scan_periodic.dem.sce" ;
         "Analog output scanning - stream (script)", "ao_scan_stream.dem.sce" ;
         "Analog loop scanning (script)", "aio_scan.dem.sce";
         "Analog loop demo (XCOS - external mode)", "ext_analog_demo.dem.sce" ;
         "Write to file (XCOS - external mode)", "to_seq_file.dem.sce" ;
         //"Analog loop demo (XCOS - standalone mode)", "standalone_analog_demo.dem.sce" ;
        ];  
    else
        subdemolist = ["Analog input scanning (script)", "ai_scan.dem.sce" ;
         "Analog output scanning - periodic (script)", "ao_scan_periodic.dem.sce" ;
         "Analog output scanning - stream (script)", "ao_scan_stream.dem.sce" ;
         "Analog loop scanning (script)", "aio_scan.dem.sce";
        ];  
    end    
    
    subdemolist(:,2) = demopath + subdemolist(:,2);
endfunction
subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
