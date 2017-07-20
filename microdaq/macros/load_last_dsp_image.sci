function load_last_dsp_image()
    global %microdaq;
    res = 0; 
    
    if isfile(TMPDIR + filesep() + "last_mdaq_dsp_image") == %t then
        dsp_app_path = mgetl(TMPDIR + filesep() + "last_mdaq_dsp_image");
        if isfile(dsp_app_path) == %t then
            close_last_connection();
            connection_id = mdaq_open();
            if connection_id < 0 then
                message("ERROR: Unable to connect to MicroDAQ device!");
                return;
            end

            res = mlink_dsp_load(connection_id, dsp_app_path, '');
            if res < 0 then
                // try again to load application
                mdaq_close(connection_id);
                connection_id = mdaq_open();
                if connection_id < 0 then
                    message("ERROR: Unable to connect to MicroDAQ device!");
                    return;
                end
                res = mlink_dsp_load(connection_id, dsp_app_path, '');
                if res < 0 then
                    message('Unable to load DSP firmware! (' + mdaq_error2(res) + ').');
                    mdaq_close(connection_id);
                    %microdaq.dsp_loaded = %F
                    return;
                end
            end     
            disp('### Model has been loaded to MicroDAQ.');

            res_mode = mlink_set_obj(connection_id, "ext_mode", 1);
           
            res = mlink_dsp_start(connection_id,-1);
            if res < 0 then
                message("Unable to start DSP application!");
                mdaq_close(connection_id);
                %microdaq.dsp_loaded = %F;
                return;
            end

           if res_mode == -25 then
                disp('### Model has been started in Standalone mode.');   
           end

            %microdaq.dsp_loaded = %T;
            mdaq_close(connection_id);
        else
            message("Unable to find model, build model and try again!")
        end
    else
        message("Unable to find model, build model and try again!")
    end
endfunction
