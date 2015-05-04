function block=mdaq_sinus_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            t = scicos_time();
            w = block.rpar(3)*(t-block.rpar(5))-block.rpar(4);
            block.outptr(1) = block.rpar(1)*sin(w) + block.rpar(2) ;

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
