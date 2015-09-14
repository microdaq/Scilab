function buildmacros()
    script_path = get_absolute_file_path("buildmacros.sce");
    module_path = part(script_path,1:length(script_path)-length("macros") - 1 )

    tbx_build_macros(TOOLBOX_NAME, script_path);
    tbx_build_macros(TOOLBOX_NAME, script_path + filesep() + "microdaq_blocks");
    tbx_build_macros(TOOLBOX_NAME, script_path + filesep() + "microdaq_macros");

    // check user_blocks beafore build
    if isdir(script_path + filesep() + "user_blocks") == %F then
        mkdir(script_path + filesep() + "user_blocks");
    end

    tbx_build_macros(TOOLBOX_NAME, script_path + filesep() + "user_blocks");

    // Build MicroDAQ blocks 
    microdaq_blocks = mgetl( script_path + filesep() + "microdaq_blocks" + filesep() + "names");
    microdaq_blocks = microdaq_blocks';

    blocks = [];
    for i=1:size(microdaq_blocks, "*")
        if strstr(microdaq_blocks(i), "_sim") == "" 
            blocks = [blocks, microdaq_blocks(i)];
        end
    end

    tbx_build_blocks(module_path, blocks, "macros" + filesep() + "microdaq_blocks");

    // Build MicroDAQ User blocks 
    if isfile(script_path + filesep() + "user_blocks" + filesep() + "names")  == %T then

        microdaq_blocks = mgetl( script_path + filesep() + "user_blocks" + filesep() + "names");
        microdaq_blocks = microdaq_blocks';


        blocks = [];
        for i=1:size(microdaq_blocks, "*")
            if strstr(microdaq_blocks(i), "_sim") == "" 
                if isfile(script_path + filesep() + "user_blocks" + filesep() + microdaq_blocks(i) + '.sci')  == %T then
                    blocks = [blocks, microdaq_blocks(i)];
                end
            end
        end
        
        if blocks <> [] then
            tbx_build_blocks(module_path, blocks, "macros" + filesep() + "user_blocks");
        end
    end
endfunction

buildmacros();
clear buildmacros; // remove buildmacros on stack
