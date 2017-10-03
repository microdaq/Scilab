function block=mdaq_adc_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then
                channels = block.ipar(3:3+block.ipar(1)-1)';
                aiRange = matrix(block.rpar, 2, size(channels, 'c'))';
                aiMode_t = block.ipar(3+block.ipar(1):3+2*block.ipar(1)-1)';
                aiMode = [];
                for i = 1:size(aiMode_t, 'c')
                  if aiMode_t(i) == 0 then
                      aiMode(i)= %F;
                  else
                      aiMode(i)= %T;
                  end
               end
               
               block.outptr(1) = mdaq_ai_read(%microdaq.private.connection_id, channels, aiRange, aiMode');
               clear aiMode;
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
