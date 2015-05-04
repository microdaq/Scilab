function mdaq_close(link_id)
    if link_id < 0 then
        disp("WARNING: You are trying to close non existing connection!");
        return;
    end
    
    mdaq_disconnect(link_id);
endfunction
