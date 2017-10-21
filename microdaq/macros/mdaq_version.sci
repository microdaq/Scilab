function mdaq_ver = mdaq_version()
    mdaq_ver = mgetl(mdaqToolboxPath() + filesep() + "VERSION", 1);
endfunction
