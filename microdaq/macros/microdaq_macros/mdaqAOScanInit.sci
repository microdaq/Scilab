function  mdaqAOScanInit(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    global %microdaq;
    
    link_id = -1;
    if argn(2) == 6 then
        channels = arg1;
        data = arg2;
        ao_range = arg3;
        continuous = arg4;
        scan_freq = arg5;
        scan_time = arg6;
    end

    if argn(2) == 7 then
        link_id = arg1;
        channels = arg2;
        data = arg3;
        ao_range = arg4;
        continuous = arg5;
        scan_freq = arg6;
        scan_time = arg7;

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        if  %microdaq.private.mdaq_hwid(3) == 0 then
            disp("ERROR: Unable to detect DAC configuration!");
            return;
        end
        dac_info = %microdaq.private.dac_info;
        if argn(2) > 7 | argn(2) < 6 then
        mprintf("Description:\n");
        mprintf("\Initiates AO scanning session\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqAOScanInit(linkID, channels, initialData, range, isStreamMode, rate, duration\n")
        mprintf("\tlinkID - connection id (optional)\n");
        mprintf("\tchannels - analog output channels to write\n");
        mprintf("\tinitialData - output data\n");
		mprintf("\trange - analog output range matrix e.g.\n");
		mprintf("\t        [-10,10] - single range argument applied for all used channels\n");
		mprintf("\t        [-10,10; -5,5] - multi-range argument for two channels\n");
        mprintf("\tisStreamMode - mode of operation (%%T - stream, %%F - periodic)\n");
        mprintf("\trate - scans per second rate (scan frequency)\n");
        mprintf("\tduration - analog output scan duration in seconds\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ confituration - run mdaqHWInfo and try again!');
        return;
    end
    
    ch_count = size(channels, "c");  
    dac_ch_count = strtod(dac_info.channel);  
    
    if size(channels, 'r') > 1 then
        error("Wrong channel - single row vector expected!")
    end
    
    if ch_count < 1 | ch_count > dac_ch_count then
        error("Wrong AO channel selected!")
    end

    if max(channels) > dac_ch_count | min(channels) < 1 then
        error("Wrong AO channel selected!")
    end
    
    if size(data, "c") <> ch_count then
        error("Wrong output data - colums should match selected channels!")
    end
    
    if size(ao_range, 'c') <> 2 then
        error("Vector range [low,high;low,high;...] expected!")
        return;
    end
    
    if size(ao_range, 'r') == 1 then
        range_tmp = ao_range;
        ao_range = ones(ch_count,2);
        ao_range(:,1) = range_tmp(1);
        ao_range(:,2) = range_tmp(2);
    end
    range_tmp = ao_range;
    ao_range = matrix(ao_range', 1, ch_count*2);
    
    data_size = size(data, "*"); 
    
    if type(continuous) == 1 then
        if size(find(continuous>1), '*') > 0
            error('Wrong isContinuous - boolean value expected (%T/1, %F/0)');
        end 
    end
    
    if continuous == %T | continuous == 1 then
        continuous = 1;
    else
        continuous = 0;
    end
    
    if scan_time < 0 & scan_time <> -1 then
        mprintf("WARNING: For infinite scan session as a duration parameter use -1 value instead!\n"); 
        scan_time = -1;
    end
    
    %microdaq.private.ao_scan_ch_count = ch_count;

    if argn(2) == 6 then
        link_id = mdaqOpen();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end

    result = [];

    result = call("sci_mlink_ao_scan_init",..
                link_id, 1, "i",..
                channels, 2, "i",..
                ch_count, 3, "i",..
                data, 4, "d",..
                data_size, 5, "i",..
                ao_range, 6, "d",..
                continuous, 7, "i", ..
                scan_freq, 8, "d",..
                scan_time, 9, "d",..
            "out",..
                [1, 1], 10, "i");

    if argn(2) == 6 then
        mdaqClose(link_id);
    end
    
    if result < 0 then
        error(mdaq_error2(result), 10000 + abs(result)); 
    else
        if result == 1 then
            mprintf("\nWARNING: Your MicroDAQ device does not allow running AI and AO scanning session simultaneously.\n")
        end
        
        rows = [];
        row = '';
        adc_res = strtod(part(adc_info.resolution, 1:2))
        for j=1:ch_count
            dac_range = range_tmp(j, 2) - range_tmp(j, 1); 
            resolution = string((int(dac_range/2^adc_res * 1000000)) / 1000);
            rangeStr="";
            if range_tmp(j, 1) < 0 then
                rangeStr = "±" + string(range_tmp(j, 2))+"V";
            else 
                rangeStr = "0-" + string(range_tmp(j, 2))+"V";
            end
            rows = [rows; "AO"+string(channels(j)), rangeStr, resolution+"mV"]
        end
        
        mprintf("\nAnalog output scanning session settings:\n");
        mprintf("\t--------------------------------------------------\n")
        str2table(rows, ["Channel",  "Range", "Resolution"], 12)
        mprintf("\t--------------------------------------------------\n")

        if scan_freq >= 1000
            mprintf("\tScan frequency:\t\t%.5f kHz\n", scan_freq/1000);
        else
            mprintf("\tScan frequency:\t\t%d Hz\n", scan_freq);
        end
        if 1 /scan_freq > 0.001 then
            mprintf("\tScan period: \t\t%.5f seconds\n", 1 / scan_freq);
        end
        
        if 1 /scan_freq <= 0.001 then
            mprintf("\tScan period: \t\t%.5f ms\n", 1 / scan_freq * 1000);
        end
        if continuous == 1 then
            mprintf("\tMode:\t\t\tStream\n"); 
        else
            mprintf("\tMode:\t\t\tPeriodic\n"); 
        end

        mprintf("\tQueue data size: \t%sx%s\n", string(size(data,"c")), string(size(data,"r")))
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

