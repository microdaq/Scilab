function mdaq_enc_init(link_id, module, init_value)
    if link_id < 0 then
        disp("Wrong link ID!")
        return;
    end

    if module > 2 | module < 1 then
        disp("Wrong Encoder module!")
        return;
    end
    
    result = [];
    result = call("sci_mlink_enc_reset",..
                link_id, 1, "i",..
                module, 2, "i",..
                init_value, 3, "i",..
            "out",..
                [1, 1], 4, "i");

    if result < 0  then
        mdaq_error(result)
    end
endfunction
