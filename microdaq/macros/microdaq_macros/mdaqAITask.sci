function task = mdaqAITask()
   task = tlist(["aitlist","init","start","read","stop","setTrigger"],..
                     mdaqAIScanInit,..
                     mdaqAIScanStart,..
                     mdaqAIScan,..
                     mdaqAIScanStop,..
                     mdaqAIScanTrigger);
endfunction



