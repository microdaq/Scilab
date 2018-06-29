function mdaqDSPTaskInit( arg1, arg2, arg3, arg4 )
     // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaqDSPTaskInit');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end

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
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 4 | argn(2) < 3 then
        mprintf("Description:\n");
        mprintf("\tInitializes DSP task\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqDSPTaskInit(linkId, path, rate, duration);\n")
        mprintf("\tlinkId - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tpath - XCos generated DSP application path\n");
        mprintf("\trate - DSP application step per second rate (-1 - keep Xcos settings)\n");
        mprintf("\tduration - task duration in seconds (-1 - infinity)\n");
        return;
    end

    if rate < 0 then
        rate = -1; 
    elseif rate >= 0 & rate < 0.1 then 
        error("Wrong rate parameter")
    else
        rate = 1/rate;
    end

    if argn(2) == 3 then
        link_id = mdaqOpen();
        if link_id < 0  then
            error(mdaq_error2(link_id), 10000 + abs(link_id)); 
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
