function block=mdaq_encoder_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then
                if block.ipar(1) > 2 then 
                        block.outptr(1) = 0;
                        block.outptr(2) = 0;
                else
                [block.outptr(1), block.outptr(2)] = mdaqEncoderRead(%microdaq.private.connection_id,..
                                                block.ipar(1));
                end;
            end
        case 2 // State Update
        case 3 // OutputEventTiming
        case 4 // Initialization
            if %microdaq.private.connection_id > -1 then
                   if block.ipar(1) > 2 then 
                        warning("Encoder ENC3/ENC4 is not supported in simulation mode.");
                   else
                    mdaqEncoderInit(%microdaq.private.connection_id,..
                                  block.ipar(1),..
                                  block.ipar(2));
                   end
            end
        case 5 // Ending
        case 6 // Re-Initialisation
        case 9 // ZeroCrossing
        else // Unknown flag
        end
    end
endfunction
