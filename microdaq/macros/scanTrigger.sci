function scanTrigger(trigger, varargin)
    result = -1; 
    supported_trig = ["none", "dio", "dioPattern", "encoder", "dsp", "ai", "ao"];

    if trigger <> 1 & trigger <> 2 then
        error("Unsupported trigger"); 
    end

    if argn(2) == 1 then
        mprintf("Description:\n");
        if trigger == 1 then 
            mprintf("\tConfigures data acquisition start trigger\n");
            mprintf("Usage:\n");
            mprintf("\tmdaqAITaskTrigger(linkID, triggerType, p1,...,pn);\n")
        elseif trigger == 2 then
            mprintf("\tSets AO task start trigger\n");
            mprintf("Usage:\n");
            mprintf("\tmdaqAOTaskTrigger(linkID, triggerType, p1,...,pn);\n")
        end
      mprintf("\tlinkID - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\ttriggerType - string with trigger source type\n"); 
        mprintf("\t    ""%s"" - disables trigger\n", supported_trig(1)); 
        mprintf("\t    ""%s"" - triggers, when on single DIO line (p1) a value (p2) is present\n", supported_trig(2)); 
        mprintf("\t    ""%s"" - triggers, when digital pattern (p1) is present on DIO1-8\n", supported_trig(3)); 
		mprintf("\t    ""%s"" - triggers, when encoder counter value of module (p1) is lower/greater (p3) then value (p2)\n", supported_trig(4));
        mprintf("\t    ""%s"" - triggers, when Xcos generated application is started on DSP\n", supported_trig(5)); 
        if trigger == 1 then 
            mprintf("\t    ""%s"" - triggers, when signal generation is started\n", supported_trig(7)); 
        elseif trigger == 2 then
            mprintf("\t    ""%s"" - triggers, when data acquisition is started \n", supported_trig(6)); 
        end   
        return;
    end

    if type(varargin(1)) == 1 then
        if argn(2) < 3 then
            error("Wrong number of input arguments"); 
        end

        if type(varargin(2)) <> 10 then
            error("Trigger type expected"); 
        end

        if find(supported_trig == varargin(2)) == [] then
            error("Unsupported trigger type"); 
        end

        link_id = varargin(1);        
        trig_type = varargin(2);
    else 
        if type(varargin(1)) <> 10 then
            error("Trigger type expected"); 
        end

        if find(supported_trig == varargin(1)) == [] then
            error("Unsupported trigger type"); 
        end
      
        trig_type = varargin(1);
    end



    if trig_type == "none" then
        
        if  type(varargin(1)) == 10 then
            link_id = mdaqOpen();
            if link_id < 0  then
                error(mdaq_error2(link_id), 10000 + abs(link_id)); 
            end
        end

        result = call("sci_mlink_scan_trigger_clear",..
                        link_id, 1, "i",..
                        trigger, 2, "i",..
                    "out",..
                        [1, 1], 3, "i");
    end



    if trig_type == "ai" | trig_type == "ao" | trig_type == "dsp" then
        if trigger == 1 then
            if trig_type == "ai" then
                error("Unable to use ""ai"" trigger for AI scan"); 
            end
        end
        
        if trigger == 2 then
            if trig_type == "ao" then
                error("Unable to use ""ao"" trigger for AO scan"); 
            end
        end

        if trig_type == "ai" | trig_type == "ao" then
            src = 2; 
        else
            src = 3; 
        end
        
        if  type(varargin(1)) == 10 then
            link_id = mdaqOpen();
            if link_id < 0  then
                error(mdaq_error2(link_id), 10000 + abs(link_id)); 
            end
        end

        result = call("sci_mlink_scan_trigger_external_start",..
                        link_id, 1, "i",..
                        trigger, 2, "i",..
                        src, 3, "i",..
                    "out",..
                        [1, 1], 4, "i");
    end
    
    //// DIO Trigger ////
    if trig_type == "dio" then 
        if type(varargin(1)) == 1 then
            if argn(2) <> 5  then
                error("Wrong number of input arguments")
            end
        end

        if type(varargin(1)) == 10 then
            if argn(2) <> 4  then
                error("Wrong number of input arguments")
            end
        end

        if type(varargin(argn(2) - 2)) <> 1 then
            error("Wrong argument type - DIO channel number expected"); 
        end
        
        if type(varargin(argn(2) - 1)) <> 1 then
            error("Wrong argument type - DIO channel number expected"); 
        end        
        
        dio = varargin(argn(2) - 2); 
        level = varargin(argn(2) - 1);
        
     
        if level <> 0 then 
            level = 1;
        end
        
        if  type(varargin(1)) == 10 then
            link_id = mdaqOpen();
            if link_id < 0  then
                error(mdaq_error2(link_id), 10000 + abs(link_id)); 
            end
        end
        
        result = call("sci_mlink_scan_trigger_dio",..
                        link_id, 1, "i",..
                        trigger, 2, "i",..
                        dio, 3, "i",..
                        level, 4, "i",..
                    "out",..
                        [1, 1], 5, "i");
    end
    
    
    //// DIO PATTERN Trigger ////
    if trig_type == "dioPattern" then 
        if type(varargin(1)) == 1 then
            if argn(2) <> 4  then
                error("Wrong number of input arguments")
            end
        end

        if type(varargin(1)) == 10 then
            if argn(2) <> 3  then
                error("Wrong number of input arguments")
            end
        end

        pattern = varargin(argn(2) - 1);
        
        if length(pattern) <> 8 then 
            error("Wrong pattern - 8 character length string including 0,1,x is expected"); 
        end

        if  type(varargin(1)) == 10 then
            link_id = mdaqOpen();
            if link_id < 0  then
                error(mdaq_error2(link_id), 10000 + abs(link_id)); 
            end
        end
        
        result = call("sci_mlink_scan_trigger_dio_pattern",..
                        link_id, 1, "i",..
                        trigger, 2, "i",..
                        pattern, 3, "c",..
                        length(pattern), 4, "i",..
                    "out",..
                        [1, 1], 5, "i");
    end
    

    //// ENCODER Trigger ////
    if trig_type == "encoder" then 
        if type(varargin(1)) == 1 then
            if argn(2) <> 6  then
                error("Wrong number of input arguments")
            end
        end

        if type(varargin(1)) == 10 then
            if argn(2) <> 5  then
                error("Wrong number of input arguments")
            end
        end

        module =   varargin(argn(2) - 3);
        position = varargin(argn(2) - 2);
        slope =    varargin(argn(2) - 1);

        if slope <> 0 then 
            slope = 1; 
        end
        
        if  type(varargin(1)) == 10 then
            link_id = mdaqOpen();
            if link_id < 0  then
                error(mdaq_error2(link_id), 10000 + abs(link_id)); 
            end
        end
        
        result = call("sci_mlink_scan_trigger_encoder",..
                        link_id, 1, "i",..
                        trigger, 2, "i",..
                        module,  3, "i",..
                        position, 4, "i",..
                        slope, 5, "i",..
                    "out",..
                        [1, 1], 6, "i");
    end

    if  type(varargin(1)) == 10 then
        mdaqClose(link_id);
    end

    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end

endfunction
