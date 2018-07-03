function mdaqDSPStart( arg1)
    // Check version compatibility
    [is_supp vers] = mdaq_is_working('mdaqDSPTaskStart');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end

    if argn(2) == 1 then
        link_id = arg1;
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) == 0 then
        link_id = mdaqOpen();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return;
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
