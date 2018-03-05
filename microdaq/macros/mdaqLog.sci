function mdaqLog(filepath)
    mdaq_ip = mdaq_get_ip();
    if mdaq_system_ping() then
        try
            [filename, mlog] = getURL(mdaq_ip + "/log/mlink-server.log", TMPDIR + filesep());
        catch

        end
    else
        mprintf("ERROR: Unable to connect to MicroDAQ device!\n");
        return;
    end

    sci = ver();
    [version, opts] = getversion();
    lib_ver = mdaq_lib_version();
    
    try
        fw_ver = mdaq_fw_version();
    catch
        fw_ver = [0 0 0 0];
        mprintf("WARNING: Unable to read MicroDAQ firmware version!\n");
    end

    if argn(2) == 0 then
        // print
        mprintf('Log generated on:      %s\n',date());
        mprintf('Toolbox ver:           %s\n',mdaq_version());
        mprintf('MLink library ver:     %d.%d.%d.%d\n', lib_ver(1), lib_ver(2), lib_ver(3), lib_ver(4));
        mprintf('MicroDAQ firmware ver: %d.%d.%d.%d\n\n', fw_ver(1), fw_ver(2), fw_ver(3), fw_ver(4));
        mprintf('---- MLink log:\n%s\n\n', mlog);
        mprintf('---- Scilab environment info:\n');
        mprintf('Scilab architecture: %s\n', opts(2));
        for i=1:6
            mprintf('%s %s\n', sci(i, 1), sci(i, 2));
        end
    else
        // save to file
        fd = mopen(filepath,'wt');
        mfprintf(fd,'Log generated on:      %s\n',date());
        mfprintf(fd,'Toolbox ver:           %s\n',mdaq_version());
        mfprintf(fd,'MLink library ver:     %d.%d.%d.%d\n', lib_ver(1), lib_ver(2), lib_ver(3), lib_ver(4));
        mfprintf(fd,'MicroDAQ firmware ver: %d.%d.%d.%d\n\n', fw_ver(1), fw_ver(2), fw_ver(3), fw_ver(4));
        mfprintf(fd,'---- MLink log:\n%s\n\n', mlog);
        mfprintf(fd,'---- Scilab environment info:\n');
        mfprintf(fd,'Scilab architecture: %s\n', opts(2));
        for i=1:6
            mfprintf(fd,'%s %s\n', sci(i, 1), sci(i, 2));
        end
        
        mclose(fd);
    end
endfunction
