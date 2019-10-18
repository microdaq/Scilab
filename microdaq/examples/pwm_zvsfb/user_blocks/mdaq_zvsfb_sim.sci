// Generated with MicroDAQ toolbox ver: 1.3.0
function block=mdaq_zvsfb_sim(block,flag)

    global %microdaq
    if %microdaq.dsp_loaded == %F then

    pwm_period = block.rpar(1);
    default_duty = block.rpar(2);
    select flag
       case -5 // Error
       case 0 // Derivative State Update
       case 1 // Output Update
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
