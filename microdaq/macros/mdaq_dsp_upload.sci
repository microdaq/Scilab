function result = mdaq_dsp_upload( dsp_firmware )
    // Load and upload DSP application
    if dsp_firmware <> "" then
        if isfile(dsp_firmware) <> %t then
            mprintf(" ERROR: Unable to load DSP firmware - file %s doesn''t exists!", dsp_firmware);
            result = -1;
            return
        end

        connection_id = mdaq_open();
        if connection_id < 0 then
            disp('ERROR: Unable to connect to MicroDAQ device - check your setup!');
            result = -1;
            return;
        end

        res = mlink_dsp_load(connection_id, dsp_firmware, '');
        if res < 0 then
            // try again to load application
            mdaq_close(connection_id);
            connection_id = mdaq_open();
            if connection_id < 0 then
                disp('ERROR: Unable to connect to MicroDAQ device - check your setup!');
                result = -1;
                return;
            end
            res = mlink_dsp_load(connection_id, dsp_firmware, '');
            if res < 0 then
                disp('ERROR: Unable to load DSP firmware - reboot MicroDAQ device!');
                result = -1;

                mdaq_close(connection_id);
                return;
            end
            result = -1;
            return;
        end
        // upload already loaded program
    else
        connection_id = mdaq_open();
        if connection_id < 0 then
            disp('Unable to connect to MicroDAQ device - check your setup!');
            result = -1;
            return;
        end
    end

    res = mlink_dsp_upload(connection_id);
    if res < 0 then
        mdaq_close(connection_id);
        result = -1;
        disp("### Unable to upload DSP application on target!");
        return;
    end
    disp("### DSP application uploaded (saved) on target");

    mdaq_close(connection_id);
    result = 0;
endfunction
