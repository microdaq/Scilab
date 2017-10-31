function  mdaqAIScanInit(arg1, arg2, arg3, arg4, arg5, arg6)
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
            error("Invalid connection ID!")
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
            mprintf("\tmdaqAIScanInit(linkID, channels, range, isDifferential, rate, duration)\n");
			mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
            mprintf("\tchannels - analog input channels to read\n");
            mprintf("\trange - analog input range matrix e.g.\n");
            mprintf("\t        [-10,10] - single range argument applied for all used channels\n");
            mprintf("\t        [-10,10;-5,5] - multi-range argument for two channels\n");
			mprintf("\tisDifferential - scalar or vector with measurement mode settings: %%T - differential, %%F - single-ended mode\n");
            mprintf("\trate - scans per second rate (scan frequency)\n");
            mprintf("\tduration - scan duration in seconds\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ configuration. Run mdaqHWInfo() function.');
    end
    
    ch_count = size(channels, 'c');
    
    if scan_time < 0 then
        scan_time = -1;
    end

    if size(channels, 'r') > 1 then
        error('Wrong channel - scalar or single row vector expected')
    end

    if size(aiRange, 'c') <> 2 then
        error('Wrong range - matrix range [low,high;low,high;...] expected')
    end

    aiRangeSize = size(aiRange, 'r');
    if aiRangeSize <> 1 & aiRangeSize <> ch_count then
        error('Range vector should match selected AI channels')
    end
    
    if type(aiMode) == 1 then
        if size(find(aiMode>1), '*') > 0
            error('Wrong mode - boolean value expected (%T/1, %F/0)')
        end 
    end
    
    if size(aiMode, 'r') > 1 then
        error('Wrong mode - scalar or single row vector expected')
    end
    
    aiModeSize = size(aiMode, 'c');
    if aiModeSize <> 1 & aiModeSize <> ch_count then
        error('Mode vector should match selected AI channels')
    end
    
    if aiRangeSize == 1 then
        range_tmp = aiRange;
        aiRange = ones(ch_count,2);
        aiRange(:,1) = range_tmp(1);
        aiRange(:,2) = range_tmp(2);
        clear range_tmp;
    end
    
    aiRange_t = aiRange;
    aiRange = matrix(aiRange', 1, ch_count*2);

    aiMode(find(aiMode==%T))=1;
    if aiModeSize == 1 then
        aiMode = ones(1, ch_count) * aiMode;    
    end

    if argn(2) == 5 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end

    result = [];
    real_freq = scan_freq;
    [result real_freq] = call("sci_mlink_ai_scan_init",..
                    link_id, 1, "i",..
                    channels, 2, "i",..
                    ch_count, 3, "i",..
                    aiRange, 4, "d",..
                    aiMode, 5, "i",..
                    scan_freq, 6, "d",..
                    scan_time, 7, "d",..
                "out",..
                    [1, 1], 9, "i",..
                    [1, 1], 8, "d");

    if result < 0 & result <> -88 then
        if argn(2) == 5 then
            mdaqClose(link_id);
        end
        error(mdaq_error2(result), 10000 + abs(result));
    else
        if result == -88 then
            disp("Warninng: AI scanning interrupted!")
            mdaqAIScanStop()

            // time to terminate TCP connection
            sleep(200);
            [result real_freq] = call("sci_mlink_ai_scan_init",..
                            link_id, 1, "i",..
                            channels, 2, "i",..
                            ch_count, 3, "i",..
                            aiRange, 4, "d",..
                            aiMode, 5, "i",..
                            scan_freq, 6, "d",..
                            scan_time, 7, "d",..
                        "out",..
                            [1, 1], 9, "i",..
                            [1, 1], 8, "d");
        end

        if argn(2) == 5 then
            mdaqClose(link_id);
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
            if aiMode(j) == 1 then
                measure_type = "Differential"
            elseif (aiMode(j) == 0)
                measure_type = "Single-ended"
            end
            adc_range = aiRange_t(j, 2) - aiRange_t(j, 1); 
            resolution = string((int(adc_range/2^adc_res * 1000000)) / 1000);
            rangeStr="";
            if aiRange_t(j, 1) < 0 then
                rangeStr = "±" + string(aiRange_t(j, 2))+"V";
            else 
                rangeStr = "0-" + string(aiRange_t(j, 2))+"V";
            end
            rows = [rows; "AI"+string(channels(j)), measure_type, rangeStr, resolution+"mV"]
        end

        mprintf("\nAnalog input scanning session settings:\n");
        mprintf("\t--------------------------------------------------\n")
        str2table(rows, ["Channel", "Measurement type", "Range", "Resolution"], 3)
        mprintf("\t--------------------------------------------------\n")
        if scan_freq >= 1000
            mprintf("\tScan frequency:\t\t%.5f kHz\n", scan_freq/1000);
            mprintf("\tActual scan frequency:\t%.5f kHz\n", real_freq/1000);
        else
            mprintf("\tScan frequency:\t\t%.5f Hz\n", scan_freq);
            mprintf("\tActual scan frequency:\t%.5f Hz\n", real_freq);
        end
        if 1 /real_freq > 0.001 then
            mprintf("\tScan period: \t\t%.5f seconds\n", 1 / real_freq);
        end
        
        if 1 /real_freq <= 0.001 then
            mprintf("\tScan period: \t\t%.5f ms\n", 1 / real_freq * 1000);
        end

        if scan_time < 0
            mprintf("\tNumber of channels:\t%d\n", ch_count)
            mprintf("\tNumber of scans:\tInf\n");
            mprintf("\tDuration:\t\tInf\n");
        else
            mprintf("\tNumber of channels:\t%d\n", ch_count)
            mprintf("\tNumber of scans:\t%d\n", scan_time * scan_freq);
            if scan_time == 1 
                mprintf("\tDuration:\t\t%.2f second\n", scan_time);
            else
                mprintf("\tDuration:\t\t%.2f seconds\n", scan_time);
            end
        end
        mprintf("\t--------------------------------------------------\n")
    end
endfunction
