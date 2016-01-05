function mdaq_open_webscope()
    [ip_address, result] = mdaq_get_ip(); 
    if result < 0 then
        message("ERROR: Unable to get device IP address!");
        return;
    end
    if getos() == 'Windows' then
        unix_s("start http://" + ip_address + "/webscope");
    else
        unix_s("xdg-open http://" + ip_address + "/webscope");
    end
endfunction
