function block=mdaq_dio_config_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case -5 // Error
        case 0 // Derivative State Update
        case 1 // Output Update
        case 2 // State Update
        case 3 // OutputEventTiming
        case 4 // Initialization
            if %microdaq.private.connection_id > -1 then
                // This option is not available on MicroDaq E2000
                if %microdaq.private.mdaq_hwid(1) <> 2000 then
                    if block.ipar(7) == 0 then
                        mdaq_dio_dir(%microdaq.private.connection_id, 1, 1);
                    end

                    if block.ipar(7) <> 0 then
                        mdaq_dio_dir(%microdaq.private.connection_id, 1, 0);
                    end

                    if block.ipar(8) == 0 then
                        mdaq_dio_dir(%microdaq.private.connection_id, 2, 1);
                    end

                    if block.ipar(8) <> 0 then
                        mdaq_dio_dir(%microdaq.private.connection_id, 2, 0);
                    end

                    if block.ipar(9) == 0 then
                        mdaq_dio_dir(%microdaq.private.connection_id, 3, 1);
                    end

                    if block.ipar(9) <> 0 then
                        mdaq_dio_dir(%microdaq.private.connection_id, 3, 0);
                    end

                    if block.ipar(10) == 0 then
                        mdaq_dio_dir(%microdaq.private.connection_id, 4, 1);
                    end

                    if block.ipar(10) <> 0 then
                        mdaq_dio_dir(%microdaq.private.connection_id, 4, 0);
                    end
                end
                mdaq_dio_func(%microdaq.private.connection_id, 1, block.ipar(1));
                mdaq_dio_func(%microdaq.private.connection_id, 2, block.ipar(2));
                mdaq_dio_func(%microdaq.private.connection_id, 3, block.ipar(3));
                mdaq_dio_func(%microdaq.private.connection_id, 4, block.ipar(4));
                mdaq_dio_func(%microdaq.private.connection_id, 5, block.ipar(5));
                mdaq_dio_func(%microdaq.private.connection_id, 6, block.ipar(6));
            end
        case 5 // Ending
        case 6 // Re-Initialisation
        case 9 // ZeroCrossing
        else // Unknown flag
        end
    end
endfunction
