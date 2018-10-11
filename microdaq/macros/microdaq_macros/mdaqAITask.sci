function task = mdaqAITask()
   task = tlist(["aitlist","init","start","read","stop","setTrigger", "sync"],..
                     mdaqAIScanInit,..
                     mdaqAIScanStart,..
                     mdaqAIScan,..
                     mdaqAIScanStop,..
                     mdaqAIScanTrigger,..
                     mdaqAIScanSync);
endfunction



