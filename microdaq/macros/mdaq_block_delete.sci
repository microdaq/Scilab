function mdaq_block_delete(block_name)
    //Convert name 
    name_converted = convstr(block_name,'l');
    name_converted = strsubst(name_converted, ' ', '_');
    name_converted = 'mdaq_' + name_converted;
    
    // Delete from macros 
    macrosPath = pathconvert(mdaq_toolbox_path()+'macros/user_blocks/');
    mdelete(macrosPath+name_converted+'.sci');
    mdelete(macrosPath+name_converted+'_sim.sci');
    mdelete(macrosPath+name_converted+'.bin');
    mdelete(macrosPath+name_converted+'_sim.bin');
    
    // Delete images 
    imagesPath = pathconvert(mdaq_toolbox_path()+'images/');
    mdelete(imagesPath+'gif'+filesep()+name_converted+'.gif');
    mdelete(imagesPath+'h5'+filesep()+name_converted+'.sod');
    mdelete(imagesPath+'svg'+filesep()+name_converted+'.svg');
    
    // Delete code 
    srcPath = pathconvert(mdaq_toolbox_path()+'src/c/userlib/');
    mdelete(srcPath+name_converted+'.c');
    mdelete(srcPath+name_converted+'.o');
endfunction
