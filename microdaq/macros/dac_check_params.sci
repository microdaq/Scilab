    data = [];
    result = 0; 
    [link_id, result] = call("sci_mlink_connect",..
                            mdaq_get_ip(), 1, "c",..
                            4343, 2, "i",..
                        "out",..
                            [1, 1], 3, "i",..
                            [1, 1], 4, "i");
    if result < 0 then
        message("Can not verify block settings - connect MicroDAQ device!")
        result = 0;
        return; 
    end
    aoRange = matrix(aoRange', 1, size(channels, 'c')*2);
    result = call("sci_mlink_ao_check_params",..
                        link_id, 1, "i",..
                        channels, 2, "i",..
                        size(channels, 'c'), 3, "i",..
                        aoRange, 4, "d",..
                    "out",..
                        [1, 1], 5, "i");

    call("sci_mlink_disconnect",..
            link_id, 1, "i",..
        "out",..
            [1, 1], 2, "i");

endfunction
