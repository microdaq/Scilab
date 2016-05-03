function mdaq_ao_write(arg1, arg2, arg3)
    link_id = -1;

    if argn(2) == 2 then
        channels = arg1; 
        data = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1;   
        channels = arg2; 
        data = arg3; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
 
    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tWrites data to MicroDAQ analog outputs\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ao_write(link_id, channels, data);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tchannels - analog output channels \n");
        mprintf("\tdata - data to be written\n");
        return;
    end

    global %microdaq;
    
    ch_count = size(channels, '*');
    max_ch = 8; 
    if %microdaq.private.mdaq_hwid(3) > 3 then
        max_ch = 16; 
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
    if argn(2) == 2 then
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
            data, 5, "d",..
        "out",..
            [1, 1], 6, "i");

    if result < 0 then
        mdaq_error(result)
    end
    
    if argn(2) == 2 then
        mdaq_close(link_id);
    end
endfunction
