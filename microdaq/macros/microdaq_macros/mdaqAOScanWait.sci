function  mdaqAOScanWait(arg1, arg2)
    if argn(2) == 1 then
        mdaqWaitUntilDone("ao", arg1)
    elseif argn(2) == 2 then
        mdaqWaitUntilDone(arg1, "ao", arg2)
    else
        mprintf("Description:\n");
        mprintf("\tWaits until AO scan is done\n");
        mprintf("Usage:\n");
        mprintf("\t[data, result] = mdaqAOScanWait(linkID, timeout)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\ttimeout - amount of time in seconds to wait (-1 - wait indefinitely)\n");
    end
endfunction
