function mdaqDIOWrite(arg1, arg2, arg3)

    if argn(2) == 2 then
        dio = arg1;
        state = arg2;
    end

    if argn(2) == 3 then
        link_id = arg1;
        dio = arg2;
        state = arg3;

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tWrites DIO state\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqDIOWrite(linkID, dio, state);\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tdio - DIO line number(s)\n");
        mprintf("\tstate - DIO output value(s) to be written\n");
        return;
    end
    
    if find(%t == (size(dio) <> size(state))) & size(state, '*') <> 1 then
        error("State argument should be scalar or vector with size the same as dio argument")
    end
    
    if size(dio, 'r')  > 1 then
        error('Scalar or single row vector expected as a dio argument');
    end

    count = size(dio, 'c');
    state(find(state==%T))=1;
    if size(state, 'c') == 1 then
        state = ones(1, count) * state;    
    end
    
    if argn(2) == 2 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end

    result = call("sci_mlink_dio_set",..
                    link_id, 1, "i",..
                    dio, 2, "i",..
                    state, 3, "i",..
                    count, 4, "i",..
                "out",..
                    [1, 1], 5, "i");

    if argn(2) == 2 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
