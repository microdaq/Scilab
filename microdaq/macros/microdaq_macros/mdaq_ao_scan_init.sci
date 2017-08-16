function  mdaq_ao_scan_init(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
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
        if argn(2) > 6 | argn(2) < 5 then
        mprintf("Description:\n");
        mprintf("\Initiates AO scan\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ao_scan_init(link_id, channels, data, range, continuous, frequency, duration);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tchannels - analog output channels to write\n");
        mprintf("\tdata - initialization data\n");
        mprintf("\trange - analog output range\n");
            for i = 1:size(dac_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + dac_info.c_params.c_range_desc(i));
            end
           
        mprintf("\tcontinuous - scanning mode (%%T/%%F)\n");
        mprintf("\tfrequency - analog output scan frequency\n");
        mprintf("\tduration - analog output scan duration in seconds\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ confituration - run mdaq_hwinfo and try again!');
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
    
    dac_ch_count = strtod(dac_info.channel);
    data_size = size(data, "*"); 
    
    ch_count = max(size(channels));
    if ch_count < 1 | ch_count > dac_ch_count then
        disp("ERROR: Wrong AO channel selected!")
        return;
    end

    if max(channels) > dac_ch_count | min(channels) < 1 then
        disp("ERROR: Wrong AO channel selected!")
        return;
    end

    ao_range_desc_index = ao_range;
    try
        ao_range = dac_info.c_params.c_range(ao_range);
    catch
        error("ERROR: wrong AO range selected!");
    end

    if size(ao_range, "*") == 1 then
        tmp = ones(1, ch_count);
        ao_range = tmp * ao_range; 
    else 
        //if size(ao_range, "*") <> ch_count then
            disp("ERROR: Wrong AO range selected!"); 
            return; 
       // end
    end

    if ao_range > 4 | ao_range < 0 then
        disp("ERROR: Wrong AO output range!")
        return;
    end
    
    if continuous == %T | continuous == 1 then
        continuous = 1;
    else
        continuous = 0;
    end
    
    %microdaq.private.ao_scan_ch_count = ch_count;

    if argn(2) == 6 then
        link_id = mdaq_open();
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
            ao_range, 6, "i",..
            continuous, 7, "i", ..
            scan_freq, 8, "d",..
            scan_time, 9, "d",..
        "out",..
            [1, 1], 10, "i");

    if argn(2) == 6 then
        mdaq_close(link_id);
    end
    
    if result < 0 then
        error(mdaq_error2(result), 10000 + abs(result)); 
    else
        if result == 1 then
            mprintf("\nWARNING: Your MicroDAQ device does not allow running AI and AO scanning session simultaneously.\n")
        end
        
        mprintf("\nData acquisition session settings:\n");

        range_table = [ "0-5V" "0-10V" "±5V" "±10V" "±2.5V" ];
        str = "";
        s = size(channels);
        for j=1:s(2)
            if j > 1
              str = str + ", ";
            end
            str = str + string(channels(1,j)) + "(" + dac_info.c_params.c_range_desc(ao_range_desc_index) +")";
        end 
        mprintf("\tChannles:\t%s\n", str);
        
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
            mprintf("\tScan count:\t%d", scan_time * scan_freq);
        end
    end
endfunction

