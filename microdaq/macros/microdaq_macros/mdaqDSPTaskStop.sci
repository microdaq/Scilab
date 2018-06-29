function mdaqDSPTaskStop(arg1)
    // Check version compatibility
    [is_supp vers] = mdaq_is_working('mdaqDSPTaskStop');
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

    result = mlink_dsp_stop(link_id);

    if argn(2) == 0 then
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result));
    end
endfunction
