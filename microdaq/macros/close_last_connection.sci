function close_last_connection()
    global %microdaq;
    if %microdaq.private.connection_id <> -1 then 
       mdaqClose(%microdaq.private.connection_id);
       %microdaq.private.connection_id = -1;
    end 
endfunction 
