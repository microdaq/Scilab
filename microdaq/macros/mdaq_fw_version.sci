function fw_ver = mdaq_fw_version()
    connection_id = mdaq_open();
    if connection_id > -1  then
        result = [];
        [fw_ver, result] = call("sci_mlink_version",..
                                connection_id, 1, "i",..
                            "out",..
                                [4,1], 2, "i",..
                                [1,1], 3, "i");

        mdaq_close(connection_id);
        if result < 0 then
            mdaq_error(result);
        end
    else
        disp("Unable to connect to MicroDAQ device!");
        fw_ver = [];
    end
    fw_ver = fw_ver';
    clear result;
endfunction
