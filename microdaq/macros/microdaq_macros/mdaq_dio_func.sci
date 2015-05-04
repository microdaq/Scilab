function mdaq_dio_func(link_id, func, enable)
    if func == 0 then
        return;
    end

    if func > 6  then
        disp("Wrong function number selected!")
        return;
    end

    if enable <> 0 then
        enable = 1;
    end

    result = call("sci_mlink_dio_set_func",..
            link_id, 1, "i",..
            func, 2, "i",..
            enable, 3, "i",..
        "out",..
            [1, 1], 4, "i");

    if result < 0 then
        mdaq_error(result);
    end
endfunction
