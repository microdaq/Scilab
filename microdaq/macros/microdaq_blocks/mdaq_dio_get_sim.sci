function block=mdaq_dio_get_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then
                
                distate = mdaq_dio_read(%microdaq.private.connection_id,..
                                                block.ipar(1));
                                                
                if distate then 
                    block.outptr(1) = 1;
                else
                    block.outptr(1) = 0;
                end
                
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
