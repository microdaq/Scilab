function result = mdaqAIScanInit(arg1, arg2, arg3, arg4, arg5, arg6)
    link_id = -1;
    result = [];
    channelNames = [];
    if argn(2) == 1 then
        channels = arg1.Channels;
        aiRange = arg1.Range;
        aiMode = arg1._Mode;
        scan_freq = arg1.Rate;
        scan_time = arg1.DurationInSeconds;
        channelNames = arg1.Name
    elseif  argn(2) == 2 then
        channels = arg2.Channels;
        aiRange = arg2.Range;
        aiMode = arg2._Mode;
        scan_freq = arg2.Rate;
        scan_time = arg2.DurationInSeconds;
        channelNames = arg1.Name
    elseif argn(2) == 5 then
        channels = arg1;
        aiRange = arg2;
        aiMode = arg3;
        scan_freq = arg4;
        scan_time = arg5;
    elseif argn(2) == 6 then
        link_id = arg1;
        channels = arg2;
        aiRange = arg3;
        aiMode = arg4;
        scan_freq = arg5;
        scan_time = arg6;
        if link_id < 0 then
            error("Invalid connection id!")
        end        
    end

    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        adc_info = get_adc_info(%microdaq.private.mdaq_hwid);
        if find([1 2 5 6] == argn(2)) == [] then
            mprintf("Description:\n");
            mprintf("\tConfigures analog inputs data acquisition session\n");
            mprintf("Usage:\n");
            mprintf("\tmdaqAIScanInit(linkID, channels, range, isDifferential, rate, duration)\n");
			mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
            mprintf("\tchannels - analog input channels to read\n");
            mprintf("\trange - analog input range\n");
            mprintf("\t        [-10,10] - single range argument applied for all selected channels\n");
            mprintf("\t        [-10,10; -5,5] - multi-range argument for two channels\n");
			mprintf("\tisDifferential - scalar or vector with terminal configuration: %s - differential, %s - single-ended mode\n", "%T", "%F");
            mprintf("\trate - read per second rate for selected channels\n");
            mprintf("\tduration - duration in seconds (-1 - infinity)\n");
            return;
        end
    else
        error('Can''t detect MicroDAQ configuration. Run mdaqHWInfo() function.');
    end
    
    ch_count = size(channels, 'c');
    
    if scan_time < 0 then
        scan_time = -1;
    end

    if size(channels, 'r') > 1 then
        error('Wrong channel - scalar or single row vector expected')
    end

    if size(aiRange, 'c') <> 2 then
        error('Wrong range argument - matrix with low and high range [low,high;low,high;...] expected')
    end

    aiRangeSize = size(aiRange, 'r');
    if aiRangeSize <> 1 & aiRangeSize <> ch_count then
        error('Range vector should match selected AI channels')
    end
    
    if type(aiMode) == 1 then
        if size(find(aiMode>1), '*') > 0
            error('Wrong mode (isDifferential parameter) - boolean value expected (%T/1, %F/0)')
        end 
    end
    
    if size(aiMode, 'r') > 1 then
        error('Wrong mode (isDifferential parameter) - scalar or single row vector expected')
    end
    
    aiModeSize = size(aiMode, 'c');
    if aiModeSize <> 1 & aiModeSize <> ch_count then
        error('Mode (isDifferential parameter) vector should match selected AI channels')
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

    if argn(2) == 5 | argn(2) == 1 then
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
            warning("AI scan interrupted!")
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

        if argn(2) == 5 | argn(2) == 1 then
            mdaqClose(link_id);
        end

        if result < 0 then
            error(mdaq_error2(result), 10000 + abs(result));
        end
        if scan_time < 0 then
            isContinous = %t
        else
            isContinous = %f
        end

        adc_res = strtod(part(adc_info.resolution, 1:2)); 
        result = tlist(["mdaqai",..
            "Rate","_RealRate","DurationInSeconds","_ChannelCount","_ADCResolution","_Mode","Range", "Channels", "isContinous", "Name"],..
             scan_freq,  real_freq,  scan_time,  ch_count,  adc_res,  aiMode,  aiRange_t, channels, isContinous, channelNames);
    end
endfunction
