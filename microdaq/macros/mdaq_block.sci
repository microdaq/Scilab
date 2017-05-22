function  initialized_mdaq_block = mdaq_block()
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaq_block');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    initialized_mdaq_block = struct('name',['new_block'],'desc',['Set new_block parameters'] ,'param_name', ['param1'; 'param2'], 'param_size', [1;1], 'param_def_val', list([0;0]), 'in', [1], 'out', [1]);
endfunction
