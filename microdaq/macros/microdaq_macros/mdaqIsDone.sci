function res = mdaqIsDone(arg1, arg2)
    res = [];
    supported_task = ["dsp", "ai", "ao"];
    
    if argn(2) == 1 then
        if type(arg1) <> 10 then
            error("String expected"); 
        end
        
        task = convstr(arg1, "l");
    end
    
    if argn(2) == 2 then
        link_id = arg1;   
        if type(arg2) <> 10 then
            error("String expected"); 
        end

        task = convstr(arg2, "l");; 
        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    if argn(2) > 2 | argn(2) < 1 then
        mprintf("Description:\n");
        mprintf("\tChecks if operation is done\n");
        mprintf("Usage:\n");
        mprintf("\tstate = mdaqIsDone(linkID, module)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tmodule - module name which operation is performed (""ai"" | ""ao"" | ""dsp"")\n");
        return;
    end

    if find(supported_task == task) == [] then
        error("Unsupported operation"); 
    end
    
    if argn(2) == 1 then
        link_id = mdaqOpen();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
        
    func = "sci_mlink_" + task + "_is_done";
    result = call(func,..
                link_id, 1, "i",..
            "out",..
                [1,1], 2, "i");

    if argn(2) == 1 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
    
    if result > 0 then
        res = %t;
    else
        res = %f; 
    end
endfunction
