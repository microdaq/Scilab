function  mdaqDSPWait(arg1, arg2)
    if argn(2) == 1 then
        mdaqWaitUntilDone("dsp", arg1)
    elseif argn(2) == 2 then
        mdaqWaitUntilDone(arg1, "dsp", arg2)
    else
        mprintf("Description:\n");
        mprintf("\tWaits until DSP task is done\n");
        mprintf("Usage:\n");
        mprintf("\t[data, result] = mdaqDSPWait(linkID, timeout)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\ttimeout - amount of time in seconds to wait (-1 - wait indefinitely)\n");
    end
endfunction
