function adc_info = get_adc_info(hwid)

c_params_struct = struct(..
        "c_number", [],..
        "c_range_desc", [],..
        "c_range", [],..
        "c_bipolar", [],..
        "c_diff", []); 

c_params_e1xxx = list();
c_params_e2000 = list();

c_params_e1xxx(1) = struct(..
        "c_number", [1],..
        "c_range_desc", ["±10V"; "±5V"; "0-10V"; "0-5V"],..
        "c_range", [0;1;0;1],..
        "c_bipolar", [24;24;25;25],..
        "c_diff", [1;1;1;1]); 
        
c_params_e1xxx(2) = struct(..
        "c_number", [2],..
        "c_range_desc", ["±10V"; "±5V"; "0-10V"; "0-5V"],..
        "c_range", [0;1;0;1],..
        "c_bipolar", [24;24;25;25],..
        "c_diff", [1;1;1;1]); 


c_params_e2000(1) = struct(..
        "c_number", [1],..
        "c_range_desc", ["±10V"; "±5V"; "0-10V"; "0-5V"],..
        "c_range", [0;1;0;1],..
        "c_bipolar", [24;24;25;25],..
        "c_diff", [1;1;1;1]); 

c_params_e2000(2) = struct(..
        "c_number", [2;3;4;5],..
        "c_range_desc", ["±10V"; "±5V"],..
        "c_range", [0;1],..
        "c_bipolar", [24;24],..
        "c_diff", [0;0]); 

c_params_e2000(3) = struct(..
        "c_number", [7;8;9;10;11;12],..
        "c_range_desc", ["±10.24V"; "±5.12V"; "±2.56V"; "±1.24V"; "±0.64V"],..
        "c_range", [0;1;2;3;4],..
        "c_bipolar", [24;24;24;24;24],..
        "c_diff", [1;1;1;1;1]); 

    adc_unknown = struct(..
            "id", 0, ..
            "channel", "Unknown",..
            "rate", "Unknown",..
            "resolution", "Unknown",..
            "range", "Unknown",..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
                     
    adc_lookup = list(),
    adc_info = adc_unknown,

    if hwid(1) == 2000 then
        //MDAQ E2000   
        adc_lookup(1) = struct(..
            "id", 1,..
            "channel", "8",..
            "rate", "166ksps",..
            "resolution", "16-bit",..
            "range", ["0-5V";" 0-10V"; "±5V";"±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
        
        adc_lookup(2) = struct(..
            "id", 2,..
            "channel", "8",..
            "rate", "600ksps",..
            "resolution", "12-bit",..
            "range", ["±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
        
        adc_lookup(3) = struct(..
            "id", 3,..
            "channel", "16",..
            "rate", "600ksps",..
            "resolution", "12-bit",..
            "range", ["±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
        
        adc_lookup(4) = struct(..
            "id", 4,..
            "channel", "8",..
            "rate", "500ksps",..
            "resolution", "16-bit",..
            "range", ["±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
        
        adc_lookup(5) = struct(..
            "id", 5,..
            "channel", "16",..
            "rate", "500ksps",..
            "resolution", "16-bit",..
            "range", ["±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
        
         adc_lookup(6) = struct(..
            "id", 6,..
            "channel", "2",..
            "rate", "4000ksps",..
            "resolution", "16-bit",..
            "range", ["±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
         
         adc_lookup(7) = struct(..
            "id", 7,..
            "channel", "8",..
            "rate", "1000ksps",..
            "resolution", "16-bit",..
            "range", ["±0.6V"; "±1.2V"; "±2.5V"; "±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
                    
         adc_lookup(8) = struct(..
            "id", 8,..
            "channel", "8",..
            "rate", "1000ksps",..
            "resolution", "16-bit",..
            "range", ["±1.2V"; "±2.5V"; "±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
                    
         adc_lookup(9) = struct(..
            "id", 9,..
            "channel", "16",..
            "rate", "1000ksps",..
            "resolution", "16-bit",..
            "range", ["±0.6V"; "±1.2V"; "±2.5V"; "±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
                    
         adc_lookup(10) = struct(..
            "id", 10,..
            "channel", "16",..
            "rate", "1000ksps",..
            "resolution", "16-bit",..
            "range", ["±1.2V"; "±2.5V"; "±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
                    
         adc_lookup(11) = struct(..
            "id", 11,..
            "channel", "32",..
            "rate", "1000ksps",..
            "resolution", "16-bit",..
            "range", ["±0.6V"; "±1.2V"; "±2.5V"; "±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
                    
         adc_lookup(12) = struct(..
            "id", 12,..
            "channel", "32",..
            "rate", "1000ksps",..
            "resolution", "16-bit",..
            "range", ["±1.2V"; "±2.5V"; "±5V"; "±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
                    

        try
            adc_info = adc_lookup(hwid(2));
        catch
            disp('Cannot find ADC info.');
            adc_info = adc_unknown;
        end   
        
    elseif hwid(1) == 1100 then 
        //MDAQ E1100
         adc_lookup(1) = struct(..
            "id", 1,..
            "channel", "8",..
            "rate", "166ksps",..
            "resolution", "12-bit",..
            "range", ["0-5V"; "0-10V"; "±5V";" ±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
        
         adc_lookup(2) = struct(..
            "id", 2,..
            "channel", "8",..
            "rate", "166ksps",..
            "resolution", "16-bit",..
            "range", ["0-5V"; "0-10V"; "±5V";" ±10V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", [],..
                    "c_bipolar", [],..
                    "c_diff", []));
          
        try
            adc_info = adc_lookup(hwid(2));
        catch
            disp('Cannot find ADC info.');
            adc_info = adc_unknown;
        end    
    elseif hwid(1) == 1000 then 
        //MDADQ E1000
    end 
    
    // assing c_params 

    if hwid(1) == 1100 | hwid(1) == 1000 then
        for i = 1:size(c_params_e1xxx)
            if find(c_params_e1xxx(i).c_number == hwid(2)) <> [] then
                adc_info.c_params = c_params_e1xxx(i)    
            end
        end
    elseif hwid(1) == 2000
        for i = 1:size(c_params_e2000)
            if find(c_params_e2000(i).c_number == hwid(2)) <> [] then
                adc_info.c_params = c_params_e2000(i)    
            end
        end
    end
    //build one string with range description
    adc_range = adc_info.range(1);
    for i=2:max(size(adc_info.range))
          adc_range = adc_range+" | "+adc_info.range(i);
    end
    adc_info.range_desc = adc_range;
endfunction
