function mdaqDSPTerminate(arg1)
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaqDSPTerminate');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    
    global %microdaq;

    if argn(2) == 1 then
        link_id = arg1;
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    if argn(2) == 0 then
        link_id = mdaqOpen();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end
    
    res = mlink_set_obj(link_id, 'ext_mode', 1 );
    if res == 0 then
        client_disconnect();
    end
    %microdaq.dsp_loaded = %F;
    
    mlink_set_obj(link_id, 'model_stop_flag', 1.0 );
    
    if argn(2) == 0 then
        mdaqClose(link_id);
    end
endfunction
