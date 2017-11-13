// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.
global %microdaq;
if (%microdaq.private.mdaq_hwid(1) == 1000) then
    warning("On your MicroDAQ device demo can be run only in simulation mode.");
    messagebox("On your MicroDAQ device demo can be run only in simulation mode.", "MicroDAQ - warning", "warning");
end

filePath = pathconvert(mdaqToolboxPath() + "examples/led_demo.zcos", %F);
xcos(filePath);
clear filePath;
