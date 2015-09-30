function block=mdaq_time_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            block.outptr(1) = scicos_time();
        case 2 // State Update
        case 3 // OutputEventTiming
        case 4 // Initialization
        case 5 // Ending
        case 6 // Re-Initialisation
        case 9 // ZeroCrossing
        else // Unknown flag
        end
    end
endfunction
