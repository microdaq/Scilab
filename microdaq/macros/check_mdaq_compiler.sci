function result = check_mdaq_compiler()
    result = isfile(mdaqToolboxPath() + "rt_templates"+filesep()+"target_paths.mk");
endfunction
