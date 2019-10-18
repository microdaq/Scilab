
function task = mdaqTask(task_type)
    funcprot(1)
    select task_type 
    case "ai" then
       task = tlist(["ai_tlist","init","start","read","stop","setTrigger"],..
                         mdaqAITaskInit,..
                         mdaqAITaskStart,..
                         mdaqAITaskRead,..
                         mdaqAITaskStop,..
                         mdaqAITaskTrigger);
 
    case "ao" then
       task = tlist(["ao_tlist","init","start","write","stop","isDone","waitUntilDone", "setTrigger"],..
                         mdaqAOTaskInit,..
                         mdaqAOTaskStart,..
                         mdaqAOTaskWrite,..
                         mdaqAOTaskStop,..
                         mdaqAOIsDone,..
                         mdaqAOWaitUntilDone,..
                         mdaqAOTaskTrigger);
        
    case "dsp" then
       task = tlist(["dsp_tlist","init","start","read", "write","stop","isDone","waitUntilDone"],..
                         mdaqDSPTaskInit,..
                         mdaqDSPTaskStart,..
                         mdaqDSPTaskRead,..
                         mdaqDSPTaskWrite,..
                         mdaqDSPTaskStop,..
                         mdaqDSPIsDone,..
                         mdaqDSPWaitUntilDone);

    end
endfunction



