function task = mdaqAOTask()
   task = tlist(["aotlist","init","start","write","stop","isDone","wait", "trigger"],..
                     mdaqAOScanInit,..
                     mdaqAOScanStart,..
                     mdaqAOScanData,..
                     mdaqAOScanStop,..
                     mdaqAOScanIsDone,..
                     mdaqAOScanWait,..
                     mdaqAOScanTrigger);
endfunction



