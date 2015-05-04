function [position, direction] = mdaq_enc_read(link_id, module)
    position = [];
    direction = [];
    if link_id < 0 then
        disp("Wrong link ID!")
        return;
    end

    if module > 2 | module < 1 then
        disp("ERROR: Wrong encoder module!")
        return;
    end
    
    result = [];
    [position direction result] = call("sci_mlink_enc_get",..
                link_id, 1, "i",..
                module, 2, "i",..
            "out",..
                [1, 1], 3, "i",..
                [1, 1], 4, "i",..
                [1, 1], 5, "i");
    if result < 0  then
        mdaq_error(result)
    end    
    
endfunction
