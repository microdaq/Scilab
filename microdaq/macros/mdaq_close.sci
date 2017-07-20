function mdaq_close(link_id)
    if argn(2) == 1 then
        if link_id < 0 then
            error("ERROR: Invalid connection id!");
        end
        result = call("sci_mlink_disconnect",..
                        connection_id, 1, "i",..
                    "out",..
                        [1, 1], 2, "i");
    else
        call("sci_mlink_disconnect_all");
    end
endfunction
