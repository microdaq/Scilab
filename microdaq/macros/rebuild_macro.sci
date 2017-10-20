function rebuild_macro(name)
    tbx_path = mdaqToolboxPath();
    
    //run builder
    exec(tbx_path+"builder.sce", -1);
    
    //reload macro
    load(name);
endfunction
