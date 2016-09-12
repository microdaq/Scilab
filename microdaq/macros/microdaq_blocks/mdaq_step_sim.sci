// Generated with MicroDAQ toolbox ver: 1.1.
function block=mdaq_step_sim(block,flag)

    global %microdaq
    if %microdaq.dsp_loaded == %F then

        step_time = block.rpar(1);
        initial_value = block.rpar(2);
        final_value = block.rpar(3);
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if scicos_time() > step_time then
                block.outptr(1) = final_value; 
            else 
                block.outptr(1) = initial_value;   
            end
        case 2 // State Update
        case 3 // OutputEventTiming
        case 4 // Initialization
        case 5 // Ending
        case 6 // Re-Initialisation
        case 9 // ZeroCrossing
        else // Unknown flag
            break
        end
    end
endfunction
