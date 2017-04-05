function mdaq_ao_data_queue(arg1, arg2, arg3, arg4)
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
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 4 | argn(2) < 3 then
        mprintf("Description:\n");
        mprintf("\tQueues AO channel in scanning continuous mode.\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ao_data_queue(link_id, channel, data, blocking);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tchannel - AO scan channel\n");
        mprintf("\tdata - AO scan data\n");
        mprintf("\tblocking - blocking mode (1-enable, 0-disable)\n");
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

//MDAQ_API void sci_mlink_ao_data_queue(
//		IO		int 		*link_fd, 
//		IN		double      *data,
//		IN		int			*data_size,
//		IN		int			*blocking,
//		OUT		int			*result)

    result = [];
    result = call("sci_mlink_ao_data_queue",..
                link_id, 1, "i",..
                channel, 2, "i",..
                data, 3, "d",..
                data_size, 4, "i",..
                blocking, 5, "i",..
                "out",..
                [1, 1], 6, "i");

    if result < 0  then
        mdaq_error(result)
    end

    if argn(2) == 3 then
        mdaq_close(link_id);
    end
endfunction
