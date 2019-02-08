function mdaqPWMInit(arg1, arg2, arg3, arg4, arg5, arg6)

    link_id = -1; 

    if argn(2) == 5 then
        module = arg1;  
        period = arg2; 
        active_low = arg3; 
		channel_a = arg4;
		channel_b = arg5;
    end
    
    if argn(2) == 6 then
        link_id = arg1; 
        module = arg2;  
        period = arg3; 
        active_low = arg4; 
		channel_a = arg5;
		channel_b = arg6;
        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    if argn(2) > 6 | argn(2) < 5 | module > 3 | module < 1 | period > 500000 | period < 2 then
        mprintf("Description:\n");
        mprintf("\tSetup MicroDAQ PWM outputs\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqPWMInit(linkID, module, period, activeLow, dutyChannelA, dutyChannelB)\n")
        mprintf("\tlink_id - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tmodule - PWM module (1|2|3)\n");
        mprintf("\tperiod - PWM module period in microseconds(2-500000)\n");
        mprintf("\tactiveLow - PWM waveform polarity (%s or %s)\n", "%T", "%F");
        mprintf("\tdutyChannelA - initial PWM channel A duty (0-100)\n");
        mprintf("\tdutyChannelB - initial PWM channel B duty (0-100)\n");
        return;
    end
    
    if type(active_low) == 4 then
        if active_low == %T then
            active_low = 1; 
        else 
            active_low = 0; 
        end
    else 
        if active_low <> 0 then
            active_low = 1;
        end  
    end
	
    if channel_a > 100 | channel_a < 0 then
        disp("WARNING: Channel A duty out of range (0-100)!");
        if channel_a > 100 then
            channel_a = 100;
        end
        if channel_a < 0 then
            channel_a = 0;
        end
    end

    if channel_b > 100 | channel_b < 0 then
        disp("WARNING: Channel B duty out of range (0-100)!");
        if channel_b > 100 then
            channel_b = 100;
        end
        if channel_b < 0 then
            channel_b = 0;
        end
    end    
    if argn(2) == 5 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end

    result = [];
    result = call("sci_mlink_pwm_config",..
                link_id, 1, "i",..
                module, 2, "i",..
                period, 3, "i",..
                active_low, 4, "i",..
                channel_a, 5, "d",..
                channel_b, 6, "d",..
            "out",..
                [1, 1], 7, "i");

    if argn(2) == 5 then
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end 
endfunction
