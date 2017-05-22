function result = mdaq_dsp_signal(arg1, arg2, arg3)
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaq_dsp_signal');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    
    global %microdaq;
    result = -1;

    if argn(2) == 2 then
        sig_id = arg1; 
        sig_size = arg2; 
    end

    if argn(2) == 3 then
        link_id = arg1;   
        sig_id = arg2; 
        sig_size = arg3; 
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tRegisters DSP signal\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_dsp_signal(link_id, signal_id, signal_size);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tsignal_id - signal ID defined in SIGNAL block\n");
        mprintf("\tsignal_size - signal vector size\n");
        return;
    end
    
    if %microdaq.dsp_ext_mode then
        result = signal_register(sig_id, sig_size)
    else
        disp("Unable to register signal - loaded DSP application isn''t Ext mode!");
        result = -1;
    end
endfunction
