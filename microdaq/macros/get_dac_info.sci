function dac_info = get_dac_info(hwid)
    dac_unknown = struct(..
            "id", 0,..
            "channel", "Unknown",..
            "resolution", "Unknown",..
            "range", "Unknown",..
            "range_desc", "Unknown"..
        );
                     
    dac_lookup = list();
    dac_info = dac_unknown;
    
    if hwid(1) == 2000 then
        //MDAQ E2000   
        dac_lookup(1) = struct(..
            "id", 1,..
            "channel", "8",..
            "resolution", "12-bit",..
            "range", ["0-5V"]..
        );
        
        dac_lookup(2) = struct(..
            "id", 2,..
            "channel", "8",..
            "resolution", "12-bit",..
            "range", ["±10V"]..
        );
        
        dac_lookup(3) = struct(..
            "id", 3,..
            "channel", "8",..
            "resolution", "16-bit",..
            "range", ["±10V"]..
        );
        
        dac_lookup(4) = struct(..
            "id", 4,..
            "channel", "16",..
            "resolution", "12-bit",..
            "range", ["0-5V"; "0-10V";"±2.5V"; "±5V"; "±10V"]..
        );
        
        dac_lookup(5) = struct(..
            "id", 5,..
            "channel", "16",..
            "resolution", "16-bit",..
            "range", ["0-5V"; "0-10V";"±2.5V"; "±5V"; "±10V"]..
        );
     
        
        try
            dac_info = dac_lookup(hwid(3));
        catch
            disp('Cannot find MDAQ-E2000 DAC info.');
            dac_info = dac_unknown;
        end   
    elseif hwid(1) == 1100 then 
        //MDAQ E1100
         dac_lookup(1) = struct(..
            "id", 1,..
            "channel", "8",..
            "resolution", "12-bit",..
            "range", ["0-5V";]..
        );
        
        try
            dac_info = dac_lookup(hwid(3));
        catch
            disp('Cannot find MDAQ-E1100 DAC info.')
            dac_info = dac_unknown;
        end    
    elseif hwid(1) == 1000 then 
        //MDADQ E1000
    end 
    
    
    //build one string with range description
    dac_range = dac_info.range(1);
    for i=2:max(size(dac_info.range))
          dac_range = dac_range+" | "+dac_info.range(i);
    end
    dac_info.range_desc = dac_range;
endfunction
