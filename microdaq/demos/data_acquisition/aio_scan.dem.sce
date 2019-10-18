// Copyright (c) 2017, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.
global %microdaq;
if (%microdaq.private.mdaq_hwid(2) == 1) then
    messagebox("This demo utilizes DSP core which is not avaliable in E1000 series devices.", "MicroDAQ Demos", "warning");
    return;
end

filePath = pathconvert(mdaqToolboxPath() + "examples/aio_scan_demo.sce", %F);
scinotes(filePath, 'readonly');
clear filePath;

