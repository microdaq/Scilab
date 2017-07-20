function mdaq_mem_set(arg1, arg2, arg3)

    if argn(2) == 2 then
        start_idx = arg1; 
        data = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1;   
        start_idx = arg2; 
        data = arg3; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tWrites MicroDAQ memory\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_mem_set(link_id, start, data);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tstart - memory start index\n");
        mprintf("\tdata - data to be written\n");
        return;
    end

    if  start_idx < 1 | start_idx > 4000000 then
        disp("ERROR: Incorrect start index - use values from 1 to 4000000!")
        return
    end

    if argn(2) == 2 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    len = size(data, "*");
    [result] = call("sci_mlink_mem_set2",..
            link_id, 1, 'i',..
            start_idx, 2, 'i',..
            real(data), 3, 'r',..
            len, 4, 'i',..
        "out",..
            [1,1], 5, 'i');
            
    if argn(2) == 2 then
        mdaq_close(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
