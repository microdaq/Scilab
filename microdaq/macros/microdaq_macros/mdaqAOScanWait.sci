function  mdaqAOScanWait(arg1, arg2)
    if argn(2) == 1 then
        mdaqWaitUntilDone("ao", arg1)
    elseif argn(2) == 2 then
        mdaqWaitUntilDone(arg1, "ao", arg2)
    else
        mprintf("Description:\n");
        mprintf("\tWaits until analog signal generation is done\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqAOScanWait(linkID, timeout)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\ttimeout - amount of time in seconds(-1 - infinity)\n");
    end
endfunction
