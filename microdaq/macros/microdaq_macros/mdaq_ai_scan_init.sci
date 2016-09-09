function  mdaq_ai_scan_init(arg1, arg2, arg3, arg4, arg5, arg6, arg7)

    link_id = -1;

    if argn(2) == 6 then
        channels = arg1;
        ai_range = arg2;
        bipolar = arg3;
        adc_mode = arg4;
        scan_freq = arg5;
        scan_time = arg6;
    end

    if argn(2) == 7 then
        link_id = arg1;
        channels = arg2;
        ai_range = arg3;
        bipolar = arg4;
        adc_mode = arg5;
        scan_freq = arg6;
        scan_time = arg7;

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 7 | argn(2) < 6 then
        mprintf("Description:\n");
        mprintf("\tInit AI scan\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ai_scan_init(link_id, channels, range, bipolar, differential, frequency, time);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tchannels - analog input channels to read\n");
        mprintf("\trange - analog input range (5 or 10)\n");
        mprintf("\tbipolar - analog input polarity (%%T - bipolar, %%F - unipolar)\n");
        mprintf("\tdifferential - analog input mode (%%T - differential, %%F - single-ended)\n");
        mprintf("\tfrequency - analog input scan frequency\n");
        mprintf("\ttime - analog input scan duration in seconds\n");
        return;
    end

    if scan_time < 0 then
        scan_time = -1;
    end

    ch_count = max(size(channels));
    if ch_count < 1 | ch_count > 16 then
        disp("ERROR: Wrong AI channel selected!")
        return;
    end

    if max(channels) > 16 then
        disp("ERROR: Wrong AI channel selected!")
        return;
    end

    s = size(channels);    
    if s(1) > 1 then
        disp("ERROR: Wrong AI channel input parameter!")
    end

    if argn(2) == 6 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end

    if bipolar == %T then
        bipolar = 0;
    else
        bipolar = 1;
    end

    if ai_range <> 5 then
        ai_range = 10;
    end

    if adc_mode == %T then
        adc_mode = 1;
    else
        adc_mode = 0;
    end
    result = [];

    result = call("sci_mlink_ai_scan_init",..
            link_id, 1, "i",..
            channels, 2, "i",..
            ch_count, 3, "i",..
            ai_range, 4, "i",..
            bipolar, 5, "i",..
            adc_mode, 6, "i",..
            scan_freq, 7, "d",..
            scan_time, 8, "d",..
        "out",..
            [1, 1], 9, "i");

    if result < 0 then
        mdaq_error(result);
    else
        global %microdaq;
        mdaq_model = %microdaq.private.mdaq_hwid(1);
        mdaq_ai = %microdaq.private.mdaq_hwid(2);
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
        if adc_mode == 0 then
            mprintf("Single Ended\n");
        else
            mprintf("Differential\n");
        end

        mprintf("\tRange:\t\t");
        if bipolar == 0 then
            mprintf("-%d to +%d Volts\n", ai_range, ai_range);
        else
            mprintf("0 to +%d Volts\n", ai_range);
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
