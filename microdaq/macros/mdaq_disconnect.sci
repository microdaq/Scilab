function result = mdaq_disconnect(connection_id)
    result = call("sci_mlink_disconnect",..
            connection_id, 1, "i",..
        "out",..
            [1, 1], 2, "i");

    if result < 0 then
        if result == -1 then
            global %microdaq;
            ulink(%microdaq.private.mlink_link_id);
            exec(mdaq_toolbox_path()+filesep()+"etc"+filesep()+..
                    "mlink"+filesep()+"MLink.sce", -1);
            result = call("sci_mlink_disconnect",..
                    connection_id, 1, "i",..
                "out",..
                    [1, 1], 2, "i");
        else
            disp(mdaq_error(result));
        end
    end
endfunction

