
function test()
    params = list();
    
    mprintf("\n****WITHOUT LINK_ID PARAM****");
    
    //SHOULD PASS
    mprintf("\n****SHOULD PASS****");
    params($+1) = struct("pru_core", 0, "pru_reg", 0, "pru_value", int(rand()*10000));
    params($+1) = struct("pru_core", 0, "pru_reg", 15, "pru_value", int(rand()*10000));
    
    params($+1) = struct("pru_core", 1, "pru_reg", 0, "pru_value", int(rand()*10000));
    params($+1) = struct("pru_core", 1, "pru_reg", 15, "pru_value", int(rand()*10000));
    
   
    for i=1:size(params)
        mprintf("\n\n");
        input("Press any key to run test.");
        mprintf("PWM TEST PARAMS:\npru_core: %d, pru_reg: %d, pru_value: %d",...
        params(i).pru_core, params(i).pru_reg, params(i).pru_value);

        mdaq_pru_set(params(i).pru_core, params(i).pru_reg, params(i).pru_value);
        out = mdaq_pru_get(params(i).pru_core, params(i).pru_reg);
        
        if( out == params(i).pru_value) then 
            mprintf("--------PASSED-------\n\n");
        else      
            disp(string(out)+"<>"+string(params(i).pru_value)+"!");
            mprintf("--------FAILED-------\n\n");
        end     
    end
    
    params = list();
    
    //SHOULD FAIL
    mprintf("\n****SHOULD FAIL****");
    params($+1) = struct("pru_core", 1, "pru_reg", 0, "pru_value", -10.88);
    params($+1) = struct("pru_core", 1, "pru_reg", 15, "pru_value", 99.123);
    
    for i=1:size(params)
        mprintf("\n\n");
        input("Press any key to run test.");
        mprintf("PWM TEST PARAMS:\npru_core: %d, pru_reg: %d, pru_value: %f",...
        params(i).pru_core, params(i).pru_reg, params(i).pru_value);

        mdaq_pru_set(params(i).pru_core, params(i).pru_reg, params(i).pru_value);
        out = mdaq_pru_get(params(i).pru_core, params(i).pru_reg);
        
        if( out == params(i).pru_value) then 
            mprintf("--------PASSED-------\n\n");
        else      
            disp(string(out)+"<>"+string(params(i).pru_value)+"!");
            mprintf("--------FAILED-------\n\n");
        end     
    end
    
    //Wrong params 
    mprintf("\nWRONG PARAMS\n");
    mdaq_pru_set(12, 0, 7788);
    mdaq_pru_get(-12, 0);
    
    mdaq_pru_set(0, -1, 7788);
    mdaq_pru_get(0, 51);
endfunction

test();
clear test;





//With LINK ID 
function test()
    link_id = mdaq_open();
    disp("link_id = " + string(link_id));
    params = list();
    
    mprintf("\n****WITH LINK_ID PARAM****");
    //SHOULD PASS
    mprintf("\n****SHOULD PASS****");
    params($+1) = struct("pru_core", 0, "pru_reg", 0, "pru_value", int(rand()*10000));
    params($+1) = struct("pru_core", 0, "pru_reg", 15, "pru_value", int(rand()*10000));
    
    params($+1) = struct("pru_core", 1, "pru_reg", 0, "pru_value", int(rand()*10000));
    params($+1) = struct("pru_core", 1, "pru_reg", 15, "pru_value", int(rand()*10000));
    
   
    for i=1:size(params)
        mprintf("\n\n");
        input("Press any key to run test.");
        mprintf("PWM TEST PARAMS:\npru_core: %d, pru_reg: %d, pru_value: %d",...
        params(i).pru_core, params(i).pru_reg, params(i).pru_value);

        mdaq_pru_set(link_id, params(i).pru_core, params(i).pru_reg, params(i).pru_value);
        out = mdaq_pru_get(link_id, params(i).pru_core, params(i).pru_reg);
        
        if( out == params(i).pru_value) then 
            mprintf("--------PASSED-------\n\n");
        else      
            disp(string(out)+"<>"+string(params(i).pru_value)+"!");
            mprintf("--------FAILED-------\n\n");
        end     
    end
    
    params = list();
    
    //SHOULD FAIL
    mprintf("\n****SHOULD FAIL****");
    params($+1) = struct("pru_core", 1, "pru_reg", 0, "pru_value", -10.88);
    params($+1) = struct("pru_core", 1, "pru_reg", 15, "pru_value", 99.123);
    
    for i=1:size(params)
        mprintf("\n\n");
        input("Press any key to run test.");
        mprintf("PWM TEST PARAMS:\npru_core: %d, pru_reg: %d, pru_value: %f",...
        params(i).pru_core, params(i).pru_reg, params(i).pru_value);

        mdaq_pru_set(link_id, params(i).pru_core, params(i).pru_reg, params(i).pru_value);
        out = mdaq_pru_get(link_id, params(i).pru_core, params(i).pru_reg);
        
        if( out == params(i).pru_value) then 
            mprintf("--------PASSED-------\n\n");
        else      
            disp(string(out)+"<>"+string(params(i).pru_value)+"!");
            mprintf("--------FAILED-------\n\n");
        end     
    end
    
    //Wrong params 
    mprintf("\nWRONG PARAMS\n");
    mdaq_pru_set(link_id, 12, 0, 7788);
    mdaq_pru_get(link_id, -12, 0);
    
    mdaq_pru_set(link_id, 0, -1, 7788);
    mdaq_pru_get(link_id, 0, 51);
    
    mdaq_close(link_id);
endfunction

test();
clear test;
