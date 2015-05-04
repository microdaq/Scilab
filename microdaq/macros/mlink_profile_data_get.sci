function [data, result] = mlink_profile_data_get(connection_id, sample_count)
    [data, result] = call("sci_mlink_dsp_profile_get",..
            connection_id, 1, "i",..
            sample_count, 3, "i",..
        "out",..
            [sample_count, 1], 2, "i",..
            [1, 1], 4, "i");
endfunction
