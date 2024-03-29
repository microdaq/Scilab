function mdaqLEDWrite(arg1, arg2, arg3)
    
    if argn(2) == 2 then
        led = arg1; 
        state = arg2; 
    end
    
    if argn(2) == 3 then
        link_id = arg1;   
        led = arg2; 
        state = arg3; 

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    if argn(2) > 3 | argn(2) < 2 | led > 2 | led < 1 then
        mprintf("Description:\n");
        mprintf("\tSets MicroDAQ D1 and D2 LED state\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqLEDWrite(linkID, led, state);\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tled - LED number (1|2)\n");
        mprintf("\tstate - LED state (%s|%s or 0|1)\n", "%F", "%T");
        return;
    end

    if type(state) == 4 then
        if state then
            state = 1;
        else 
            state = 0; 
        end
    else
        if state <> 0 then
           state = 1;  
        end
    end

    if argn(2) == 2 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end

    result = call("sci_mlink_led_set",..
            link_id, 1, "i",..
            led, 2, "i",..
            state, 3, "i",..
        "out",..
            [1, 1], 4, "i");

    if argn(2) == 2 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
