function gen_block_help_files()
    blocks_path_base = get_absolute_file_path("gen_block_help_files.sce");
    blocks_path = blocks_path_base + filesep() + "microdaq_blocks";
    macros_path = blocks_path_base; 

    // Generate help for blocks
    disp(blocks_path + filesep() + "names");
    blocks = mgetl(blocks_path + filesep() + "names", -1)
    
    template_block = mgetl(blocks_path_base +  "../help/en_US/blocks/template_block._xml", -1);
    
    block_count = size(blocks)

    
    for block_idx = 1:block_count(1)
        if strstr(blocks(block_idx), "_sim") == ""
            
            // read template 
            template_block = mgetl(blocks_path_base +  "../help/en_US/blocks/template_block._xml", -1);
            template_block=strsubst(template_block,'__BLK_NAME__', blocks(block_idx));

            mputl(template_block,blocks_path_base +  "../help/en_US/blocks/" + blocks(block_idx)+ ".xml" ) 
        end
    end

    // Generate help for macros
    disp(macros_path + filesep() + "microdaq_macros" + filesep() + "names");
    blocks = mgetl(macros_path + filesep() + "microdaq_macros" + filesep() + "names", -1)
    
    template_block = mgetl(blocks_path_base +  "../help/en_US/hw_access/template_func._xml", -1);

	    
    block_count = size(blocks)
    for block_idx = 1:block_count(1)
            // read template 
            template_block = mgetl(blocks_path_base +  "../help/en_US/hw_access/template_func._xml", -1);
            template_block=strsubst(template_block,'__FUNC_NAME__', blocks(block_idx));

            mputl(template_block,blocks_path_base +  "../help/en_US/hw_access/" + blocks(block_idx)+ ".xml" ) 
    end



endfunction

gen_block_help_files();
