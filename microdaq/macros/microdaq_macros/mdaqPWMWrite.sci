function mdaqPWMWrite(arg1, arg2, arg3, arg4)
    link_id = -1; 

    if argn(2) == 3 then
        module = arg1;  
        channel_a = arg2; 
        channel_b = arg3; 
    end
    
    if argn(2) == 4 then
        link_id = arg1; 
        module = arg2;  
        channel_a = arg3; 
        channel_b = arg4; 

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end
    
    if argn(2) > 4 | argn(2) < 3 | module > 3 | module < 1 then
        mprintf("Description:\n");
        mprintf("\tWrites PWM duty\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqPWMWrite(linkID, module, dutyChannelA, dutyChannelB)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tmodule - PWM module (1|2|3)\n");
        mprintf("\tdutyChannelA - PWM channel A duty (0-100)\n");
        mprintf("\tdutyChannelB - PWM channel B duty (0-100)\n");
        return;
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
    
    if argn(2) == 3 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end

    result = [];
    result = call("sci_mlink_pwm_set",..
                link_id, 1, "i",..
                module, 2, "i",..
                channel_a, 3, "d",..
                channel_b, 4, "d",..
            "out",..
                [1, 1], 5, "i");

    if argn(2) == 3 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end 
endfunction
