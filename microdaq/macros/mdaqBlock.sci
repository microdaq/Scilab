function  initialized_mdaqBlock = mdaqBlock()
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaqBlock');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    initialized_mdaqBlock = struct('name',['new_block'],'desc',['Set new_block parameters'] ,'param_name', ['param1'; 'param2'], 'param_size', [1;1], 'param_def_val', list([0;0]), 'in', [1], 'out', [1], 'use_sim_script', %T);
endfunction
