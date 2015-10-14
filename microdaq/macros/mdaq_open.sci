function link_id = mdaq_open()
    global %microdaq;
    link_id = -1; 
    result = 0; 
    [ip_address, result] = mdaq_get_ip();
    if result < 0 then
        disp("ERROR: Unable to get IP address - run microdaq_setup!");
        return; 
    end
    link_id = mlink_connect(ip_address, 4343);

    if link_id < 0 then
        ulink(%microdaq.private.mlink_link_id);
        exec(mdaq_toolbox_path()+filesep()+"etc"+filesep()+..
                "mlink"+filesep()+"MLink.sce", -1);
        link_id = mlink_connect(ip_address, 4343);
    end
endfunction
