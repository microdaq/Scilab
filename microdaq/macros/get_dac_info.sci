function dac_info = get_dac_info(hwid)
c_params_struct = struct(..
        "c_number", [],..
        "c_range_desc", [],..
        "c_range_value", [],..
        "c_range", []); 
 
c_params_e1xxx = list();
c_params_e2000 = list();

c_params_e1xxx(1) = struct(..
        "c_number", [1;2],..
        "c_range_desc", ["0-5V"],..
        "c_range_value", [0,5],..
        "c_range", [1]);

c_params_e2000(1) = struct(..
        "c_number", [1],..
        "c_range_desc", ["0-5V"],..
        "c_range_value", [0,5],..
        "c_range", [1]);

c_params_e2000(2) = struct(..
        "c_number", [2; 3; 4; 5; 6; 7],..
        "c_range_desc", ["±10V"; "±5V"; "±2.5V"; "0-10V"; "0-5V"],..
        "c_range_value", [[-10,10];[-5,5]; [-2.5,2.5]; [0,10]; [0,5]],..
        "c_range", [3, 2, 4, 1, 0]);

    dac_unknown = struct(..
            "id", 0,..
            "comment", "",..
            "channel", "Unknown",..
            "resolution", "Unknown",..
            "range", "Unknown",..
            "range_desc", "Unknown",..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range_value", [],..
                    "c_range", []));
                     
    dac_lookup = list();
    dac_info = dac_unknown;
    
    if hwid(1) == 2000 | hwid(1) == 1000 then
        //MDAQ E2000   
        dac_lookup(1) = struct(..
            "id", 1,..
            "comment", "",..
            "channel", "8",..
            "resolution", "12-bit",..
            "range", ["0-5V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range_value", [],..
                    "c_range", []));
        
        dac_lookup(2) = struct(..
            "id", 2,..
            "comment", "",..
            "channel", "8",..
            "resolution", "12-bit",..
            "range", ["±10V"; "±5V"; "±2.5V"; "0-10V"; "0-5V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range_value", [],..
                    "c_range", []));
        
        dac_lookup(3) = struct(..
            "id", 3,..
            "comment", "",..
            "channel", "8",..
            "resolution", "16-bit",..
            "range", ["±10V"; "±5V"; "±2.5V"; "0-10V"; "0-5V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range_value", [],..
                    "c_range", []));
        
        dac_lookup(4) = struct(..
            "id", 4,..
            "comment", "",..
            "channel", "16",..
            "resolution", "12-bit",..
            "range", ["±10V"; "±5V"; "±2.5V"; "0-10V"; "0-5V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range_value", [],..
                    "c_range", []));
        
        dac_lookup(5) = struct(..
            "id", 5,..
            "comment", "",..
            "channel", "16",..
            "resolution", "16-bit",..
            "range", ["±10V"; "±5V"; "±2.5V"; "0-10V"; "0-5V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range_value", [],..
                    "c_range", []));
                    
         dac_lookup(6) = struct(..
            "id", 6,..
            "comment", "",..
            "channel", "4",..
            "resolution", "12-bit",..
            "range", ["±10V"; "±5V"; "±2.5V"; "0-10V"; "0-5V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range_value", [],..
                    "c_range", []));
             
         dac_lookup(7) = struct(..
            "id", 7,..
            "comment", "",..
            "channel", "4",..
            "resolution", "16-bit",..
            "range", ["±10V"; "±5V"; "±2.5V"; "0-10V"; "0-5V"],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range_value", [],..
                    "c_range", []));

        try
            dac_info = dac_lookup(hwid(3));
        catch
            disp('Cannot read MicroDAQ analog output settings.');
            dac_info = dac_unknown;
        end   
    elseif hwid(1) == 1100 then 
        //MDAQ E1100
         dac_lookup(1) = struct(..
            "id", 1,..
            "comment", "",..
            "channel", "8",..
            "resolution", "12-bit",..
            "range", ["0-5V";],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range", []));
                    
         dac_lookup(2) = struct(..
            "id", 2,..
            "comment", "",..
            "channel", "8",..
            "resolution", "16-bit",..
            "range", ["0-5V";],..
            "c_params", struct(..
                    "c_number", [],..
                    "c_range_desc", [],..
                    "c_range_value", [],..
                    "c_range", []));
        try
            dac_info = dac_lookup(hwid(3));
        catch
            disp('Cannot read MicroDAQ analog output settings.');
            dac_info = dac_unknown;
        end    
    end 

    if hwid(1) == 1100 then
        for i = 1:size(c_params_e1xxx)
            if find(c_params_e1xxx(i).c_number == hwid(3)) <> [] then
                dac_info.c_params = c_params_e1xxx(i)  
            end
        end
    elseif hwid(1) == 2000 | hwid(1) == 1000
        for i = 1:size(c_params_e2000)
            if find(c_params_e2000(i).c_number == hwid(3)) <> [] then
                dac_info.c_params = c_params_e2000(i)    
            end
        end
    end
    
    //build one string with range description
    dac_range = dac_info.range(1);
    for i=2:max(size(dac_info.range))
          dac_range = dac_range+" | "+dac_info.range(i);
    end
    dac_info.range_desc = dac_range;
endfunction
