function result = dsp_stop()
    global %microdaq; 
    if  %microdaq.dsp_loaded == %T then

        client_disconnect(1);
        %microdaq.dsp_loaded = %F;

        [mdaq_ip_addr, result] = mdaq_get_ip();
        if result < 0 then
            disp("Unable to get MicroDAQ IP address - run microdaq_setup!");
            result = -1;
            return;
        end
        connection_id = mdaq_connect(mdaq_ip_addr, 4343);
        if connection_id < 0 then
            result = -1;
            return;
        end

        if connection_id > -1 then
            mdaq_set_obj(connection_id, 'model_stop_flag', 1 );
            mdaq_disconnect(connection_id);
        end
    else
        disp("DSP is not running, use dsp_start to run DSP"); 
        %microdaq.dsp_loaded = %F
        result = -1;
    end
endfunction
