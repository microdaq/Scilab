function mdaq_pru_set(link_id, pru_core, pru_reg, value)
    if link_id < 0 then
        disp("Wrong link ID!")
        return;
    end

    if pru_core > 1 | pru_core < 0 then
        disp("Wrong PRU core!")
        return;
    end

    if pru_reg > 15 | pru_reg < 0 then
        disp("Wrong PRU core!")
        return;
    end
    
    result = [];
    result = call("sci_mlink_pru_reg_set",..
                link_id, 1, "i",..
                pru_core, 2, "i",..
                pru_reg, 3, "i",..
                value, 4, "i",..
            "out",..
                [1, 1], 5, "i");

    if result < 0  then
        mdaq_error(result)
    end
endfunction
