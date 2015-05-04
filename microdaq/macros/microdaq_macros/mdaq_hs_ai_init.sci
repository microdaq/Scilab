function mdaq_hs_ai_init(link_id)
    if link_id < 0 then
        disp("Wrong link ID!")
        return;
    end

    result = call("sci_mlink_hs_ai_init",..
            link_id, 1, "i",..
        "out",..
            [1, 1], 2, "i");
            
    if result < 0  then
        mdaq_error(result)
    end
endfunction
