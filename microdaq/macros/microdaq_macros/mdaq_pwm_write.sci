function mdaq_pwm_write(link_id, module, channel_a, channel_b)
    if link_id < 0 then
        disp("Wrong link ID!")
        return;
    end

    if module > 3 | module < 1 then
        disp("Wrong PWM module!")
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

    result = [];
    result = call("sci_mlink_pwm_set",..
                link_id, 1, "i",..
                module, 2, "i",..
                channel_a, 3, "d",..
                channel_b, 4, "d",..
            "out",..
                [1, 1], 5, "i");

    if result < 0  then
        mdaq_error(result)
    end

endfunction
