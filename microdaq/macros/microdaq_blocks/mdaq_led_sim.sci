function block=mdaq_led_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then
                mdaqLEDWrite(%microdaq.private.connection_id,..
                                block.ipar(1),..
                                block.inptr(1));
            end
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
