// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.
global %microdaq;
if (%microdaq.private.mdaq_hwid(1) == 1000) then
    messagebox("This demo utilizes DSP core which is not avaliable in E1000 series devices.", "MicroDAQ Demos", "warning");
    return;
end

filePath = pathconvert(mdaqToolboxPath() + "examples/dc_motor_demo.zcos", %F);
xcos(filePath);
clear filePath;
