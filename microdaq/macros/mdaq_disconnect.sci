function result = mdaq_disconnect(connection_id)
    result = call("sci_mlink_disconnect",..
            connection_id, 1, "i",..
        "out",..
            [1, 1], 2, "i");
            
            result = 0; 
endfunction

