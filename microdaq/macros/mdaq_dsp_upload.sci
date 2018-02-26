function mdaq_dsp_upload( arg1, arg2)
    [is_supp vers] = mdaq_is_working('mdaq_dsp_upload');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end

    if argn(2) == 2 then
        dsp_app_path = arg1;
        if arg2 == %T then
            uploadOpt = 'a';
        else
            uploadOpt = 'u';
        end
    else
        if arg1 == %T then
            uploadOpt = 'a';
        else
            uploadOpt = 'u';
        end
        dsp_app_path = mgetl(TMPDIR + filesep() + "last_mdaq_dsp_image");
    end

    if isfile(dsp_app_path) <> %t then
        message("ERROR: Unable to find compiled DSP application!");
        return
    end

    connection_id = mdaqOpen();
    if connection_id < 0 then
        message('ERROR: Unable to connect to MicroDAQ device!');
        return;
    end

    res = mlink_dsp_load(connection_id, dsp_app_path, uploadOpt);
    if res < 0 then
        // try again to load application
        mdaqClose(connection_id);
        connection_id = mdaqOpen();
        if connection_id < 0 then
            message('ERROR: Unable to connect to MicroDAQ device!');
            return;
        end
        res = mlink_dsp_load(connection_id, dsp_app_path, uploadOpt);
        if res < 0 then
            message('Unable to upload model! (' + mdaq_error2(res) + ').');
            mdaqClose(connection_id);
            return;
        end
    end

    if uploadOpt == 'u' then
        message("Model uploaded on target successfully!");
    else
        message("Model will be started automatically on system boot!");
    end

    mdaqClose(connection_id);
endfunction
