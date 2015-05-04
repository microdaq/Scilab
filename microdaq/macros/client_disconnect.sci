function result = client_disconnect(connection_id)
    result = call("sci_client_disconnect",..
        connection_id, 1, "i",..
     "out",..
        [1, 1], 2, "i");
endfunction

