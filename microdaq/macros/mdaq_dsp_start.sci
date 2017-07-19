function result = mdaq_dsp_start( arg1, arg2, arg3 )
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaq_dsp_start');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end

    global %microdaq;
    result = -1;

    if argn(2) == 2 then
        dsp_firmware = arg1; 
        model_freq = arg2;
    end

    if argn(2) == 3 then
        link_id = arg1;   
        dsp_firmware = arg2; 
        model_freq = arg3; 
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 | isfile(dsp_firmware) <> %T then
        mprintf("Description:\n");
        mprintf("\tStarts DSP execution\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_dsp_start(linkId, dspFirmware, stepTime);\n")
        mprintf("\tlinkId - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tdspFirmware - XCos generated DSP application\n");
        mprintf("\stepTime - custom model mode step or -1 to keep Xcos settings\n");
        return;
    end

    if argn(2) == 2 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end

    res = mlink_dsp_load(link_id, dsp_firmware, '');
    if res < 0 then
        res = mlink_dsp_load(link_id, dsp_firmware, '');
        if res < 0 then
            if argn(2) == 2 then
                mdaq_close(link_id);
            end
            error(mdaq_error2(res), 10000 + abs(res)); 
        end
    end

    res = mlink_dsp_start(link_id, model_freq);
    if res < 0 then
        if argn(2) == 2 then
            mdaq_close(link_id);
        end
        error(mdaq_error2(res), 10000 + abs(res));
    end

    //Give time to start DSP firmware
    sleep(200);

    %microdaq.dsp_loaded = %T;
    res = mlink_set_obj(link_id, 'ext_mode', 1 );
    
    if argn(2) == 2 then
        mdaq_close(link_id);
    end

    if res == 0 then
        result = client_connect(mdaq_get_ip(), 4344);
        if result < 0 then
            disp("ERROR: Unable to initialize TCP data stream for Ext mode!")
            %microdaq.dsp_loaded = %F;
            return;
        end
        %microdaq.dsp_ext_mode = %T;
    else
        %microdaq.dsp_ext_mode = %F;
    end
    result = 0;
endfunction
