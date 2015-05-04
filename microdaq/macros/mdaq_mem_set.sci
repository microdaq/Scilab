function mdaq_mem_set(start_idx, data)

    if  start_idx < 1 | start_idx > 4000000 then
        disp("ERROR: Incorrect start index - use values from 1 to 4000000!")
        return
    end

    connection_id = mdaq_open();
    if connection_id < 0 then
        disp('ERROR: Unable to connect to MicroDAQ device - check your setup!');
        return;
    end
    
    len = size(data, "*");
    [result] = call("sci_mlink_mem_set2",..
            connection_id, 1, 'i',..
            start_idx, 2, 'i',..
            real(data), 3, 'r',..
            len, 4, 'i',..
        "out",..
            [1,1], 5, 'i');
            
    if result < 0 then
        disp('ERROR: Unable to access MicroDAQ memory!');
    end
    
    mdaq_close(connection_id);
endfunction
