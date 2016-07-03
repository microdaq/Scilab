function result = mlink_dsp_start(connection_id, model_tsamp)
    result = call("sci_mlink_dsp_start",..
                connection_id, 1, "i",..
            "out",..
                [1,1], 2, "i");

    result = mlink_set_obj(connection_id, 'model_tsamp', model_tsamp );
    if result < 0 then
        disp("ERROR: Unable to set model sample rate - model will run with defaults")
        return;
    end
endfunction
