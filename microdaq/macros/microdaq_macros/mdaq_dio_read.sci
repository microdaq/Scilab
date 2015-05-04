function state = mdaq_dio_read(link_id, dio)

    if argn(2) <> 2 then
        disp("ERROR: Wrong input arguments!");
        return;
    end

    if link_id < 0 then
        disp("ERROR: Wrong link ID!")
        return;
    end

    if dio > 32 | dio < 1 then
        disp("ERROR: Wrong DIO number!")
        return;
    end

    result = [];
    [state result] = call("sci_mlink_dio_get",..
            link_id, 1, "i",..
            dio, 2, "i",..
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
