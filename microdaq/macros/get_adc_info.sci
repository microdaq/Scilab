function adc_info = get_adc_info(hwid)
    adc_unknown = struct(..
            "id", 0, ..
            "channel", "Unknown",..
            "rate", "Unknown",..
            "resolution", "Unknown",..
            "range", "Unknown",..
            "range_desc", "Unknown")
                     
    adc_lookup = list(),
    adc_info = adc_unknown,
    
    if hwid(1) == 2000 then
        //MDAQ E2000   
        adc_lookup(1) = struct(..
            "id", 1,..
            "channel", "8",..
            "rate", "166ksps",..
            "resolution", "16-bit",..
            "range", ["0-5V";" 0-10V"; "±5V";"±10V"]..
        );
        
        adc_lookup(2) = struct(..
            "id", 2,..
            "channel", "8",..
            "rate", "600ksps",..
            "resolution", "12-bit",..
            "range", ["±5V"; "±10V"]..
        );
        
        adc_lookup(3) = struct(..
            "id", 3,..
            "channel", "16",..
            "rate", "600ksps",..
            "resolution", "12-bit",..
            "range", ["±5V"; "±10V"]..
        );
        
        adc_lookup(4) = struct(..
            "id", 4,..
            "channel", "8",..
            "rate", "500ksps",..
            "resolution", "16-bit",..
            "range", ["±5V"; "±10V"]..
        );
        
        adc_lookup(5) = struct(..
            "id", 5,..
            "channel", "16",..
            "rate", "500ksps",..
            "resolution", "16-bit",..
            "range", ["±5V"; "±10V"]..
        );
        
         adc_lookup(6) = struct(..
            "id", 6,..
            "channel", "2",..
            "rate", "4000ksps",..
            "resolution", "16-bit",..
            "range", ["±5V"; "±10V"]..
        );
    
        
        try
            adc_info = adc_lookup(hwid(2));
        catch
            disp('Cannot find MDAQ-E2000 ADC info.');
            adc_info = adc_unknown;
        end   
        
    elseif hwid(1) == 1100 then 
        //MDAQ E1100
         adc_lookup(1) = struct(..
            "id", 1,..
            "channel", "8",..
            "rate", "166ksps",..
            "resolution", "12-bit",..
            "range", ["0-5V"; "0-10V"; "±5V";" ±10V"]..
        );
        
         adc_lookup(2) = struct(..
            "id", 2,..
            "channel", "8",..
            "rate", "166ksps",..
            "resolution", "16-bit",..
            "range", ["0-5V"; "0-10V"; "±5V";" ±10V"]..
        );
          
        try
            adc_info = adc_lookup(hwid(2));
        catch
            disp('Cannot find MDAQ-E1100 ADC info.');
            adc_info = adc_unknown;
        end    
    elseif hwid(1) == 1000 then 
        //MDADQ E1000
    end 
    
    //build one string with range description
    adc_range = adc_info.range(1);
    for i=2:max(size(adc_info.range))
          adc_range = adc_range+" | "+adc_info.range(i);
    end
    adc_info.range_desc = adc_range;
endfunction
