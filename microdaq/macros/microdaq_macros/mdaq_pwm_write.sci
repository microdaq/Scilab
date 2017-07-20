function mdaq_pwm_write(arg1, arg2, arg3, arg4)
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
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    if argn(2) > 4 | argn(2) < 3 | module > 3 | module < 1 then
        mprintf("Description:\n");
        mprintf("\tSets MicroDAQ PWM outputs\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_pwm_write(link_id, module, duty_a, duty_b);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tmodule - PWM module (1, 2 or 3)\n");
        mprintf("\tduty_a - PWM channel A duty (0-100)\n");
        mprintf("\tduty_b - PWM channel B duty (0-100)\n");
        return;
    end

    if channel_a > 100 | channel_a < 0 then
        disp("WARNING: Channel A duty outside the limit (0-100)!");
        if channel_a > 100 then
            channel_a = 100;
        end
        if channel_a < 0 then
            channel_a = 0;
        end
    end

    if channel_b > 100 | channel_b < 0 then
        disp("WARNING: Channel B duty outside the limit (0-100)!");
        if channel_b > 100 then
            channel_b = 100;
        end
        if channel_b < 0 then
            channel_b = 0;
        end
    end
    
    if argn(2) == 3 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
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
        mdaq_close(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end 
endfunction
