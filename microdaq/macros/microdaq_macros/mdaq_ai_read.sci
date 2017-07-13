function data = mdaq_ai_read(arg1, arg2, arg3, arg4)
    data = [];
    link_id = -1;

    if argn(2) == 3 then
        channels = arg1;
        ai_range = arg2;
        differential = arg3;
    end

    if argn(2) == 4 then
        link_id = arg1;
        channels = arg2;
        ai_range = arg3;
        differential = arg4;
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        adc_info = get_adc_info(%microdaq.private.mdaq_hwid);
        if argn(2) > 4 | argn(2) < 3 then
            mprintf("Description:\n");
            mprintf("\tReads MicroDAQ analog inputs\n");
            mprintf("Usage:\n");
            mprintf("\tmdaq_ai_read(link_id, channels, range, differential);\n")
            mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
            mprintf("\tchannels - analog input channels to read\n");
            mprintf("\trange - analog input range:\n");
            for i = 1:size(adc_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + adc_info.c_params.c_range_desc(i));
            end
            mprintf("\tdifferential - measurement type (%%T - differential, %%F - single-ended)\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ confituration - run mdaq_hwinfo and try again!');
        return;
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
    
    if ai_range > size(adc_info.c_params.c_range_desc, "r") | ai_range < 1 then 
        disp("ERROR: Wrong AI range selected! Use one of these:");
          for i = 1:size(adc_info.c_params.c_range_desc, "r")
                mprintf("\t    %s\n", string(i) + ": " + adc_info.c_params.c_range_desc(i));
          end
        return; 
    end 

    if argn(2) == 3 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
        end
    end
   
    
    bipolar = adc_info.c_params.c_bipolar(ai_range);
    ai_range = adc_info.c_params.c_range(ai_range);

    if differential == %T then
        differential = 29;
    else
        differential = 28;
    end

    result = [];
    [data result] = call("sci_mlink_ai_read",..
                        link_id, 1, "i",..
                        channels, 2, "i",..
                        ch_count, 3, "i",..
                        ai_range, 4, "i",..
                        bipolar, 5, "i",..
                        differential, 6, "i",..
                    "out",..
                        [1, ch_count], 7, "d",..
                        [1, 1], 8, "i");

    if result < 0 then
        mdaq_error(result);
    end

    if argn(2) == 3 then
        mdaq_close(link_id);
    end
endfunction
