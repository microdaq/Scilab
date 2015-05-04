function block=mdaq_encoder_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then
                [block.outptr(1), block.outptr(2)] = mdaq_enc_read(%microdaq.private.connection_id,..
                                                block.ipar(1));
            end
        case 2 // State Update
        case 3 // OutputEventTiming
        case 4 // Initialization
            if %microdaq.private.connection_id > -1 then
                   mdaq_enc_init(%microdaq.private.connection_id,..
                                  block.ipar(1),..
                                  block.ipar(2));
            end
        case 5 // Ending
        case 6 // Re-Initialisation
        case 9 // ZeroCrossing
        else // Unknown flag
        end
    end
endfunction
