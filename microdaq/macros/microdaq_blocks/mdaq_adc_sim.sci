function block=mdaq_adc_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then
                if block.ipar(4) == 29 then
                    differential = %T
                else
                    differential = %F
                end
                
                block.outptr(1) = mdaq_ai_read(%microdaq.private.connection_id,..
                                                block.ipar(7:size(block.ipar,'r')),..
                                                block.ipar(3),..
                                                differential);
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
