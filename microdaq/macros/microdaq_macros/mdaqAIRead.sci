function data = mdaqAIRead(arg1, arg2, arg3, arg4)
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
            mprintf("\tReads analog inputs\n");
            mprintf("Usage:\n");
            mprintf("\tdata = mdaqAIRead(linkId, channels, range, isDifferential)\n")
            mprintf("\tlinkId - connection id returned by mdaqOpen() (OPTIONAL)\n");
            mprintf("\tchannels - scalar or vector with channel numbers\n");
            mprintf("\trange - analog input range matrix e.g.\n");
            mprintf("\t        [-10,10] - single range argument applied for all used channels\n");
            mprintf("\t        [-10,10; -5,5] - multi-range argument for two channels\n");
            mprintf("\tisDifferential - scalar or vector defining measurement type (%%T - differential, %%F - single-ended)\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ confituration - run mdaqHWInfo and try again!');
        return;
    end

    if size(channels, 'r') > 1 then
        error("Single row AI channel vector expected!")
        return;
    end

    if size(aiRange, 'c') <> 2 then
        error("Vector range [low,high;low,high;...] expected!")
        return;
    end

    if size(aiMode, 'r') > 1 then
        error("Single row AI measurement mode vector expected!")
        return;
    end
    
    adc_ch_count = strtod(adc_info.channel);
    if aiMode then
        adc_ch_count = adc_ch_count / 2;
    end

    ch_count = size(channels, 'c');
    if ch_count < 1 | ch_count > adc_ch_count then
        error("Wrong AI channel selected!")
        return;
    end
    
    if max(channels) > adc_ch_count | min(channels) < 1 then
        error("Wrong AI channel selected!")
        return;
    end
    
    aiRangeSize = size(aiRange, 'r');
    if aiRangeSize <> 1 & aiRangeSize <> ch_count then
        error("Range vector should match selected AI channels!")
        return; 
    end
    
    aiModeSize = size(aiMode, 'c');
    if aiModeSize <> 1 & aiModeSize <> ch_count then
        error("Mode vector should match selected AI channels!")
        return; 
    end

    if aiRangeSize == 1 then
        range_tmp = aiRange;
        aiRange = ones(ch_count,2);
        aiRange(:,1) = range_tmp(1);
        aiRange(:,2) = range_tmp(2);
    end
    
    aiRange = matrix(aiRange', 1, ch_count*2);

    aiMode(find(aiMode==%T))=1;
    if aiModeSize == 1 then
        aiMode = ones(1, ch_count) * aiMode;    
    end

    if argn(2) == 3 then
        link_id = mdaqOpen();
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
                        aiRange, 4, "d",..
                        aiMode, 5, "i",..
                    "out",..
                        [1, ch_count], 6, "d",..
                        [1, 1], 7, "i");

    if argn(2) == 3 then
        mdaqClose(link_id);
    end
    
    if result < 0 then
        error(mdaq_error2(result), 10000+(-result));
    end
endfunction
