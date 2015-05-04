function state = mdaq_key_read(link_id, func_key)
    if link_id < 0 then
        disp("Wrong link ID!")
        return;
    end
    
    if func_key > 2 | func_key < 1 then
        disp("Wrong function key number!")
        return;
    end

    result = [];
    [state result] = call("sci_mlink_func_key_get",..
            link_id, 1, "i",..
            func_key, 2, "i",..
        "out",..
            [1, 1], 3, "i",..
            [1, 1], 4, "i");
            
    if state <> 0 then
        state = 1;
    end

    if result < 0  then
        mdaq_error(result)
    end
endfunction
