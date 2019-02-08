function mdaqDIODir(arg1, arg2, arg3)
    if argn(2) == 2 then
        bank = arg1; 
        direction = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1;   
        bank = arg2; 
        direction = arg3; 

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tSets MicroDAQ DIO bank direction\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqDIODir(linkID, bank, direction);\n")
        mprintf("\tlinkID - connection ID returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tbank - bank number (1-4)\n");
        mprintf("\tdirection - bank direction (0 - input, 1 - output)\n");
        return;
    end

    if bank < 1 | bank > 4 then
        error("Wrong bank number!")
    end

    if direction <> 0 then
        direction = 1;
    end

    if argn(2) == 2 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!"); 
        end
    end

    result = call("sci_mlink_dio_set_dir",..
            link_id, 1, "i",..
            bank, 2, "i",..
            direction, 3, "i",..
            0, 4, "i",..
        "out",..
            [1, 1], 5, "i");

    if argn(2) == 2 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
