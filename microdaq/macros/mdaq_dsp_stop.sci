function result = mdaq_dsp_stop(connection_id)
    result = call("sci_mlink_dsp_stop",..
                connection_id, 1, "i",..
            "out",..
                [1,1], 2, "i");
endfunction
