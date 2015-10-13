function result = mlink_dsp_start(connection_id)
    result = call("sci_mlink_dsp_start",..
                connection_id, 1, "i",..
            "out",..
                [1,1], 2, "i");
endfunction
