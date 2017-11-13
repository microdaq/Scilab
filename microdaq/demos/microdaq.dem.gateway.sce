// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.


function subdemolist = demo_gateway()
  demopath = get_absolute_file_path("microdaq.dem.gateway.sce");

  subdemolist = ["Data acquisition",   pathconvert("data_acquisition/microdaq.dem.gateway.sce", %F);
                 "Real-time processing",  pathconvert("real_time/microdaq.dem.gateway.sce", %F) ;
                 "Other",              pathconvert("other/microdaq.dem.gateway.sce", %F) ;
                ];

  subdemolist(:,2) = demopath + subdemolist(:,2);

endfunction
subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
