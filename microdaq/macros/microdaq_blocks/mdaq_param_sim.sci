function block=mdaq_param_sim(block,flag)
    select flag
    case -5 // Error

    case 0 // Derivative State Update

    case 1 // Output Update
        global %microdaq;
        if %microdaq.dsp_loaded & %microdaq.private.has_mdaq_param_sim then
            if %microdaq.private.connection_id > -1 then

                len = size(block.inptr(1), "*");
                result = call("sci_mlink_dsp_param",..
                            %microdaq.private.connection_id, 1, 'i',..
                            1, 2, 'i',..
                            block.inptr(1), 3, 'r',..
                            len, 4, 'i',..
                            scicos_time(), 5, 'r',..
                        "out",..
                            [1,1], 6, 'i');
            else
                disp("Unable to write data");
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
