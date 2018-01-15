function result = mdaqDSPStart( arg1, arg2, arg3 )
     // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaqDSPStart');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    
    global %microdaq;
    result = -1;

    if argn(2) == 2 then
        dsp_firmware = pathconvert(arg1, %F); 
        model_freq = arg2;
    end

    if argn(2) == 3 then
        link_id = arg1;   
        dsp_firmware = pathconvert(arg2, %F); 
        model_freq = arg3; 
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tStarts DSP execution\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqDSPStart(linkId, dspFirmware, stepTime);\n")
        mprintf("\tlinkId - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tdspFirmware - XCos generated DSP application\n");
        mprintf("\stepTime - custom model mode step or -1 to keep Xcos settings\n");
        return;
    end

    if argn(2) == 2 then
        link_id = mdaqOpen();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end

    result = call("sci_mlink_dsp_run",..
            link_id, 1, "i",..
            dsp_firmware, 2, "c",..
            model_freq, 3, "d",...
        "out",..
            [1,1], 4, "i");
    
    if argn(2) == 2 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
    
    result = 0;
endfunction
