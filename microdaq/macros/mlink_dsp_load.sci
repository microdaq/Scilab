function result = mlink_dsp_load(connection_id, dsp_firmware, dsp_params)
    result = call("sci_mlink_dsp_load",..
                connection_id, 1, "i",..
                dsp_firmware, 2, "c",..
                dsp_params, 3, "c",...
            "out",..
                [1,1], 4, "i");
endfunction

