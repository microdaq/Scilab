function block=mdaq_dac_sim(block,flag)
    //tic();
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then  
                ipar_size = size(block.ipar,'r');   
                mdaq_ao_write(%microdaq.private.connection_id,..
                                block.ipar(4:ipar_size-1)',..
                                block.ipar(ipar_size),..
                                block.inptr(1)');
            end
        case 2 // State Update
        case 3 // OutputEventTiming
        case 4 // Initialization
        case 5 // Ending
            if %microdaq.private.connection_id > -1 then
                ipar_size = size(block.ipar,'r');
                mdaq_ao_write(%microdaq.private.connection_id,..
                                block.ipar(4:ipar_size-1)',..
                                block.ipar(ipar_size),..
                               block.rpar(2:1+block.rpar(1)));
            end
        case 6 // Re-Initialisation
        case 9 // ZeroCrossing
        else // Unknown flag
        end
    end
    //mprintf("Elapsed time mdaq_dac_sim: %f ms\n", toc()*1000);
endfunction
