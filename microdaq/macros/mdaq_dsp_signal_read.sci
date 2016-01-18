function [result, data] = mdaq_dsp_signal_read(arg1, arg2)
    global %microdaq; 
    result = -1;

    if argn(2) == 1 then
        samples = arg1; 
    end

    if argn(2) == 2 then
        link_id = arg1;   
        samples = arg2; 
        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 2 | argn(2) < 1 then
        mprintf("Description:\n");
        mprintf("\tReads DSP signal\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_dsp_signal_read(link_id, sample_count);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tsample_count - number of samples to be read\n");
        return;
    end

    if %microdaq.dsp_ext_mode then
        [result, data] = signals_get(samples);
    else
        disp("Unable to read signal - loaded DSP application isn''t Ext mode");
        result = []; 
        data = [];
    end
endfunction
