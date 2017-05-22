function mdaq_dsp_upload( dsp_firmware )
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaq_dsp_upload');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    
    // Load and upload DSP application
    if argn(2) == 1 then
        if isfile(dsp_firmware) <> %t then
            message("ERROR: File not found!");
            return
        end
        
        connection_id = mdaq_open();
        if connection_id < 0 then
            message('ERROR: Unable to connect to MicroDAQ device - check your setup!');
            return;
        end

        res = mlink_dsp_load(connection_id, dsp_firmware, '');
        if res < 0 then
            // try again to load application
            mdaq_close(connection_id);
            connection_id = mdaq_open();
            if connection_id < 0 then
                message('ERROR: Unable to connect to MicroDAQ device - check your setup!');
                return;
            end
            res = mlink_dsp_load(connection_id, dsp_firmware, '');
            if res < 0 then
                message('ERROR: Unable to load DSP firmware - reboot MicroDAQ device!');
                mdaq_close(connection_id);
                return;
            end
        end
    // upload already loaded program
    else
        connection_id = mdaq_open();
        if connection_id < 0 then
            message('ERROR: Unable to connect to MicroDAQ device - check your setup!');
            return;
        end
    end

    // only Standalone model can be uploaded
    result = mlink_set_obj(connection_id, "ext_mode", 1);
    if result == -25 then
        res = mlink_dsp_upload(connection_id);
        if res == -3 then
            message("ERROR: Unable to upload - model not loaded on target!");
            mdaq_close(connection_id);
            return;
        end
    else
        message("ERROR: Unable to upload Ext model - only Standalone model can be uploaded on target!");
        mdaq_close(connection_id);
        return;
    end

    message("DSP application uploaded (saved) on target successfully!");
    mdaq_close(connection_id);
endfunction
