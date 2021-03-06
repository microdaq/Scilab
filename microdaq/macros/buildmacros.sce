function buildmacros()
   
    global %microdaq;
    %microdaq = struct("model", ["Unknown"],..
        "ip_address", [],..
        "dsp_loaded", %F,..
        "dsp_ext_mode", %T,..
        "dsp_debug_mode", %F,..
        "private", struct(..
        "mlink_link_id", -1000,..
        "userhostlib_link_id", -1000,..
        "connection_id", -1,..
        "has_mdaqBlock", %F,..
        "has_mdaq_param_sim", %F,..
        "mem_write_idx", 0,..
        "mem_read_idx", 0,..
        "to_file_idx", 0,..
        "dac_idx", 0,..
        "adc_idx", 0,..
        "webscope_idx", 0,..
        "udpsend_idx", 0,..
        "mdaq_signal_id", 0,..
        "ao_scan_ch_count", -1,..
        "mdaq_hwid", [])..
    );

    script_path = get_absolute_file_path("buildmacros.sce");
    module_path = part(script_path,1:length(script_path)-length("macros") - 1 )


    
    tbx_build_macros(TOOLBOX_NAME, script_path + filesep() + "microdaq_blocks");
    tbx_build_macros(TOOLBOX_NAME, script_path + filesep() + "microdaq_macros");
    tbx_build_macros(TOOLBOX_NAME, script_path);

    // check user_blocks beafore build
    if isdir(script_path + filesep() + "user_blocks") == %F then
        mkdir(script_path + filesep() + "user_blocks");
    end

    tbx_build_macros(TOOLBOX_NAME, script_path + filesep() + "user_blocks");

    // Build MicroDAQ blocks 
    microdaq_blocks = []
    f = ls(script_path + filesep() + "microdaq_blocks" + filesep() + "*.bin")
    microdaq_blocks = basename(f)

    blocks = [];
    for i=1:size(microdaq_blocks, "*")
        if strstr(microdaq_blocks(i), "_sim") == "" then
            blocks = [blocks, microdaq_blocks(i)];
        end
    end

    tbx_build_blocks(module_path, blocks, "macros" + filesep() + "microdaq_blocks");

    // Build MicroDAQ User blocks 
    if isfile(script_path + filesep() + "user_blocks" + filesep() + "names")  == %T then

        microdaq_blocks = []
        f = ls(script_path + filesep() + "user_blocks" + filesep() + "*.bin")
        microdaq_blocks = basename(f)

        blocks = [];
        for i=1:size(microdaq_blocks, "*")
            if strstr(microdaq_blocks(i), "_sim") == "" then
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
