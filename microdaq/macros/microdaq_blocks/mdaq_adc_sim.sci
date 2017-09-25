function block=mdaq_adc_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then
                adc_mode = [];
                adc_mode_b = block.ipar(2+5*block.ipar(1) : 2+6*block.ipar(1)-1); 
                
                for i = 1:size(adc_mode_b, 'r')
                  adc_mode(i) = adc_mode_b(i) == 1;  
                end

                block.outptr(1) = mdaq_ai_read(%microdaq.private.connection_id,..
                                                block.ipar(2 : 2+block.ipar(1)-1)',..
                                                block.ipar(2+4*block.ipar(1):2+5*block.ipar(1)-1)',..
                                                adc_mode');
                clear adc_mode;
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
