function error_desc = mdaq_error(error_id)
    [error_desc] = mdaq_error2(error_id);
    
     if error_id == -1 then
         error(error_desc);
     else
         disp(error_desc);
     end
endfunction
