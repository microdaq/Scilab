function data = mdaq_hs_ai_read(link_id, sample_count, trig_duration, acq_delay)
    if link_id < 0 then
        disp("Wrong link ID!")
        data = [];
        return;
    end

    result = [];
    [data result] = call("sci_mlink_hs_ai_read",..
            link_id, 1, "i",..
            sample_count, 2, "i",..
            acq_delay, 3, "i",..
            trig_duration, 4, "i",..
        "out",..
            [sample_count*2, 1], 5, "d",.. 
            [1, 1], 6, "i");
            
    data = matrix (data, 2, sample_count)';
    
    if result < 0  then
        mdaq_error(result)
    end
endfunction
