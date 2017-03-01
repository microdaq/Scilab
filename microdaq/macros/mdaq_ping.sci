function result = mdaq_ping()
     // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaq_ping');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    
    [mdaq_ip_addr, res] = mdaq_get_ip();
    if res < 0 then
        disp("Unable to get MicroDAQ IP address - run microdaq_setup!");
        result = %F;
    else
        mprintf('Connecting to MicroDAQ@%s...',mdaq_ip_addr); 
        connection_id = mdaq_open();
        if connection_id < 0 then
            mprintf(' ERROR!\nUnable to connect to MicroDAQ device, check your configuration!\n');
            mprintf('Scilab is configured with following settings:\n');
            mprintf('IP address: %s, port %d\n', mdaq_ip_addr, 4343);
            mprintf('If MicroDAQ has different IP address use mdaq_ip_set to set correct IP address.\n\n');
            result = %F;
        else
            mprintf('OK!\n');
            mdaq_disconnect(connection_id);
            result = %T;
        end
    end
endfunction
