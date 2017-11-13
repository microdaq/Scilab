function mdaqBlockDelete(block_name)
    if argn(2) < 1 then
        mprintf("Description:\n");
        mprintf("\tDeletes MicroDAQ user block\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqBlockDelete(block_name);\n")
        return;
    end
    
    mprintf("WARNING: This function will remove all files related to ''%s'' block (including C source).\n", block_name); 
    opt = input("         Are you sure? [y/n]: ", "string");
    if opt <> 'y' & opt <> 'Y' then
        return;
    end
    
    //Convert name 
    name_converted = convstr(block_name,'l');
    name_converted = strsubst(name_converted, ' ', '_');
    name_converted = 'mdaq_' + name_converted;
    
    // Delete from macros 
    macrosPath = pathconvert(mdaqToolboxPath()+'macros/user_blocks/');
    mdelete(macrosPath+name_converted+'.sci');
    mdelete(macrosPath+name_converted+'_sim.sci');
    mdelete(macrosPath+name_converted+'.bin');
    mdelete(macrosPath+name_converted+'_sim.bin');
    
    // Delete images 
    imagesPath = pathconvert(mdaqToolboxPath()+'images/');
    mdelete(imagesPath+'gif'+filesep()+name_converted+'.gif');
    mdelete(imagesPath+'h5'+filesep()+name_converted+'.sod');
    mdelete(imagesPath+'svg'+filesep()+name_converted+'.svg');
    
    // Delete code 
    srcPath = pathconvert(mdaqToolboxPath()+'src/c/userlib/');
    backUpPath = mdaqToolboxPath()+pathconvert("src\c\userlib\.removed_code");
    try
        if isdir(backUpPath) == %F then
                mkdir(backUpPath);
        end
        copyfile(srcPath+name_converted+'.c', backUpPath);
    catch
    end
    mdelete(srcPath+name_converted+'.c');
    mdelete(srcPath+name_converted+'.o');
    
    mprintf("Block has been deleted. Please restart Scilab software.\n");
endfunction
