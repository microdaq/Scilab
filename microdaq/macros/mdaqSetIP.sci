function mdaqSetIP(mdaq_ip)
    
    ip_config_file_path = mdaqToolboxPath() + "etc"+filesep()+"mlink"+filesep()+"ip_config.txt";
    if argn(2) > 1 | argn(2) < 1 then
        mprintf("Description:\n");
        mprintf("\tSet IP address\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqSetIP(ipAddress);\n")
        mprintf("\tipAddress - MicroDAQ IP address (string)\n");
        return;
    end

    if mdaq_ip == [] | mdaq_ip == "" | regexp(mdaq_ip, "/(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/") == [] then
        error("Wrong IP address")
    end
    
    [f,err] = mopen(ip_config_file_path,'w');
    if err == 0 then
        mputl(string(mdaq_ip),f) 
        mclose(f)
        global %microdaq
        %microdaq.ip_address = mdaq_ip; 
    else
        error("Unable to set IP address!")
    end
endfunction
