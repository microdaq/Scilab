function mdaq_dio_dir(link_id, bank, direction)
    if bank < 1 | bank > 4 then
        disp("ERROR: Wrong bank number!")
        return;
    end

    if direction <> 0 then
        direction = 1;
    end

    result = call("sci_mlink_dio_set_dir",..
            link_id, 1, "i",..
            bank, 2, "i",..
            direction, 3, "i",..
            0, 4, "i",..
        "out",..
            [1, 1], 5, "i");

    if result < 0 then
        mdaq_error(result);
    end
endfunction
