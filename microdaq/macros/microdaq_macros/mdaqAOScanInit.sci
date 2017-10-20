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
        mprintf("\tmdaqAOScanInit(linkId, channels, data, range, isContinuous, scanFrequency, duration);\n")
        mprintf("\tlinkId - connection id (optional)\n");
        mprintf("\tchannels - analog output channels to write\n");
        mprintf("\tdata - output data\n");
        mprintf("\trange - analog output range\n");
            for i = 1:size(dac_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + dac_info.c_params.c_range_desc(i));
            end
           
        mprintf("\tisContinuous - mode of operation (%%T - continuous, %%F - periodic)\n");
        mprintf("\tscanFrequency - analog output scan frequency\n");
        mprintf("\tduration - analog output scan duration in seconds\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ confituration - run mdaqHWInfo and try again!');
        return;
    end
    
    if continuous == %T then
        continuous = 1;
    else 
        continuous = 0; 
    end

    if scan_time < 0 & scan_time <> -1 then
        mprintf("WARNING: For infinite scan session as a duration parameter use -1 value instead!\n"); 
        scan_time = -1;
    end
    
    if size(channels, 'r') > 1 then
        error("Wrong channel - single row vector expected!")
    end
    
    if size(ao_range, 'c') <> 2 then
        error("Vector range [low,high;low,high;...] expected!")
        return;
    end
    
    ch_count = size(channels, "c");    
    
    if size(ao_range, 'r') == 1 then
        range_tmp = ao_range;
        ao_range = ones(ch_count,2);
        ao_range(:,1) = range_tmp(1);
        ao_range(:,2) = range_tmp(2);
    end
    ao_range = matrix(ao_range', 1, ch_count*2);
    dac_ch_count = strtod(dac_info.channel);
    
    if size(data, "c") <> ch_count then
        error("Wrong output data - colums should match selected channels!")
    end
    
    data_size = size(data, "*"); 

    if ch_count < 1 | ch_count > dac_ch_count then
        error("Wrong AO channel selected!")
    end

    if max(channels) > dac_ch_count | min(channels) < 1 then
        error("Wrong AO channel selected!")
    end
    
    if continuous == %T | continuous == 1 then
        continuous = 1;
    else
        continuous = 0;
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
// TODO: print info table with RANGES 
//        dac_res = strtod(part(dac_info.resolution, 1:2))
//        for j=1:ch_count
//            //dac_range = diff(dac_info.c_params.c_range_value(ao_range_t(j),:))
//            resolution = string((int(0/2^dac_res * 1000000)) / 1000);
//            rows = [rows; string(channels(j)), 0, resolution+"mV"]
//        end

        mprintf("\nAnalog output scanning session settings:\n");
        mprintf("\t---------------------------------\n")
        //str2table(rows, ["Channel",  "Range", "Resolution"], 5)
        mprintf("\t---------------------------------\n")

        if scan_freq >= 1000
            mprintf("\tScan frequency:\t\t%.3fkHz\n", scan_freq/1000);
        else
            mprintf("\tScan frequency:\t\t%dHz\n", scan_freq);
        end
        
        if continuous == 1 then
            mprintf("\tMode:\t\t\tStream\n"); 
        else
            mprintf("\tMode:\t\t\tPeriodic\n"); 
        end

        mprintf("\tOudput data size: \t%sx%s\n", string(size(data,"c")), string(size(data,"r")))
        if scan_time < 0
            mprintf("\tDuration:\t\tInf\n");
            mprintf("\tNumber of scans:\tInf\n");
            mprintf("\tNumber of channels:\t%d\n", ch_count)
        else
            mprintf("\tDuration:\t\t%.2fs\n", scan_time);
            mprintf("\tNumber of scans:\t%d\n", scan_time * scan_freq);
            mprintf("\tNumber of channels:\t%d\n", ch_count)
        end
        mprintf("\t---------------------------------\n")

    end
endfunction
