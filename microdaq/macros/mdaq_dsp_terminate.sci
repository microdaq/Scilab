function mdaq_dsp_terminate(arg1)
    global %microdaq;

    if argn(2) == 1 then
        link_id = arg1;
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    if argn(2) == 0 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end
    
    res = mlink_set_obj(link_id, 'ext_mode', 1 );
    if res == 0 then
        client_disconnect(1);
    end
    %microdaq.dsp_loaded = %F;
    
    mlink_set_obj(link_id, 'model_stop_flag', 1.0 );
    
    if argn(2) == 0 then
        mdaq_close(link_id);
    end
endfunction
