// Generated with MicroDAQ toolbox ver: 1.0.
function block=mdaq_stop_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case 4 // Initialization
            disp("WARNING: mdaq_stop block isn''t supported in host simulation mode!")
        end
    end
endfunction
