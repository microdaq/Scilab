function data = mdaq_ai_read(link_id, channels, ai_range, bipolar)
    data = [];
    
    if argn(2) <> 4 then
        disp("ERROR: Wrong input arguments!");
        return;
    end
    
    if link_id < 0 then
        disp("ERROR: Wrong link ID!")
        return;
    end

    ch_count = max(size(channels));
    if ch_count < 1 | ch_count > 8 then
        disp("ERROR: Wrong AI channel setup!")
        return; 
    end
    
    if max(channels) > 8 then
        disp("ERROR: Wrong AI channel setup!")
        return; 
    end
    
    result = [];
    [data result] = call("sci_mlink_ai_read",..
            link_id, 1, "i",..
            channels, 2, "i",..
            ch_count, 3, "i",..
            ai_range, 4, "i",..
            bipolar, 5, "i",..
        "out",..
            [1, ch_count], 6, "d",.. 
            [1, 1], 7, "i");

    if result < 0 then
        mdaq_error(result);
    end
endfunction
