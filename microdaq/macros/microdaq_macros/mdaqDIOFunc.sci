function mdaqDIOFunc(arg1, arg2, arg3)
    
    if argn(2) == 2 then
        func = arg1; 
        enable = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1;   
        func = arg2; 
        enable = arg3; 

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end
    
    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tConfigures DIO function\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqDIOFunc(linkID, dioFunction, isEnabled);\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tdioFunction - DIO alternative function (string)\n");
        mprintf("\t\t""enc1"" : DIO1 - Channel A, DIO2 - Channel B\n");
        mprintf("\t\t""enc2"" : DIO3 - Channel A, DIO4 - Channel B\n");
        mprintf("\t\t""pwm1"" : DIO10 - Channel A, DIO11 - Channel B \n");
        mprintf("\t\t""pwm2"" : DIO12 - Channel A, DIO13 - Channel B \n");
        mprintf("\t\t""pwm3"" : DIO14 - Channel A, DIO15 - Channel B\n");
        mprintf("\t\t""uart"" : DIO8 - Rx, DIO9 - Tx\n");
        mprintf("\tisEnabled - function state (%s/%s to enable/disable function)\n", "%T", "%F");
        return;
    end
    
    dio_func = func; 
    if type(func) == 10 then
        func = convstr(func, "l")
        select func
        case "enc1" then
            dio_func = 1;
        case "enc2" then
            dio_func = 2;
        case "pwm1" then
            dio_func = 3;
        case "pwm2" then
            dio_func = 4;
        case "pwm3" then
            dio_func = 5;
        case "uart" then
            dio_func = 6;
        else
            error("Unsupported DIO function")
        end
    else
        if func < 0 | func > 6 then
            error("Unsupported DIO function")
        end
        dio_func = func;
    end

    if type(enable) == 4 then
        if enable then
            enable = 1;
        else 
            enable = 0; 
        end
    else
        if enable <> 0 then
           enable = 1;  
        end
    end
    
    if argn(2) == 2 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end
    
    result = call("sci_mlink_dio_set_func",..
            link_id, 1, "i",..
            func, 2, "i",..
            enable, 3, "i",..
        "out",..
            [1, 1], 4, "i");
            
    if argn(2) == 2 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
