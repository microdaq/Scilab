function data = mdaq_ai_read(arg1, arg2, arg3, arg4)
    data = [];
    link_id = -1;

    if argn(2) == 3 then
        channels = arg1;
        aiRange = arg2;
        aiMode = arg3;
    end

    if argn(2) == 4 then
        link_id = arg1;
        channels = arg2;
        aiRange = arg3;
        aiMode = arg4;
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        adc_info = %microdaq.private.adc_info;
        if argn(2) > 4 | argn(2) < 3 then
            mprintf("Description:\n");
            mprintf("\tReads MicroDAQ analog inputs\n");
            mprintf("Usage:\n");
            mprintf("\tmdaq_ai_read(link_id, channels, range, aiMode);\n")
            mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
            mprintf("\tchannels - scalar or vector with channel numbers\n");
            mprintf("\trange - scalar or vector with input ranges:\n");
            for i = 1:size(adc_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + adc_info.c_params.c_range_desc(i));
            end
            mprintf("\taiMode - scalar or vector defining measurement type (%%T - differential, %%F - single-ended)\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ confituration - run mdaq_hwinfo and try again!');
        return;
    end

    if size(channels, 'r') > 1 then
        disp("ERROR: Single row AI channel vector expected!")
        return;
    end

    if size(aiRange, 'r') > 1 then
        disp("ERROR: Single row AI range vector expected!")
        return;
    end

    if size(aiMode, 'r') > 1 then
        disp("ERROR: Single row AI measurement mode vector expected!")
        return;
    end
    
    adc_ch_count = strtod(adc_info.channel);
    if aiMode then
        adc_ch_count = adc_ch_count / 2;
    end

    ch_count = size(channels, 'c');
    if ch_count < 1 | ch_count > adc_ch_count then
        disp("ERROR: Wrong AI channel selected!")
        return;
    end
    
    if max(channels) > adc_ch_count | min(channels) < 1 then
        disp("ERROR: Wrong AI channel selected!")
        return;
    end
    
    aiRangeSize = size(aiRange, 'c');
    if aiRangeSize <> 1 & aiRangeSize <> ch_count then
        disp("ERROR: Range vector should match selected AI channels!")
        return; 
    end
    
    aiModeSize = size(aiMode, 'c');
    if aiModeSize <> 1 & aiModeSize <> ch_count then
        disp("ERROR: Mode vector should match selected AI channels!")
        return; 
    end

    if aiRangeSize == 1 then
        aiPolarity = ones(1,ch_count) * adc_info.c_params.c_bipolar(aiRange);
    else
        aiPolarity = adc_info.c_params.c_bipolar(aiRange)';
    end

    if aiRangeSize == 1 then
        aiRange = ones(1,ch_count) * adc_info.c_params.c_range(aiRange);
    else
        aiRange = adc_info.c_params.c_range(aiRange)';
    end
    
    aiMode_t = aiMode; 
    if aiModeSize == 1 then
        if aiMode == %T then
            aiMode = ones(1,ch_count) * 29;
        else
            aiMode = ones(1,ch_count) * 28;
        end
    else
        for i = find(aiMode_t == %T)
            aiMode(i) = 29;
        end
        for i = find(aiMode_t == %F)
            aiMode(i) = 28;
        end
    end
    
    clear aiMode_t;

    if argn(2) == 3 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end
    
    result = [];
    [data result] = call("sci_mlink_ai_read",..
                        link_id, 1, "i",..
                        channels, 2, "i",..
                        ch_count, 3, "i",..
                        aiRange, 4, "i",..
                        aiPolarity, 5, "i",..
                        aiMode, 6, "i",..
                    "out",..
                        [1, ch_count], 7, "d",..
                        [1, 1], 8, "i");

    if argn(2) == 3 then
        mdaq_close(link_id);
    end
    
    if result < 0 then
        mdaq_error(result);
    end
endfunction
