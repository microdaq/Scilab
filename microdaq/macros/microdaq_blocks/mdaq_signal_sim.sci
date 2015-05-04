function block=mdaq_signal_sim(block,flag)
    select flag
    case -5 // Error

    case 0 // Derivative State Update

    case 1 // Output Update
        global %microdaq;
        if %microdaq.dsp_loaded == %T then
            sig_size = block.insz(1) * block.insz(block.nin+1);
            [res data] = signal_get(block.ipar(1), block.insz(1), block.insz(block.nin+1))
            if res == sig_size then
                block.outptr(1) = data;
            else
                // TODO: handle this state
            end
        else
            // Simply copy input to output
            block.outptr(1) = block.inptr(1);
        end

    case 2 // State Update

    case 3 // OutputEventTiming

    case 4 // Initialization
        global %microdaq;
        if %microdaq.dsp_loaded == %T then
            sig_size = block.insz(1) * block.insz(block.nin+1);
            signal_register(block.ipar(1), sig_size);
        end
    case 5 // Ending

    case 6 // Re-Initialisation

    case 9 // ZeroCrossing

    else // Unknown flag

    end
endfunction
