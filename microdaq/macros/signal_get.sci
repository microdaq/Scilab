function [result, data] = signal_get(id,  signal_rows, signal_cols)
    [data result] = call("sci_signal_get",..
            id, 1, "i",..
        "out",..
            [signal_rows, signal_cols], 2, "d",..
            [1, 1], 3, "i");
endfunction
