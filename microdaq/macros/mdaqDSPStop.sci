function mdaqDSPStop(arg1)
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaqDSPStop');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    
    global %microdaq; 

    if %microdaq.dsp_loaded == %T then
        if argn(2) == 1 then
            link_id = arg1;   
            if link_id < 0 then
                disp("ERROR: Invalid link ID!")
                return;
            end
        end

        if %microdaq.dsp_ext_mode then
            client_disconnect();
        end

        %microdaq.dsp_loaded = %F;
        if argn(2) == 0 then
            link_id = mdaqOpen();
            if link_id < 0 then
                disp("ERROR: Unable to connect to MicroDAQ device!");
                return; 
            end
        end

        res = mlink_set_obj(link_id, 'model_stop_flag', 1.0 );
        res = mlink_set_obj(link_id, 'terminate_signal_task', 1 );
        if argn(2) == 0 then
            mdaqClose(link_id);
        end

    else
        disp("DSP is not running, use mdaqDSPStart to run DSP!"); 
        %microdaq.dsp_loaded = %F
    end
endfunction
