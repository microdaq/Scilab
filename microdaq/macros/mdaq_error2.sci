function error_desc = mdaq_error2(error_id)
    result = 0;
    [error_desc, result] = call("sci_mlink_error",..
            error_id, 1, 'i',..
        "out",..
            [1, 256], 2, 'c',..
            [1,1], 3, 'i');
            
    error_desc = stripblanks(error_desc);
endfunction
