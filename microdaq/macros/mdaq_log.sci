function mdaq_log()
    mdaq_ip = mdaq_get_ip();
    try 
        getURL(mdaq_ip + "/log/mlink-server.log", TMPDIR + filesep());
    catch
        
    end
    try 
        disp(mgetl(TMPDIR + filesep() + "mlink-server.log"))
    catch
        disp("Error: unable to get log file!")
    end

endfunction
