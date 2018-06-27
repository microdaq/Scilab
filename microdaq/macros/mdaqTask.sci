function task = mdaqTask(task_type)
    
    if argn(2) <> 1 then
        error("Wrong number of input arguments")
    end
    
    select task_type 
    case "ai" then
       task = tlist(["aitlist","init","start","read","stop","setTrigger"],..
                         mdaqAITaskInit,..
                         mdaqAITaskStart,..
                         mdaqAITaskRead,..
                         mdaqAITaskStop,..
                         mdaqAITaskTrigger);
 
    case "ao" then
       task = tlist(["aotlist","init","start","write","stop","isDone","waitUntilDone", "setTrigger"],..
                         mdaqAOTaskInit,..
                         mdaqAOTaskStart,..
                         mdaqAOTaskWrite,..
                         mdaqAOTaskStop,..
                         mdaqAOIsDone,..
                         mdaqAOWaitUntilDone,..
                         mdaqAOTaskTrigger);
        
    case "dsp" then
       task = tlist(["dsptlist","init","start","read","write","stop","isDone","waitUntilDone"],..
                         mdaqDSPTaskInit,..
                         mdaqDSPTaskStart,..
                         mdaqDSPTaskRead,..
                         mdaqDSPTaskWrite,..
                         mdaqDSPTaskStop,..
                         mdaqDSPIsDone,..
                         mdaqDSPWaitUntilDone);
    else
        error("Unsupported task type");
    end
endfunction



