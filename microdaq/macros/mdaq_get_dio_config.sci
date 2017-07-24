function dio_count = mdaq_get_dio_config()
    dio_count = -1;
    global %microdaq; 
    mdaq_model = %microdaq.private.mdaq_hwid(1);
    mdaq_adc_config = %microdaq.private.mdaq_hwid(2);
    if mdaq_model == 2000 | mdaq_model == 1000 then
        dio_count = 16; 
    end

    if (mdaq_model == 2000 | mdaq_model == 1000) & mdaq_adc_config == 1 then
        dio_count = 32; 
    end
    
    if mdaq_model == 1100 then
        dio_count = 32; 
    end
endfunction
