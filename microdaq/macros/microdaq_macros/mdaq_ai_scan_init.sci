function  mdaq_ai_scan_init(arg1, arg2, arg3, arg4, arg5, arg6)
    link_id = -1;

    if argn(2) == 5 then
        channels = arg1;
        aiRange = arg2;
        aiMode = arg3;
        scan_freq = arg4;
        scan_time = arg5;
    end

    if argn(2) == 6 then
        link_id = arg1;
        channels = arg2;
        aiRange = arg3;
        aiMode = arg4;
        scan_freq = arg5;
        scan_time = arg6;

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        adc_info = get_adc_info(%microdaq.private.mdaq_hwid);
        if argn(2) > 6 | argn(2) < 5 then
            mprintf("Description:\n");
            mprintf("\tInit AI scan\n");
            mprintf("Usage:\n");
            mprintf("\tmdaq_ai_scan_init(link_id, channels, range, mode, frequency, time);\n");               mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
            mprintf("\tchannels - analog input channels to read\n");
            mprintf("\trange - analog input range:\n");
            for i = 1:size(adc_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + adc_info.c_params.c_range_desc(i));
            end

            if adc_info.c_params.c_diff(1) == 1 then
                mprintf("\timode - measurement type (%%T - differential, %%F - single-ended)\n");
            else
                mprintf("\timode - set %%F (differential mode not supported by AI converter)\n");
            end

            mprintf("\tfrequency - scan frequency\n");
            mprintf("\tduration - scan duration in seconds\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ confituration - run mdaq_hwinfo and try again!');
        return;
    end

    if scan_time < 0 then
        scan_time = -1;
    end

    adc_ch_count = strtod(adc_info.channel);
    ch_count = max(size(channels));
    if ch_count < 1 | ch_count > adc_ch_count then
        disp("ERROR: Wrong AI channel selected!")
        return;
    end

    if max(channels) > adc_ch_count | min(channels) < 1 then
        disp("ERROR: Wrong AI channel selected!")
        return;
    end

    if channels(1) <> 1 then
        disp("ERROR: Scan should start from channel number 1!")
        return;
    end

    if find((channels == (1:max(channels))) == %F) <> [] then
        disp("TODO: ERROR: Only consecutive channels can be used!")

        //  return;
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
    try
            
        if aiRangeSize == 1 then
            aiPolarity = ones(1,ch_count) * adc_info.c_params.c_bipolar(aiRange);
        else
            aiPolarity = adc_info.c_params.c_bipolar(aiRange)';
        end
    
        if aiRangeSize == 1 then
            aiRange_t = ones(1,ch_count) * aiRange;
            aiRange = ones(1,ch_count) * adc_info.c_params.c_range(aiRange);
        else
            aiRange_t = aiRange;
            aiRange = adc_info.c_params.c_range(aiRange)';
        end
    catch
        disp("ERROR: Wrong range selected!");
        return
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

    if argn(2) == 5 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end

    result = [];
    result = call("sci_mlink_ai_scan_init",..
    link_id, 1, "i",..
    channels, 2, "i",..
    ch_count, 3, "i",..
    aiRange, 4, "i",..
    aiPolarity, 5, "i",..
    aiMode, 6, "i",..
    scan_freq, 7, "d",..
    scan_time, 8, "d",..
    "out",..
    [1, 1], 9, "i");

    if result < 0 & result <> -88 then
        if argn(2) == 5 then
            mdaq_close(link_id);
        end
        error(mdaq_error2(result), 10000 + abs(result));
    else
        if result == -88 then
            disp("Warninng: AI scanning interrupted!")
            mdaq_ai_scan_stop()

            // time to terminate TCP connection
            sleep(200);

            result = call("sci_mlink_ai_scan_init",..
            link_id, 1, "i",..
            channels, 2, "i",..
            ch_count, 3, "i",..
            aiRange, 4, "i",..
            aiPolarity, 5, "i",..
            aiMode, 6, "i",..
            scan_freq, 7, "d",..
            scan_time, 8, "d",..
            "out",..
            [1, 1], 9, "i");
        end

        if argn(2) == 5 then
            mdaq_close(link_id);
        end

        if result < 0 then
            error(mdaq_error2(result), 10000 + abs(result));
        end

        if result == 1 then
            limited_cap = %t;
        else
            limited_cap = %f;
        end

        rows = [];
        row = '';

        adc_res = strtod(part(adc_info.resolution, 1:2))
        for j=1:ch_count
            if aiMode(j) == 29 then
                measure_type = "Differential"
            elseif (aiMode(j) == 28)
                measure_type = "Single-ended"
            end
            adc_range = diff(adc_info.c_params.c_range_value(aiRange_t(j),:))
            resolution = string((int(adc_range/2^adc_res * 1000000)) / 1000);
            rows = [rows; string(channels(j)), measure_type, adc_info.c_params.c_range_desc(aiRange_t(j)), resolution+"mV"]
        end

        mprintf("\n\tAnalog input scanning session settings:\n");
        mprintf("\t--------------------------------------------------\n")
        str2table(rows, ["Channel", "Measurement type", "Range", "Resolution"], 3)
        mprintf("\t--------------------------------------------------\n")
        if scan_freq >= 1000
            mprintf("\tScan frequency:\t\t%.3fkHz\n", scan_freq/1000);
        else
            mprintf("\tScan frequency:\t\t%dHz\n", scan_freq);
        end
        
        if scan_time < 0
            mprintf("\tDuration:\t\tInf\n");
            mprintf("\tNumber of channels:\t%d\n", ch_count)
            mprintf("\tScan count:\t\tInf");
        else
            mprintf("\tDuration:\t\t%.2fs\n", scan_time);
            mprintf("\tNumber of channels:\t%d\n", ch_count)
            mprintf("\tNumber of scans:\t%d\n", scan_time * scan_freq);
        end
        mprintf("\t--------------------------------------------------\n")
    end
endfunction
