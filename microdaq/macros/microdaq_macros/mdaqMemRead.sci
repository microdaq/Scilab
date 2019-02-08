function [data] = mdaqMemRead(arg1, arg2, arg3, arg4)
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
            error("Invalid connection id!")
        end
    end

    if argn(2) > 4 | argn(2) < 3 then
        mprintf("Description:\n");
        mprintf("\tReads shared memory\n");
        mprintf("Usage:\n");
        mprintf("\tdata = mdaqMemRead(linkID, start, size, vectorSize)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tstart - memory start index\n");
        mprintf("\tsize - total data size to be read\n");
        mprintf("\tvectorSize - Xcos MEM write block vector size\n");
        return;
    end

    if data_size < 1 then
            error("Invalid  ID!")
    end

    if vector_size < 1 then
		error("Incorrect data vector size!");
    end

    if  start_index < 1 | start_index > 250000-data_size then
        error("Incorrect start index - use values from 1 to 250000-(data size)!")
    end

    size_mod = modulo(data_size, vector_size)
    if size_mod <> 0  then
        error("Incorrect data and vector size!");
    end

    row_size = vector_size;
    col_size = data_size / vector_size;

    if argn(2) == 3 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
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
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
