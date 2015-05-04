function data = mdaq_exec_profile()
    data = [];
    if isfile(TMPDIR + filesep() + "profiling_data") then
        load(TMPDIR + filesep() + "profiling_data");
        data = dsp_exec_profile; 
        clear dsp_exec_profile; 
    else
        disp("WARNING: Unable to get profiling data - make sure it is enabled in SETUP block!")
        return;
    end
endfunction
