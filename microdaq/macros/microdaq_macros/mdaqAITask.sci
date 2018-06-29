function task = mdaqAITask()
   task = tlist(["aitlist","init","start","read","stop","setTrigger"],..
                     mdaqAITaskInit,..
                     mdaqAITaskStart,..
                     mdaqAITaskRead,..
                     mdaqAITaskStop,..
                     mdaqAITaskTrigger);
endfunction



