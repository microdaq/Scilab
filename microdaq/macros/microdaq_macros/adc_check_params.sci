function result = adc_check_params(arg1, arg2, arg3)
    data = [];
    link_id = -1;
    result = 0; 

    if argn(2) == 3 then
        channels = arg1;
        aiRange = arg2;
        aiMode = arg3;
    end
    
    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        adc_info = %microdaq.private.adc_info;
    else
        result 0; 
        return;
    end

    ch_count = size(channels, 'c');
    aiModeSize = size(aiMode, 'c');
    aiRangeSize = size(aiRange, 'c');
    
    if aiRangeSize == 1 then
        aiPolarity = ones(1,ch_count) * adc_info.c_params.c_bipolar(aiRange);
    else
        aiPolarity = adc_info.c_params.c_bipolar(aiRange)';
    end
    
    aiMode_t = aiMode; 
    if aiModeSize == 1 then
        if aiMode == 1 then
            aiMode = ones(1,ch_count) * 29;
        else
            aiMode = ones(1,ch_count) * 28;
        end
    else
        for i = find(aiMode_t == 1)
            aiMode(i) = 29;
        end
        for i = find(aiMode_t == 0)
            aiMode(i) = 28;
        end
    end
    
    clear aiMode_t;

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

    result = [];
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
