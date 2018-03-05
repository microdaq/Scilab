function [data] = mdaqDSPSignalRead(arg1, arg2, arg3, arg4)
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaqDSPSignalRead');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    
    data = [];
    result = -1;
    
    if argn(2) <> 4 then
        mprintf("Description:\n");
        mprintf("\tReads DSP signal\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqDSPSignalRead(signalID, vectorSize, vectorCount, timeout);\n")
        mprintf("\tsignalID - signal block identification number from XCOS model.\n");
        mprintf("\tvectorSize - SIGNAL block data size.\n");
        mprintf("\tvectorCount - vectors to read.\n");
        mprintf("\ttimeout - maximum amount of time to wait for data in miliseconds\n");        
        return;
    end

    signalID = arg1;
    vectorSize = arg2;
    vectorCount = arg3;
    timeout  = arg4;

    [data result] = call("sci_mlink_dsp_signal_read",..
            signalID, 1, "i",..
            vectorSize, 2, "i",..
            vectorSize*vectorCount, 4, "i",..
            timeout, 5, "i",..
        "out",..
            [vectorSize, vectorCount], 3, "d",..
            [1, 1], 6, "i");
            
    data = data';
            
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
