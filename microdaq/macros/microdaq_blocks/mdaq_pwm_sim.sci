function block=mdaq_pwm_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then
                mdaq_pwm_write(%microdaq.private.connection_id,..
                               block.ipar(1),..
                               block.inptr(1),..
                               block.inptr(2));
            end
        case 2 // State Update
        case 3 // OutputEventTiming
        case 4 // Initialization
            if %microdaq.private.connection_id > -1 then
                mdaq_pwm_init(%microdaq.private.connection_id,..
                              block.ipar(1),..
                              block.ipar(2),..
                              block.ipar(3));
            end

        case 5 // Ending
            if %microdaq.private.connection_id > -1 then
                disp("connection id in ending:");
                disp(string(%microdaq.private.connection_id));
                mdaq_pwm_write(%microdaq.private.connection_id,..
                               block.ipar(1), 0, 0);
            end
        case 6 // Re-Initialisation
        case 9 // ZeroCrossing
        else // Unknown flag
        end
    end
endfunction
