function block=mdaq_dac_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
            if %microdaq.private.connection_id > -1 then  
                ipar_size = size(block.ipar,'r');   
                mdaq_ao_write(%microdaq.private.connection_id,..
                                block.ipar(2:block.ipar(1)+1)',..
                                block.ipar(2+(2*block.ipar(1)):1+(3*block.ipar(1)))',..
                                block.inptr(1)');
            end
        case 2 // State Update
        case 3 // OutputEventTiming
        case 4 // Initialization
            if %microdaq.private.connection_id > -1 then
                ipar_size = size(block.ipar,'r');
                channel = block.ipar(2:block.ipar(1)+1)';
                ao_range = block.ipar(2+(2*block.ipar(1)):1+(3*block.ipar(1)))';
                init_voltage = block.rpar(1:block.ipar(1));
                use_init_term = block.ipar(2+(3*block.ipar(1)):1+(4*block.ipar(1)))';
                for i = 1:size(channel, '*')
                    if use_init_term(i) == 2 | use_init_term(i) == 3 then
                        mdaq_ao_write(%microdaq.private.connection_id, channel(i), ao_range(i), init_voltage(i))
                    end
                end
            end
        case 5 // Ending
            if %microdaq.private.connection_id > -1 then
                ipar_size = size(block.ipar,'r');
                channel = block.ipar(2:block.ipar(1)+1)';
                ao_range = block.ipar(2+(2*block.ipar(1)):1+(3*block.ipar(1)))';
                term_voltage = block.rpar(1+block.ipar(1):(block.ipar(1)*2));
                use_init_term = block.ipar(2+(3*block.ipar(1)):1+(4*block.ipar(1)))';
                for i = 1:size(channel, '*')
                    if use_init_term(i) == 2 | use_init_term(i) == 3 then
                        mdaq_ao_write(%microdaq.private.connection_id, channel(i), ao_range(i), term_voltage(i))
                    end
                end
           end
        case 6 // Re-Initialisation
        case 9 // ZeroCrossing
        else // Unknown flag
        end
    end
endfunction
