function result = signal_register(id, signal_size)
    result = call("sci_signal_register",..
            id, 1, "i",.. 
            signal_size, 2, "i",..
        "out",..
            [1, 1], 3, "i"); 
endfunction
