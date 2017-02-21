function  mdaq_ai_scan_init2(arg1, arg2, arg3, arg4, arg5, arg6)
    link_id = -1;

    if argn(2) == 5 then
        channels = arg1;
        ai_range = arg2;
        differential = arg3;
        scan_freq = arg4;
        scan_time = arg5;
    end

    if argn(2) == 6 then
        link_id = arg1;
        channels = arg2;
        ai_range = arg3;
        differential = arg4;
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
            mprintf("\tmdaq_ai_scan_init(link_id, channels, range, differential, frequency, time);\n");               mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
            mprintf("\tchannels - analog input channels to read\n");
            mprintf("\trange - analog input range:\n");
            for i = 1:size(adc_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + adc_info.c_params.c_range_desc(i));
            end
            
            if adc_info.c_params.c_diff(1) == 1 then
                mprintf("\tdifferential - measurement type (%%T - differential, %%F - single-ended)\n");
            else
                mprintf("\tdifferential - set %%F (differential mode not supported by AI converter)\n");
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
    if differential then
        adc_ch_count = adc_ch_count / 2;
    end
            
    ch_count = max(size(channels));
    if ch_count < 1 | ch_count > adc_ch_count then
        disp("ERROR: Wrong AI channel selected!")
        return;
    end

    if max(channels) > adc_ch_count | min(channels) < 1 then
        disp("ERROR: Wrong AI channel selected!")
        return;
    end

    try
        bipolar = adc_info.c_params.c_bipolar(ai_range);
        ai_range_desc = adc_info.c_params.c_range_desc(ai_range);
        ai_range = adc_info.c_params.c_range(ai_range);
    catch
        error("Error: wrong AI range selected!");
    end
    
    if differential == %F | differential == 0 then
        differential = 28;
    else
        differential = 29;
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
            ai_range, 4, "i",..
            bipolar, 5, "i",..
            differential, 6, "i",..
            scan_freq, 7, "d",..
            scan_time, 8, "d",..
        "out",..
            [1, 1], 9, "i");

    disp("result: "); 
    disp(result);
    if result < 0 & result <> -88 then
            error(mdaq_error(result), 10000 + abs(result))            
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
                    ai_range, 4, "i",..
                    bipolar, 5, "i",..
                    differential, 6, "i",..
                    scan_freq, 7, "d",..
                    scan_time, 8, "d",..
                "out",..
                    [1, 1], 9, "i");
        end
        
        mprintf("Data acquisition session settings:\n");

        str = [];
        s = size(channels);
        for j=1:s(2)
            if j > 1
              str = str + ", ";
            end
            str = str + string(channels(1,j));
        end 
        mprintf("\tChannles:\t%s\n", str);

        mprintf("\tInput Type:\t");
        if differential == 29 then
            mprintf("Differential\n");
        else
            mprintf("Single Ended\n"); 
        end

        mprintf("\tRange:\t\t");
        mprintf("%s\n", ai_range_desc);

        if scan_freq >= 1000
            mprintf("\tFrequency:\t%.3fkHz\n", scan_freq/1000);
        else
            mprintf("\tFrequency:\t%dHz\n", scan_freq);
        end
        
        if scan_time < 0
            mprintf("\tDuration:\tInf\n");
            mprintf("\tScan count:\tInf");
        else
            mprintf("\tDuration:\t%.2fsec\n", scan_time);
            mprintf("\tScan count:\t%d\n", scan_time * scan_freq);
        end
    end

    if argn(2) == 5 then
        mdaq_close(link_id);
    end

endfunction
