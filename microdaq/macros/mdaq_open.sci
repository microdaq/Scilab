function link_id = mdaq_open(ipAddr)
    link_id = -1; 
    hwid = [];
    result = 0; 

    if argn(2) == 1 then
        ip_address = ipAddr; 
    else
        [ip_address, result] = mdaq_get_ip();
        if result < 0 then
            error("Unable to get IP address - run microdaq_setup() or mdaq_set_ip() function."); 
        end
    end

    [link_id, hwid] = mlink_connect(ip_address, 4343);

    if hwid(1) == 0 then
        mdaq_close(link_id);
        link_id = -1; 
        error("Unrecognized MicroDAQ device - contact support!"); 
    end
endfunction
