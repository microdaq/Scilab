function mdaq_dio_write(link_id, dio, state)
    if link_id < 0 then
        disp("ERROR: Wrong link ID!")
        return;
    end
    
    if dio > 32 | dio < 1 then
        disp("ERROR: Wrong DIO number!")
        return;
    end

    if state <> 0 then
        state = 1;
    end
    
    result = call("sci_mlink_dio_set",..
            link_id, 1, "i",..
            dio, 2, "i",..
            state, 3, "i",..
        "out",..
            [1, 1], 4, "i");

    if  result < 0  then
        mdaq_error(result); 
    end
endfunction
