function result = check_mdaq_compiler()
    result = isfile(mdaq_toolbox_path() + "rt_templates"+filesep()+"target_paths.mk");
endfunction
