function mdaq_log()
    mdaq_ip = mdaq_get_ip();
    if mdaq_system_ping() then 
        try 
            getURL(mdaq_ip + "/log/mlink-server.log", TMPDIR + filesep());
        catch
            
        end
        try 
            disp(mgetl(TMPDIR + filesep() + "mlink-server.log"))
        catch
            disp("Error: unable to get log file!")
        end
    else
        mprintf("ERROR: Unable to connect to MicroDAQ device!\n");
    end

endfunction
