function result = adc_check_params(channels, aiRange, aiMode)
    data = [];
    result = 0; 
    [link_id, result] = call("sci_mlink_connect",..
                            mdaq_get_ip(), 1, "c",..
                            4343, 2, "i",..
                        "out",..
                            [1, 1], 3, "i",..
                            [1, 1], 4, "i");
    if result < 0 then
        result = 0;
        return; 
    end

        message("Can not verify block settings - connect MicroDAQ device!")
    [data, result] = call("sci_mlink_ai_read",..
                        link_id, 1, "i",..
                        channels, 2, "i",..
                        ch_count, 3, "i",..
                        aiRange, 4, "i",..
                        aiPolarity, 5, "i",..
                        aiMode, 6, "i",..
                    "out",..
                        [1, ch_count], 7, "d",..
                        [1, 1], 8, "i");

    call("sci_mlink_disconnect",..
            link_id, 1, "i",..
        "out",..
            [1, 1], 2, "i");
endfunction
