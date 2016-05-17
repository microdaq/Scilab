function data = mdaq_ai_read(arg1, arg2, arg3, arg4, arg5)
    data = [];
    link_id = -1; 

    if argn(2) == 4 then
        channels = arg1;  
        ai_range = arg2; 
        bipolar = arg3; 
        differential = arg4;
    end
    
    if argn(2) == 5 then
        link_id = arg1; 
        channels = arg2;  
        ai_range = arg3; 
        bipolar = arg4; 
        differential = arg5;
        
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    if argn(2) > 5 | argn(2) < 4 then
        mprintf("Description:\n");
        mprintf("\tReads MicroDAQ analog inputs\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_ai_read(link_id, channels, range, bipolar, differential);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tchannels - analog input channels to read\n");
        mprintf("\trange - analog input range (5 or 10)\n");
        mprintf("\tbipolar - analog input polarity (%%T - bipolar, %%F - unipolar)\n");
        mprintf("\tdifferential - analog input mode (%%T - differential, %%F - single ended)\n");
        return;
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
    
    if argn(2) == 4 then
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

    if differential == %T then
        differential = 1; 
    else
        differential = 0; 
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
    
    if argn(2) == 4 then
        mdaq_close(link_id);
    end
endfunction
