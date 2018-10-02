function mdaqAIScanSync(arg1, arg2, arg3)
    link_id = -1;
    result = [];
                 
    if argn(2) == 2 then
        dio = arg1;
        edge = arg2;
    end

    if argn(2) == 3 then
        link_id = arg1;
        dio = arg2;
        edge = arg3;

        if link_id < 0 then
            error("Invalid connection ID!")
            return;
        end
    end
 
    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tSynchronizes analg input conversion with digital input\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqAIScanSync(linkID, dio, edge)\n");
		mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tdio - digital input pin (1-8)\n");
        mprintf("\tedge - type of edge which triggers analog input conversion\n");
        mprintf("\t\t 1 - falling edge\n");
        mprintf("\t\t 2 - rising edge\n");
        mprintf("\t\t 3 - falling or rising edge\n");
        return;
    end

    if argn(2) == 2 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end
    
    result = [];
    result = call("sci_mlink_ai_scan_sync",..
                    link_id, 1, "i",..
                    dio, 2, "i",..
                    edge, 3, "i",..
                "out",..
                    [1, 1], 4, "i");

    if result < 0 then
        if argn(2) == 2 then
            mdaqClose(link_id);
        end
        error(mdaq_error2(result), 10000 + abs(result));
    end
    
    if argn(2) == 5 then
            mdaqClose(link_id);
    end
endfunction
