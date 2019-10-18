// Generated with MicroDAQ toolbox ver: 1.2.1
function block=mdaq_profiler_sim(block,flag)

    global %microdaq
    if %microdaq.dsp_loaded == %F then

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
