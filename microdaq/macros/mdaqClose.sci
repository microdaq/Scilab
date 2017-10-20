function mdaqClose(link_id)
    if argn(2) == 1 then
        if link_id < 0 then
            error("ERROR: Invalid connection id!");
        end
        result = call("sci_mlink_disconnect",..
                        link_id, 1, "i",..
                    "out",..
                        [1, 1], 2, "i");
    else
        call("sci_mlink_disconnect_all", "out", [1, 1], 1, "i");
    end
endfunction
