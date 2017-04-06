function  mdaq_ao_scan_init(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    global %microdaq;
    
    link_id = -1;
    if argn(2) == 6 then
        channels = arg1;
        ao_range = arg2;
        continuous = arg3;
        ao_trigger = arg4; 
        scan_freq = arg5;
        scan_time = arg6;
    end

    if argn(2) == 7 then
        link_id = arg1;
        channels = arg2;
        ao_range = arg3;
        continuous = arg4;
        ao_trigger = arg5;
        scan_freq = arg6;
        scan_time = arg7;

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    if argn(2) > 6 | argn(2) < 5 then
        mprintf("Description:\n");
        mprintf("\tInit AO scan\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ao_scan_init(link_id, channels, range, continuous, trigger, frequency, duration);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tchannels - analog output channels to write\n");
        mprintf("\trange - analog output range\n");
        mprintf("\tcontinuous - scaning mode (0-single, 1-continuous)\n");
        mprintf("\t\tAvaliable output ranges: \n");
        mprintf("\t\t  0: 0-5V\n");
        mprintf("\t\t  1: 0-10V\n");
        mprintf("\t\t  2: ±5V\n");
        mprintf("\t\t  3: ±10V\n");
        mprintf("\t\t  4: ±2.5V\n");
        mprintf("\ttrigger - DIO number (DIO1-8), high state triggers scanning\n"); 
        mprintf("\tfrequency - analog input scan frequency\n");
        mprintf("\tduration - analog output scan duration in seconds\n");
        return;
    end

    if scan_time < 0 then
        scan_time = -1;
    end

    ch_count = max(size(channels));
    if ch_count < 1 | ch_count > 16 then
        disp("ERROR: Wrong AO channel selected!")
        return;
    end

    if size(ao_range, "*") == 1 then
        tmp = ones(1, ch_count);
        ao_range = tmp * ao_range; 
    else 
        if size(ao_range, "*") <> ch_count then
            disp("ERROR: Wrong AO range selected!"); 
            return; 
        end
    end
    
    if max(channels) > 16 then
        disp("ERROR: Wrong AO channel selected!")
        return;
    end

    s = size(channels);    
    if s(1) > 1 then
        disp("ERROR: Wrong AO channel input parameter!")
        return 
    end

    if argn(2) == 6 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end

    if ao_range > 4 | ao_range < 0 then
        disp("ERROR: Wrong AO output range!")
        return;
    end
    if ao_trigger == [] | ao_trigger > 8 then
        ao_trigger = 0; 
    end
    
    %microdaq.private.ao_scan_ch_count = ch_count;
        
    result = [];
    
//MDAQ_API void  sci_mlink_ao_scan_init(
//		IO		int 		*link_fd, 
//		IN		int		 	*ch,
//		IN		int 		*ch_count,
//		IN		int		 	*range,
//		IN		int		    *continuous,
//		IN		int			*trigger, 
//		IN		double 		*freq,
//		IN		double 		*scan_time, 
//		OUT		int			*result)
       
    result = call("sci_mlink_ao_scan_init",..
            link_id, 1, "i",..
            channels, 2, "i",..
            ch_count, 3, "i",..
            ao_range, 4, "i",..
            continuous, 5, "i", ..
            ao_trigger,6, "i",..
            scan_freq, 7, "d",..
            scan_time, 8, "d",..
        "out",..
            [1, 1], 9, "i");
            
    mprintf("result: %d\n", result);

    if result < 0 then
        mdaq_error(result);
    else
        mprintf("Data acquisition session settings:\n");

        range_table = [ "0-5V" "0-10V" "±5V" "±10V" "±2.5V" ];
        str = [];
        s = size(channels);
        for j=1:s(2)
            if j > 1
              str = str + ", ";
            end
            str = str + string(channels(1,j)) + "(" +range_table(ao_range(j)+1) +")";
        end 
        mprintf("\tChannles:\t%s\n", str);

        if ao_trigger == 0 then
            mprintf("\tTrigger:\tNONE\n"); 
        else
            mprintf("\tTrigger:\tDIO%d\n", ao_trigger); 
        end
        
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

    if argn(2) == 6 then
        mdaq_close(link_id);
    end
endfunction
