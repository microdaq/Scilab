// Generated with MicroDAQ toolbox ver: 1.1.
function block=mdaq_pid_z_sim(block,flag)

    global %microdaq
    if %microdaq.dsp_loaded == %F then

    filter_coefficient = block.rpar(1);
    upper_sat_limit = block.rpar(2);
    lower_sat_limit = block.rpar(3);
    back_calculation_kb = block.rpar(4);
    tracking_kt = block.rpar(5);
    sample_time = block.rpar(6);
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
