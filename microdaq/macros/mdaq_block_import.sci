function mdaqBlock_import(block)
    
    if argn(2) == 1 then
        macros_path = mdaqToolboxPath() + "macros" + filesep() + "user_blocks" + filesep();
        userlib_path = mdaqToolboxPath()+'src'+filesep()+'c'+ filesep()+'userlib'+filesep();

    else
        macros_path = mdaqToolboxPath() + "macros" + filesep() + "user_blocks" + filesep();
        userlib_path = mdaqToolboxPath()+'src'+filesep()+'c'+ filesep()+'userlib'+filesep();

    end
    

endfunction
