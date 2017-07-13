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
        dac_info = get_dac_info(%microdaq.private.mdaq_hwid);
        if argn(2) > 4 | argn(2) < 3 then
            mprintf("Description:\n");
            mprintf("\tWrites data to MicroDAQ analog outputs\n");
            mprintf("Usage:\n");
            mprintf("\tmdaq_ao_write(link_id, channels, data);\n")
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
        error('Unable to detect MicroDAQ confituration - run mdaq_hwinfo and try again!');
        return;
    end

    ch_count = size(channels, '*');
    max_ch = 8;
    if %microdaq.private.mdaq_hwid(3) > 3 then
        max_ch = 16;
    end
    
    if ao_range > size(dac_info.c_params.c_range_desc, "r") | ao_range < 1 then 
        disp("ERROR: Wrong AO range selected! Use one of these:");
          for i = 1:size(dac_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + dac_info.c_params.c_range_desc(i));
            end
        return; 
    end 
    

    if ch_count < 1 | ch_count > max_ch then
        disp("ERROR: Wrong AO channel selected!")
        return;
    end

    data_size = size(data, '*');
    if data_size <> ch_count then
        disp("ERROR: Wrong data for selected AO channels!");
        return;
    end
    if argn(2) == 3 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end

    global %microdaq;
    dac = %microdaq.private.mdaq_hwid(3);
    if  dac == 0 then
        disp("ERROR: Unable to read DAC configuration!");
        return;
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
endfunction
