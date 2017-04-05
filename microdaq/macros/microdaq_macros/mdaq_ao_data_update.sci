function mdaq_ao_data_update(arg1, arg2, arg3)
    link_id = -1; 

    if argn(2) == 2 then
        channel = arg1;  
        data = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1; 
        channel = arg2;  
        data = arg3; 
        
        if link_id < 0 then
            error("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tUpdate AO channel data in scanning single mode.\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ao_data_update(link_id, channel, data);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tchannel - AO scan channel\n");
        mprintf("\tdata - AO scan data\n");
        return;
    end

    if argn(2) == 2 then
        link_id = mdaq_open();
        if link_id < 0 then
            error("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    if size(data, "c") > 1 & size(data, "r") > 1 then
        error("ERROR: Wrong AO scan data size"); 
        return
    end
    data_size = size(data, "*"); 
    
//MDAQ_API void sci_mlink_ao_data_update(
//		IO		int 		*link_fd, 
//		IN		int 		*ch,
//		IN		double      *data,
//		IN		int			*data_size,
//		OUT		int			*result)

    result = [];
    result = call("sci_mlink_ao_data_update",..
                link_id, 1, "i",..
                channel, 2, "i",..
                data, 3, "d",..
                data_size, 4, "i",..
                "out",..
                [1, 1], 5, "i");

    if result < 0  then
        mdaq_error(result)
    end

    if argn(2) == 2 then
        mdaq_close(link_id);
    end
endfunction
