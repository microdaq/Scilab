function mdaq_pwm_init(link_id, module, period, active_low, channel_a, channel_b)
    if link_id < 0 then
        disp("Wrong link ID!")
        return;
    end

    if module > 3 | module < 1 then
        disp("Wrong PWM module!")
        return;
    end

    if period > 1000000 | period < 1 then
        disp("Wrong PWM period!")
        return;
    end

    if active_low > 1 | active_low < 0 then
        disp("WARNING: active_low parameter should be 0 or 1. Value will be modified to 1!")
    end

    if channel_a > 100 | channel_a < 0 then
        if channel_a > 100 then
            disp("WARNING: channel_a value will be modified to 100!")
            channel_a = 100;
        end
        if channel_a < 0 then
            disp("WARNING: channel_a value will be modified to 0!")
            channel_a = 0;
        end
    end

    if channel_b > 100 | channel_b < 0 then
        if channel_b > 100 then
            disp("WARNING: channel_b value will be modified to 100!")
            channel_b = 100;
        end
        if channel_b < 0 then
            disp("WARNING: channel_b value will be modified to 0!")
            channel_b = 0;
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

    if result < 0  then
        mdaq_error(result)
    end

endfunction
