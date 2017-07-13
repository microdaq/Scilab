function close_last_connection()
    global %microdaq;
    if %microdaq.private.connection_id <> -1 then 
       mdaq_close(%microdaq.private.connection_id);
       %microdaq.private.connection_id = -1;
    end 
endfunction 
