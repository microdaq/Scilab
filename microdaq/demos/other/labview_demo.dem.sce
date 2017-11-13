// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.
global %microdaq;
if (%microdaq.private.mdaq_hwid(1) == 1000) then
    warning("Cannot run this demo on your MicroDAQ configuration.");
    messagebox("Cannot run this demo on your MicroDAQ configuration.", "MicroDAQ - warning", "warning");
    return;
end

filePath = pathconvert(mdaqToolboxPath() + "examples/labview_demo.zcos", %F);
xcos(filePath);
clear filePath;

