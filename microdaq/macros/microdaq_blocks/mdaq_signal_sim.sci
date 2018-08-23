function block=mdaq_signal_sim(block,flag)
    select flag
    case -5 // Error
    case 0 // Derivative State Update

    case 1 // Output Update
        global %microdaq;
        if %microdaq.dsp_loaded == %T then
                if %microdaq.private.signal_buffer_index(block.ipar(1)) < 1 then
                    try
                    %microdaq.private.signal_buffer(block.ipar(1)) = mdaqDSPRead(block.ipar(1), block.insz(1), %microdaq.private.signal_buffer_size(block.ipar(1)), 5000);

                    %microdaq.private.signal_buffer_index(block.ipar(1)) = %microdaq.private.signal_buffer_size(block.ipar(1)); 
                    catch
                        warning("Unable to receive DSP data from MicroDAQ device"); 
                        return;
                    end
                    
                end
                block.outptr(1) = %microdaq.private.signal_buffer(block.ipar(1))(%microdaq.private.signal_buffer_size(block.ipar(1)) + 1 - %microdaq.private.signal_buffer_index(block.ipar(1)),:);
                %microdaq.private.signal_buffer_index(block.ipar(1)) = %microdaq.private.signal_buffer_index(block.ipar(1)) - 1; 
        else
            // Simply copy input to output
            block.outptr(1) = block.inptr(1);
        end
    case 2 // State Update
    case 3 // OutputEventTiming
    case 4 // Initialization
        global %microdaq;
        update_rate = 25;

        if %microdaq.private.model_tsamp < 1/update_rate*2 then
            %microdaq.private.signal_buffer_size(block.ipar(1)) = (1/update_rate)/%microdaq.private.model_tsamp ;
        else
            %microdaq.private.signal_buffer_size(block.ipar(1)) = 1;
        end
        
        %microdaq.private.signal_buffer(block.ipar(1)) = zeros(%microdaq.private.signal_buffer_size(block.ipar(1)), block.insz(1));
        %microdaq.private.signal_buffer_index(block.ipar(1)) = 0;
    case 5 // Ending
    case 6 // Re-Initialisation
    case 9 // ZeroCrossing
    else // Unknown flag
    end
endfunction
