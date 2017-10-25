// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.
if (%microdaq.private.mdaq_hwid(2) == 1) then
    warning("Cannot run this demo on your MicroDAQ configuration.");
    messagebox("Cannot run this demo on your MicroDAQ configuration.", "MicroDAQ - warning", "warning");
    return;
end

filePath = pathconvert(mdaqToolboxPath() + "examples\audio_wfir_gui_demo.sce", %F);
scinotes(filePath, 'readonly');
clear filePath;

