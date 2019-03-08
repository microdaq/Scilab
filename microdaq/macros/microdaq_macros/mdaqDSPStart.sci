function mdaqDSPStart( arg1)

    if argn(2) == 1 then
        link_id = arg1;
        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    if argn(2) == 0 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("ERROR: Unable to connect to MicroDAQ device!");
        end
    end

    result = call("sci_mlink_dsp_run",..
                    link_id, 1, "i",..
                "out",..
                    [1,1], 2, "i");

    if argn(2) == 0 then
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result));
    end
endfunction
