function  initialized_mdaqBlock = mdaqBlock()
    initialized_mdaqBlock = struct('name',['new_block'],'desc',['Set new_block parameters'] ,'param_name', ['param1'; 'param2'], 'param_size', [1;1], 'param_def_val', list([0;0]), 'in', [1], 'out', [1], 'use_sim_script', %T);
endfunction
