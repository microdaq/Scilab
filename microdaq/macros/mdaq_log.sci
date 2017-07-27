function mdaq_log(filepath)
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

    if argn(2) == 0 then
        // print
        mprintf('Log generated on: %s\n',date());
        mprintf('Toolbox ver: %s\n\n',mdaq_version());
        mprintf('---- MLink log:\n%s\n\n', mlog);
        mprintf('---- Scilab environment info:\n');
        mprintf('Scilab architecture: %s\n', opts(2));
        for i=1:size(sci, 'r') 
            mprintf('%s %s\n', sci(i, 1), sci(i, 2));
        end
    else
        // save to file
        fd = mopen(filepath,'wt');
        mfprintf(fd,'Log generated on: %s\n',date());
        mfprintf(fd,'Toolbox ver: %s\n\n',mdaq_version());
        mfprintf(fd,'---- MLink log:\n%s\n\n', mlog);
        mfprintf(fd,'---- Scilab environment info:\n');
        mfprintf(fd,'Scilab architecture: %s\n', opts(2));
        for i=1:size(sci, 'r') 
            mfprintf(fd,'%s %s\n', sci(i, 1), sci(i, 2));
        end
        
        mclose(fd);
    end
endfunction
