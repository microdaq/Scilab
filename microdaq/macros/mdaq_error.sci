function error_desc = mdaq_error(error_id)
    result = 0;
    [error_desc, result] = call("sci_mlink_error",..
            error_id, 1, 'i',..
        "out",..
            [1, 64], 2, 'c',..
            [1,1], 3, 'i');
     
     if error_id == -1 then
         error(error_desc);
     else
         disp(error_desc);
     end
endfunction
