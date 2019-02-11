function mdaqDSPInit( arg1, arg2, arg3, arg4 )
    global %microdaq;
    result = -1;

    if argn(2) == 3 then
        dsp_firmware = pathconvert(arg1, %F); 
        rate = arg2;
        duration = arg3;
    end

    if argn(2) == 4 then
        link_id = arg1;   
        dsp_firmware = pathconvert(arg2, %F); 
        rate = arg3; 
        duration = arg4; 
        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    if argn(2) > 4 | argn(2) < 3 then
        mprintf("Description:\n");
        mprintf("\tLoads and configures DSP application\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqDSPInit(linkId, executable, rate, duration);\n")
        mprintf("\tlinkId - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\texecutable - XCos generated DSP application path\n");
        mprintf("\trate - DSP application step per second rate (-1 - keep Xcos settings)\n");
        mprintf("\tduration - defines how many seconds DSP application will be executed (-1 - infinity)\n");
        return;
    end

    if rate < 0 then
        rate = -1; 
    end

    if argn(2) == 3 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end

    result = call("sci_mlink_dsp_init",..
            link_id, 1, "i",..
            dsp_firmware, 2, "c",..
            rate, 3, "d",...
            duration, 4, "d",...
        "out",..
            [1,1], 5, "i");

    if argn(2) == 3 then
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
