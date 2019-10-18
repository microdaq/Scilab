function mdaqAOWrite(arg1, arg2, arg3, arg4)
    link_id = -1;

    if argn(2) == 3 then
        channels = arg1;
        ao_range = arg2;
        data = arg3;
    end

    if argn(2) == 4 then
        link_id = arg1;
        channels = arg2;
        ao_range = arg3;
        data = arg4;

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] | %microdaq.private.mdaq_hwid(3) == 0 then
        dac_info = %microdaq.private.dac_info;
        if argn(2) > 4 | argn(2) < 3 then
            mprintf("Description:\n");
            mprintf("\tWrites analog outputs\n");
            mprintf("Usage:\n");
            mprintf("\tmdaqAOWrite(linkID, channels, range, data)\n")
            mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
            mprintf("\tchannels - analog output channels\n");
            mprintf("\trange - analog output range\n");
            mprintf("\t        [-10,10] - single range argument applied for all used channels\n");
            mprintf("\t        [-10,10;-5,5] - multi-range argument for two channels\n");
            mprintf("\tdata - data to be written\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ configuration - run mdaqHWInfo and try again!');
        return;
    end

    data_size = size(data, '*');
    ch_count = size(channels, '*');

    if size(ao_range, 'c') <> 2 then
        error("Vector range [low,high;low,high;...] expected!")
    end
    
    if data_size <> ch_count then
        error("Wrong data for selected AO channels");
        return;
    end

    if size(ao_range, 'r') == 1 then
        range_tmp = ao_range;
        ao_range = ones(ch_count,2);
        ao_range(:,1) = range_tmp(1);
        ao_range(:,2) = range_tmp(2);
    end
    
    ao_range = matrix(ao_range', 1, ch_count*2);
    
    if argn(2) == 3 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end
    
    result = [];
    result = call("sci_mlink_ao_write",..
                    link_id, 1, "i",..
                    channels, 2, "i",..
                    ch_count, 3, "i",..
                    ao_range, 4, "d",..
                    data, 5, "d",..
                "out",..
                    [1, 1], 6, "i");

    if argn(2) == 3 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
