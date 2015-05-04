function mdaq_led_write(link_id, led, state)
    if link_id < 0 then
        disp("Wrong link ID!")
        return;
    end
    
    if led > 2 | led < 1 then
        disp("Wrong LED number!")
        return;
    end

    if state <> 0 then
        state = 1;
    end

    result = call("sci_mlink_led_set",..
            link_id, 1, "i",..
            led, 2, "i",..
            state, 3, "i",..
        "out",..
            [1, 1], 4, "i");

    if  result < 0  then
        mdaq_error(result); 
    end
endfunction
