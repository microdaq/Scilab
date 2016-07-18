function  mdaq_ao_scan_init(arg1, arg2, arg3, arg4, arg5)

    link_id = -1;
    if argn(2) == 4 then
        channels = arg1;
        ao_range = arg2;
        scan_freq = arg3;
        scan_time = arg4;
    end

    if argn(2) == 5 then
        link_id = arg1;
        channels = arg2;
        ao_range = arg3;
        scan_freq = arg4;
        scan_time = arg5;

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    if argn(2) > 5 | argn(2) < 4 then
        mprintf("Description:\n");
        mprintf("\tInit AO scan\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ao_scan_init(link_id, channels, range, frequency, time);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tchannels - analog input channels to read\n");
        mprintf("\trange - analog output range\n");
        mprintf("\t\tAvaliable output ranges: \n");
        mprintf("\t\t  0: 0-5V\n");
        mprintf("\t\t  1: 0-10V\n");
        mprintf("\t\t  2: ±5V\n");
        mprintf("\t\t  3: ±10V\n");
        mprintf("\t\t  4: ±2.5V\n");
        mprintf("\tfrequency - analog input scan frequency\n");
        mprintf("\ttime - analog output scan duration in seconds\n");
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

    if argn(2) == 4 then
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

    result = [];

    result = call("sci_mlink_ao_scan_init",..
            link_id, 1, "i",..
            channels, 2, "i",..
            ao_range, 3, "i",..
            ch_count, 4, "i",..
            scan_freq, 5, "d",..
            scan_time, 6, "d",..
        "out",..
            [1, 1], 7, "i");

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

        mprintf("\tFrequency:\t%dHz\n", scan_freq);
        if scan_time < 0
            mprintf("\tDuration:\tInf\n");
            mprintf("\tScan count:\tInf");
        else
            mprintf("\tDuration:\t%dsec\n", scan_time);
            mprintf("\tScan count:\t%d", scan_time * scan_freq);
        end
    end

    if argn(2) == 4 then
        mdaq_close(link_id);
    end

endfunction
