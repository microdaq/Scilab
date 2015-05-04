function block=mdaq_pru_reg_set_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case 4 // Initialization
            disp("WARNING: mdaq_pru_reg_set block isn''t supported in host simulation mode!")
        end
    end
endfunction
