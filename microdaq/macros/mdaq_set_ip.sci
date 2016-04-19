function mdaq_set_ip(mdaq_ip)
    
    ip_config_file_path = mdaq_toolbox_path() + "etc"+filesep()+"mlink"+filesep()+"ip_config.txt";
    if argn(2) > 1 | argn(2) < 1 then
        mprintf("Description:\n");
        mprintf("\tSet IP address\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_set_ip(ip_address);\n")
        mprintf("\tip_address - MicroDAQ IP address (string)\n");
        return;
    end
    
    if mdaq_ip == [] | mdaq_ip == "" then
        disp("Wrong input argument - provide valid MicroDAQ IP address")
    end
    
    [f,err] = mopen(ip_config_file_path,'w');
    if err == 0 then
        mputl(string(mdaq_ip),f) 
        mclose(f)
        global %microdaq
        %microdaq.ip_address = mdaq_ip; 
    else
        disp("ERROR: Unable to set IP address!")
    end
endfunction
