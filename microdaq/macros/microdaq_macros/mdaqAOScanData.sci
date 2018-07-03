function mdaqAOScanData(arg1, arg2, arg3, arg4)
    global %microdaq;
    link_id = -1;

    if argn(2) == 3 then
        channel = arg1;
        data = arg2;
        blocking = arg3;
    end

    if argn(2) == 4 then
        link_id = arg1;
        channel = arg2;
        data = arg3;
        blocking = arg4;

        if link_id < 0 then
            error("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 4 | argn(2) < 3 then
        mprintf("Description:\n");
        mprintf("\tQueues data to be output\n");
        mprintf("Usage:\n");
        mprintf("\tresult = mdaqAOScanData(linkID, channels, data, opt)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tchannels - analog output channels to write\n");
        mprintf("\tdata - data to be output\n");
        mprintf("\topt - reset buffer index to 0 (%s/%s) - periodic mode\n\t      blocking/non-blocking   (%s/%s) - stream mode", "%T", "%F", "%T", "%F");
        return;
    end

    if blocking == %T then
        blocking = 1;
    elseif blocking == %F then
        blocking = 0;
    elseif blocking > 0 then
        blocking = 1;
    else
        blocking = 0;
    end

    ch_count = size(channel, "c");
    data_size = size(data, "*");

    if argn(2) == 3 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end

    result = call("sci_mlink_ao_scan_data",..
                    link_id, 1, "i",..
                    channel, 2, "i",..
                    ch_count, 3, "i",..
                    data, 4, "d",..
                    data_size, 5, "i",..
                    blocking, 6, "i",..
                "out",..
                    [1, 1], 7, "i");

    if argn(2) == 3 then
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result));
    end
endfunction
