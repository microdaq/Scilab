function mdaq_ver = mdaq_version()
    mdaq_ver = mgetl(mdaq_toolbox_path() + filesep() + "VERSION", 1);
endfunction
