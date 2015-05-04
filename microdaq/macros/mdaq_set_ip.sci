function mdaq_set_ip(mdaq_ip)
    ip_config_file_path = mdaq_toolbox_path() + "etc"+filesep()+"mlink"+filesep()+"ip_config.txt";

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
