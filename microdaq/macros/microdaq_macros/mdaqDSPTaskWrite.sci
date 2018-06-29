function mdaqDSPTaskWrite(arg1, arg2, arg3)
    // Check version compatibility
    [is_supp vers] = mdaq_is_working('mdaqDSPTaskWrite');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end

    if argn(2) == 2 then
        start_idx = arg1;
        data = arg2;
    end

    if argn(2) == 3 then
        link_id = arg1;
        start_idx = arg2;
        data = arg3;

        if link_id < 0 then
            error("Invalid link ID!")
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tWrites data to DSP task\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqDSPTaskWrite(linkID, index, data)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tindex - memory index to begin write from\n");
        mprintf("\tdata - data to be written\n");
        return;
    end

    len = size(data, "*");
    if  start_idx < 1 | start_idx > 250000-len then
        error("Incorrect start index - use values from 1 to 250000-(data size)!")
    end

    if argn(2) == 2 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end

    [result] = call("sci_mlink_dsp_mem_write",..
                        link_id, 1, 'i',..
                        start_idx, 2, 'i',..
                        len, 3, 'i',..
                        real(data), 4, 'r',..
                    "out",..
                        [1,1], 5, 'i');

    if argn(2) == 2 then
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result));
    end
endfunction
