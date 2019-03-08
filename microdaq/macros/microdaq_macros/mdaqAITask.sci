function task = mdaqAITask()
   task = tlist(["aitlist","init","start","read","stop","trigger", "sync"],..
                     mdaqAIScanInit,..
                     mdaqAIScanStart,..
                     mdaqAIScanRead,..
                     mdaqAIScanStop,..
                     mdaqAIScanTrigger,..
                     mdaqAIScanSync);
endfunction



