function mdaq_ao_data_queue(arg1, arg2, arg3)
    global %microdaq;
    link_id = -1; 

    if argn(2) == 2 then
        data = arg1; 
        blocking = arg2;
    end
    
    if argn(2) == 3 then
        link_id = arg1; 
        data = arg2; 
        blocking = arg3;
        
        if link_id < 0 then
            error("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tQueues AO channel data in scanning continuous mode.\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ao_data_queue(link_id, channel, data, blocking);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tdata - AO scan data\n");
        mprintf("\tblocking - blocking mode (1-enable, 0-disable)\n");
        return;
    end

    if argn(2) == 2 then
        link_id = mdaq_open();
        if link_id < 0 then
            error("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
//    if size(data, "c") > 1 & size(data, "r") > 1 then
//        error("ERROR: Wrong AO scan data size"); 
//        return
//    end
    data_size = size(data, "*"); 
    if %microdaq.private.ao_scan_ch_count <> size(data, "c") then
        if link_id > -1 then
            mdaq_close(link_id);
        end
        error("ERROR: Wrong AO scan data size"); 
        return
    end
    

//MDAQ_API void sci_mlink_ao_data_queue(
//		IO		int 		*link_fd, 
//		IN		double      *data,
//		IN		int			*data_size,
//		IN		int			*blocking,
//		OUT		int			*result)
//    mprintf("link_fd: %d\n", link_id)
//    disp(data);

    result = [];
    result = call("sci_mlink_ao_data_queue",..
                link_id, 1, "i",..
                data, 2, "d",..
                data_size, 3, "i",..
                blocking, 4, "i",..
                "out",..
                [1, 1], 5, "i");

    if result < 0  then
        mdaq_error(result)
    end

    if argn(2) == 2 then
        mdaq_close(link_id);
    end
endfunction
