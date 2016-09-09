function mdaq_block_import(block)
    
    if argn(2) == 1 then
        macros_path = mdaq_toolbox_path() + "macros" + filesep() + "user_blocks" + filesep();
        userlib_path = mdaq_toolbox_path()+'src'+filesep()+'c'+ filesep()+'userlib'+filesep();

    else
        macros_path = mdaq_toolbox_path() + "macros" + filesep() + "user_blocks" + filesep();
        userlib_path = mdaq_toolbox_path()+'src'+filesep()+'c'+ filesep()+'userlib'+filesep();

    end
    

endfunction
