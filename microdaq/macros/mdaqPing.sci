function result = mdaqPing()
    [mdaq_ip_addr, res] = mdaq_get_ip();
    if res < 0 then
        disp("Unable to get MicroDAQ IP address - run microdaq_setup!");
        result = %F;
    else
        mprintf('Connecting to MicroDAQ@%s...',mdaq_ip_addr); 
        connection_id = mdaqOpen();
        if connection_id < 0 then
            mprintf(' ERROR!\nUnable to connect to MicroDAQ device, check your configuration!\n');
            mprintf('Scilab is configured with following settings:\n');
            mprintf('IP address: %s, port %d\n', mdaq_ip_addr, 4343);
            mprintf('If MicroDAQ has different IP address use mdaqSetIP function to set correct IP address.\n\n');
            result = %F;
        else
            mprintf('OK!\n');
            mdaq_disconnect(connection_id);
            result = %T;
        end
    end
endfunction
