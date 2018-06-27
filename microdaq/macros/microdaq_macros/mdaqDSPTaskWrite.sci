
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
        mprintf("Usage:\n");
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tindex - memory start index\n");
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

    [result] = call("sci_mlink_mem_set2",..
            link_id, 1, 'i',..
            start_idx, 2, 'i',..
            real(data), 3, 'r',..
            len, 4, 'i',..
        "out",..
            [1,1], 5, 'i');
            disp("dupa");
    if argn(2) == 2 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
