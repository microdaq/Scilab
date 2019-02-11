function [data] = mdaqDSPRead(arg1, arg2, arg3, arg4, arg5)
    data = [];
    result = -1;

    if argn(2) == 4 then
        signalID = arg1;
        vectorSize = arg2;
        vectorCount = arg3;
        timeout  = arg4;
    end

    if argn(2) == 5 then
        link_id = arg1;
        signalID = arg2;
        vectorSize = arg3;
        vectorCount = arg4;
        timeout  = arg5;

        if link_id < 0 then
            error("Invalid connection ID!")
            return;
        end
    end

    if argn(2) <> 4 & argn(2) <> 5 then
        mprintf("Description:\n");
        mprintf("\tReads DSP task data\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqDSPRead(linkId, signalId, vectorSize, vectorCount, timeout);\n")
        mprintf("\tlinkId - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tsignalId - signal block identification number from XCOS model.\n");
        mprintf("\tvectorSize - SIGNAL block input vector size.\n");
        mprintf("\tvectorCount - number of vectors to read.\n");
        mprintf("\ttimeout - timeout in seconds\n");
        return;
    end

    if timeout < 0 then
        timeout = -1;
    end

    if timeout > 0 then
        timeout = timeout * 1000;
    end

    if argn(2) == 4 then
        link_id = mdaqOpen();
        if link_id < 0  then
            error(mdaq_error2(link_id), 10000 + abs(link_id));
        end
    end

    [data result] = call("sci_mlink_dsp_signal_read",..
                            link_id, 1, "i",..
                            signalID, 2, "i",..
                            vectorSize, 3, "i",..
                            vectorSize*vectorCount, 5, "i",..
                            timeout, 6, "i",..
                        "out",..
                            [vectorSize, vectorCount], 4, "d",..
                            [1, 1], 7, "i");
    if argn(2) == 4 then
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result));
    end

    data = data';
endfunction
