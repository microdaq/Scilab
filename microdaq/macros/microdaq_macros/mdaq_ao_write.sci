function mdaq_ao_write(arg1, arg2, arg3, arg4)
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
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        dac = %microdaq.private.mdaq_hwid(3);
        if  dac == 0 then
            disp("ERROR: Unable to detect DAC configuration!");
            return;
        end
        dac_info = %microdaq.private.dac_info;
        if argn(2) > 4 | argn(2) < 3 then
            mprintf("Description:\n");
            mprintf("\tWrites data to MicroDAQ analog outputs\n");
            mprintf("Usage:\n");
            mprintf("\tmdaq_ao_write(link_id, channels, range, data);\n")
            mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
            mprintf("\tchannels - analog output channels \n");
            mprintf("\trange - analog output range:\n");
            for i = 1:size(dac_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + dac_info.c_params.c_range_desc(i));
            end
            mprintf("\tdata - data to be written\n");
            return;
        end
    else
        error('ERROR: Unable to detect MicroDAQ configuration - run mdaq_hwinfo and try again!');
        return;
    end

    data_size = size(data, '*');
    ch_count = size(channels, '*');
    dac_ch_count = strtod(dac_info.channel);

    if ch_count > dac_ch_count then
        disp("ERROR: Too many channels selected!")
        return;
    end

    if max(channels) > dac_ch_count | min(channels) < 1 then
        disp("ERROR: Wrong channel number selected!")
        return;
    end

    if data_size <> ch_count then
        disp("ERROR: Wrong data for selected AO channels!");
        return;
    end

    if ao_range > size(dac_info.c_params.c_range_desc, "r") | ao_range < 1 then
        mprintf("ERROR: Wrong AO range selected.\nSupported ranges:\n");
        for i = 1:size(dac_info.c_params.c_range_desc, "r")
            mprintf("\t    %s\n", string(i) + ": " + dac_info.c_params.c_range_desc(i));
        end
        return;
    end

    if argn(2) == 3 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end

    range_size = size(ao_range, 'c');
    if range_size == 1 then
        ao_range = ones(ch_count, 1) * ao_range;
    else
        for i = 1:ch_count
            ao_range(i) = dac_info.c_params.c_range(ao_range(i));
        end
    end

    result = call("sci_mlink_ao_write",..
                    link_id, 1, "i",..
                    dac, 2, "i",..
                    channels, 3, "i",..
                    ch_count, 4, "i",..
                    ao_range, 5, "i",..
                    data, 6, "d",..
                "out",..
                    [1, 1], 7, "i");

    if result < 0 then
        mdaq_error(result)
    end

    if argn(2) == 3 then
        mdaq_close(link_id);
    end

    clear data_size;
    clear ch_count;
    clear dac_ch_count;
endfunction
