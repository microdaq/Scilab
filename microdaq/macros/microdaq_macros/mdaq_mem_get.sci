function [data] = mdaq_mem_get(arg1, arg2, arg3, arg4)
    data = [];
    result = 0;

    if argn(2) == 3 then
        start_index = arg1;
        data_size = arg2;
        vector_size = arg3;
    end

    if argn(2) == 4 then
        link_id = arg1;
        start_index = arg2;
        data_size = arg3;
        vector_size = arg4;

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 4 | argn(2) < 3 then
        mprintf("Description:\n");
        mprintf("\tReads MicroDAQ volatile memory\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_mem_get(link_id, start, size, vec_size);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tstart - memory start index\n");
        mprintf("\tsize - total data size to be read\n");
        mprintf("\tvec_size - MEM write block vector size\n");
        return;
    end

    if  start_index < 1 | start_index > 4000000 then
        disp("ERROR: Incorrect start index - use values from 1 to 4000000!")
        return;
    end

    if data_size < 1 then
        disp("ERROR: Incorrect data size!");
        return;
    end

    if vector_size < 1 then
        disp("ERROR: Incorrect data vector size!");
        return;
    end

    size_mod = modulo(data_size, vector_size)
    if size_mod <> 0  then
        disp("ERROR: Incorrect data and vector size!");
        return;
    end

    row_size = vector_size;
    col_size = data_size / vector_size;

    if argn(2) == 3 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end

    [data result] = call("sci_mlink_mem_get2",..
                            link_id, 1, 'i',..
                            start_index, 2, 'i',..
                            data_size, 3, 'i',..
                        "out",..
                            [row_size, col_size] , 4, 'r',..
                            [1,1], 5, 'i');

    if argn(2) == 3 then
        mdaq_close(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
