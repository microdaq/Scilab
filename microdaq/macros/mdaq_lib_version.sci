function fw_ver = mdaq_lib_version()
    connection_id = mdaqOpen();
    fw_ver = [];
    if connection_id > -1  then
        result = [];
        [major_ver, minor_ver, fix_ver, build_ver, result] = call("sci_mlink_lib_version",..
                                connection_id, 1, "i",..
                            "out",..
                                [1,1], 2, "i",..
                                [1,1], 3, "i",..
                                [1,1], 4, "i",..
                                [1,1], 5, "i",..
                                [1,1], 6, "i");
        mdaqClose(connection_id);
        if result < 0 then
            mdaq_error(result);
        end
        
        fw_ver = [major_ver minor_ver fix_ver build_ver];
    else
        disp("Unable to connect to MicroDAQ device!");
        fw_ver = [];
    end
    //fw_ver = fw_ver';
    clear result;
endfunction
