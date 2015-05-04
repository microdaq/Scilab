function mdaq_ao_write(link_id, dac, channels, data)
    if link_id < 0 then
        disp("Wrong link ID!")
        return;
    end

    if  dac > 3 then
        disp("ERROR: Unsuported DAC!");
        return;
    end
    
    ch_count = max(size(channels));
    if ch_count < 1 | ch_count > 8 then
        disp("Wrong AO channel setup!")
        return; 
    end

    result = [];
    result = call("sci_mlink_ao_write",..
            link_id, 1, "i",..
            dac, 2, "i",..
            channels, 3, "i",..
            ch_count, 4, "i",..
            data, 5, "d",..
        "out",..
            [1, 1], 6, "i");

    if result < 0 then
        mdaq_error(result);
    end
endfunction
