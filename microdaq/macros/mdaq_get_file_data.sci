function result = mdaq_get_file_data( filename )
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaq_get_file_data');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    
    result = [];
    [mdaq_ip_address, res] = mdaq_get_ip();
    if res < 0 then
        disp("ERROR: Unable to get IP address!")
        return;
    end
    tmp_file = getURL('http://' + mdaq_ip_address + '/user-disk/dsp/data/' + filename, TMPDIR);

    if isfile(tmp_file) then
        result = fscanfMat(tmp_file);
        mdelete(tmp_file);
    else
        disp("ERROR: File not found!");
    end

endfunction
