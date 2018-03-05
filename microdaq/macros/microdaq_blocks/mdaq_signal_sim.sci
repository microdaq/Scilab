function block=mdaq_signal_sim(block,flag)
    select flag
    case -5 // Error

    case 0 // Derivative State Update

    case 1 // Output Update
        global %microdaq;
        if %microdaq.dsp_loaded == %T then
            try
                data = mdaqDSPSignalRead(block.ipar(1), block.insz(1), block.insz(block.nin+1), 4200000);
                block.outptr(1) = data;
            catch
                warning("Cannot read signal data.")
            end
        else
            // Simply copy input to output
            block.outptr(1) = block.inptr(1);
        end

    case 2 // State Update

    case 3 // OutputEventTiming

    case 4 // Initialization
     
    case 5 // Ending

    case 6 // Re-Initialisation

    case 9 // ZeroCrossing

    else // Unknown flag

    end
endfunction
