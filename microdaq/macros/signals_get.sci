function [result, data] = signals_get(samples)
    [frames, sig_size] = call("sci_signals_get_config",..
        "out",..
            [1, 1], 1, "i",..
            [1, 1], 2, "i");
            
    [data, result] = call("sci_signals_get",..
            samples, 2, "i",..
        "out",..
            [samples * sig_size, 1], 1, "d",..
            [1, 1], 3, "i");
endfunction

