function result = dsp_start( dsp_firmware )
    global %microdaq;
    result = -1;
    if isfile(dsp_firmware) <> %t then
        mprintf(" ERROR: Unable to load DSP firmware - file %s doesn''t exists!", dsp_firmware);
        return
    end

    connection_id = mdaq_open();
    if connection_id < 0 then
        disp('ERROR: Unable to connect to MicroDAQ device - check your setup!');
        return;
    end

    res = mdaq_dsp_load(connection_id, dsp_firmware, '');
    if res < 0 then
        // try again to load application
        mdaq_close(connection_id);
        connection_id = mdaq_open();
        if connection_id < 0 then
            disp('ERROR: Unable to connect to MicroDAQ device - check your setup!');
            return;
        end
        res = mdaq_dsp_load(connection_id, dsp_firmware, '');
        if res < 0 then
            disp('ERROR: Unable to load DSP firmware - reboot MicroDAQ device!');
            mdaq_close(connection_id);
            return;
        end
    end

    res = mdaq_dsp_start(connection_id);
    if res < 0 then
        disp("ERROR: Unable to start DSP application!");
        mdaq_close(connection_id);
        return;
    end

    mdaq_close(connection_id);

    //Give time to start DSP firmware
    sleep(200);

    %microdaq.dsp_loaded = %T;
    result = client_connect(mdaq_get_ip(), 4344);
    if result < 0 then
        disp("ERROR: Unable to connect to MicroDAQ - reboot MicroDAQ device!")
        %microdaq.dsp_loaded = %F;
        return;
    end

    result = 0;

endfunction
