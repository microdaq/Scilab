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
            mprintf("\tmdaq_ai_scan_init(link_id, channels, range, mode, frequency, duration);\n");                     mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
            mprintf("\tchannels - analog input channels to read\n");
            mprintf("\trange - analog input range:\n");
            for i = 1:size(adc_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + adc_info.c_params.c_range_desc(i));
            end

            if adc_info.c_params.c_diff(1) == 1 then
                mprintf("\tmode - measurement type (%%T - differential, %%F - single-ended)\n");
            else
                mprintf("\tmode - set %%F (differential mode not supported by AI converter)\n");
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


    if size(channels, 'r') > 1 then
        disp("ERROR: Single row AI channel vector expected!")
        return;
    end

    if size(aiRange, 'c') <> 2 then
        disp("ERROR: Vector range [low,high;low,high;...] expected!")
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
    
    aiRangeSize = size(aiRange, 'r');
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
        link_id = mdaq_open();
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
            mdaq_close(link_id);
        end
        error(mdaq_error2(result), 10000 + abs(result));
    else
        if result == -88 then
            disp("Warninng: AI scanning interrupted!")
            mdaq_ai_scan_stop()

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
            if aiMode(j) == 1 then
                measure_type = "Differential"
            elseif (aiMode(j) == 0)
                measure_type = "Single-ended"
            end
            adc_range = diff(aiRange_t(j, 1), aiRange_t(j, 2) );
            resolution = string((int(adc_range/2^adc_res * 1000000)) / 1000);
            rows = [rows; string(channels(j)), measure_type, "dupa" , resolution+"mV"]
        end

        mprintf("\nAnalog input scanning session settings:\n");
        mprintf("\t--------------------------------------------------\n")
        str2table(rows, ["Channel", "Measurement type", "Range", "Resolution"], 3)
        mprintf("\t--------------------------------------------------\n")
        if scan_freq >= 1000
            mprintf("\tScan frequency:\t\t%.4fkHz\n", scan_freq/1000);
            mprintf("\tActual scan frequency:\t%.4fkHz\n", real_freq/1000);
        else
            mprintf("\tScan frequency:\t\t%.4fHz\n", scan_freq);
            mprintf("\tActual scan frequency:\t%.4fHz\n", real_freq);
        end
        if 1 /real_freq > 0.001 then
            mprintf("\tScan period: \t\t%fs\n", 1 / real_freq);
        end
        
        if 1 /real_freq <= 0.001 then
            mprintf("\tScan period: \t\t%fms\n", 1 / real_freq * 1000);
        end

        if scan_time < 0
            mprintf("\tDuration:\t\tInf\n");
            mprintf("\tNumber of scans:\tInf\n");
            mprintf("\tNumber of channels:\t%d\n", ch_count)
        else
            mprintf("\tDuration:\t\t%.2fs\n", scan_time);
            mprintf("\tNumber of scans:\t%d\n", scan_time * scan_freq);
            mprintf("\tNumber of channels:\t%d\n", ch_count)
        end
        mprintf("\t--------------------------------------------------\n")
    end
endfunction
