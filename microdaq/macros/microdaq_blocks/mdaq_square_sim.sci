function block=mdaq_square_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            t = scicos_time();

            if t < block.rpar(5) then
                block.outptr(1) = 0.0;
            else
                v = (t-block.rpar(5))/block.rpar(2);
                v = (v-int(v)) * block.rpar(2);

                if v < block.rpar(3) then
                    block.outptr(1) = block.rpar(4)+block.rpar(1);
                else
                    block.outptr(1) = block.rpar(4);
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
