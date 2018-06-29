function task = mdaqAOTask()
   task = tlist(["aotlist","init","start","write","stop","isDone","waitUntilDone", "setTrigger"],..
                     mdaqAOTaskInit,..
                     mdaqAOTaskStart,..
                     mdaqAOTaskWrite,..
                     mdaqAOTaskStop,..
                     mdaqAOIsDone,..
                     mdaqAOWaitUntilDone,..
                     mdaqAOTaskTrigger);
endfunction



