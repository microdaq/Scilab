function block=mdaq_rc_controller_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case 4 // Initialization
            disp("WARNING: mdaq_rc_controller block isn''t supported in host simulation mode!")
        end
    end
endfunction
