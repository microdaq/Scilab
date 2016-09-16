block = mdaq_block() 
block.name = "TestLinux1";
block.param_name = ['Step time' 'Initial value' 'Final value' 'Terminate value'];
block.param_size = [ 1 1 1 1 ];
block.param_def_val(1) = 1; // 'Step time' default value 
block.param_def_val(2) = 0; // 'Initial value' default value 
block.param_def_val(3) = 1; // 'Final value' default value 
block.param_def_val(4) = 0; // 'Terminate value' default value 
block.in = []; // block doesnt'have input port
block.out = [ 1 ]; // one output port - size 1
mdaq_block_add(block);
