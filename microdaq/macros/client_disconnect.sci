function result = client_disconnect()
    result = call("sci_client_disconnect", "out", [1, 1], 1, "i");
endfunction

