function  mdaqWaitUntilDone(arg1, arg2, arg3)
    link_id = -1; 
    supported_task = {"dsp", "ai", "ao"};
    
    if argn(2) == 2 then;  
        if type(arg1) <> 10 then
            error("String expected"); 
        end
        task =  convstr(arg1, "l");
        timeout = arg2; 
    end
    
    if argn(2) == 3 then
        if link_id < 0 then
            error("Invalid connection id!")
        end
        
        link_id = arg1; 
        
        if type(arg1) <> 10 then
            error("String expected"); 
        end
        
        task =  convstr(arg2, "l");
        timeout = arg3;
    end

    if argn(2) > 3 | argn(2) < 2 then
        mprintf("Description:\n");
        mprintf("\tWaits until operation is done\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqWaitUntilDone(linkID, module, timeout)\n")
        mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tmodule - name of module which performs operation\n");
        mprintf("\t\t""ai"" - data acquisistion from analog inputs\n");
        mprintf("\t\t""ao"" - signal generation on analog output\n");
        mprintf("\t\t""dsp"" - DSP application execution\n");
        mprintf("\ttimeout - amount of time in seconds (-1 - infinity)\n");
        return;
    end
    
    if find(supported_task == task) == [] then
        error("Unsupported operation"); 
    end
    
    if timeout < 0 then
        timeout = -1;
    end
    
    if timeout > 0 then
        timeout = timeout * 1000; 
    end
    
    if argn(2) == 2 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!");
        end
    end
    

    func = "sci_mlink_" + task + "_wait_until_done";
    result = call(func,..
                link_id, 1, "i",..
                timeout, 2, "i",..
            "out",..
                [1,1], 3, "i");
    
    if argn(2) == 2 then
        mdaqClose(link_id);
    end

    if result < 0 then
        error(mdaq_error2(result), 10000 + abs(result))         
    end

endfunction
