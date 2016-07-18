function mdaq_ao_scan_data(arg1, arg2, arg3, arg4)
    link_id = -1; 

    if argn(2) == 3 then
        channel = arg1;  
        index = arg2; 
        data = arg3; 
    end
    
    if argn(2) == 4 then
        link_id = arg1; 
        channel = arg2;  
        index = arg3; 
        data = arg4; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 4 | argn(2) < 3 then
        mprintf("Description:\n");
        mprintf("\tQueue AO scan data\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ao_scan_data(link_id, channel, index, data);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tchannel - AO scan channel\n");
        mprintf("\tindex - AO scan data memory index\n");
        mprintf("\tdata - AO scan data\n");
        return;
    end

    if argn(2) == 3 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    if size(data, "c") > 1 & size(data, "r") > 1 then
        disp("ERROR: Wrong AO scan data size"); 
        return
    end
    data_size = size(data, "*"); 
    
    result = [];
    result = call("sci_mlink_ao_scan_data",..
                link_id, 1, "i",..
                channel, 2, "i",..
                index, 3, "i",..
                data, 4, "d",..
                data_size, 5, "i",..
            "out",..
                [1, 1], 6, "i");

    if result < 0  then
        mdaq_error(result)
    end

    if argn(2) == 3 then
        mdaq_close(link_id);
    end
endfunction
