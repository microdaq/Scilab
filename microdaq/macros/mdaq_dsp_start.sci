function result = mdaq_dsp_start( arg1, arg2, arg3 )

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
        mprintf("\tmdaq_dsp_start(link_id, dsp_firmware);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tdsp_firmware - XCos generated DSP application path\n");
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
            disp('ERROR: Unable to load DSP firmware - reboot MicroDAQ device!');
            if argn(2) == 1 then
                mdaq_close(link_id);
            end
            return;
        end
    end

    res = mlink_dsp_start(link_id, model_freq);
    if res < 0 then
        disp("ERROR: Unable to start DSP application!");
        if argn(2) == 1 then
            mdaq_close(link_id);
        end
        return;
    end

    if res < 0  then
        mdaq_error(res)
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
            disp("ERROR: Unable to connect to MicroDAQ - reboot MicroDAQ device!")
            %microdaq.dsp_loaded = %F;
            return;
        end
        %microdaq.dsp_ext_mode = %T;
    else
        %microdaq.dsp_ext_mode = %F;
    end
    result = 0;
endfunction
