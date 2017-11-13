function res = mdaq_system_ping()
    if getos() == 'Linux' then 
        cmd = 'ping -c 1 -w 1 ';
    elseif getos() == 'Windows' then 
        cmd = 'ping -n 1 -w 1 ';
    elseif (getos() == "Darwin") then 
        cmd = 'ping -c 1 -w 1 ';
    end 
    
    res = unix(cmd+mdaq_get_ip());
    res = ~res;
endfunction
